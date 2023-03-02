import 'dart:async';

import 'package:flutter/foundation.dart' show immutable;
import 'package:hive/hive.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:papa_burger/src/views/pages/main_page/services/restaurant_service.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class CartBloc {
  final LocalStorageRepository _localStorageRepository;
  final RestaurantService _restaurantService;

  CartBloc({
    LocalStorageRepository? localStorageRepository,
    RestaurantService? restaunratService,
  })  : _localStorageRepository =
            localStorageRepository ?? LocalStorageRepository(),
        _restaurantService = restaunratService ?? RestaurantService();

  final cartSubject = BehaviorSubject<CartState>.seeded(const CartState());
  final cartRestaurantIdSubject = BehaviorSubject<int>.seeded(0);

  Stream<CartState> get cartStream => cartSubject.stream;
  Stream<int> get idStream => cartRestaurantIdSubject.stream;

  CartState get state => cartSubject.value;
  Set<Item> get cartItems => state.cart.cartItems;
  int get id => cartRestaurantIdSubject.value;
  int get itemsLength => cartItems.toList().length;
  bool get cartEmpty => state.cart.cartEmpty;
  bool get lengthIsOne => itemsLength <= 1;
  bool inCart(Item item) => cartItems.contains(item);
  bool idEqual(int restaurantId) => id == restaurantId;
  bool idEqualToRemove(int restaurantId) => idEqual(restaurantId) || id == 0;

  Restaurant getRestaurantById(int id) => _restaurantService.restaurantById(id);

  Stream<CartState> get getItems {
    return cartSubject.distinct().asyncMap((state) async {
      try {
        Box boxCart = await _localStorageRepository.openBoxCart();
        final Set<Item> cachedItems =
            _localStorageRepository.getItemsFromStorage(boxCart);
        final newState = state.copyWith(
          cart: Cart(
            cartItems: {...state.cart.cartItems}..addAll(cachedItems),
          ),
        );
        cartSubject.sink.add(newState);
        return newState;
      } catch (e) {
        logger.e(e.toString());
        rethrow;
      }
    }).delay(const Duration(seconds: 1));
  }

  Stream<int> get restaurantId {
    return cartRestaurantIdSubject
        .distinct()
        .throttleTime(const Duration(seconds: 1), trailing: true)
        .asyncMap((cartRestId) async {
      try {
        Box restaurantId = await _localStorageRepository.openBoxRestaurantId();
        Box cart = await _localStorageRepository.openBoxCart();
        _localStorageRepository
            .getRestaurantIdFromStorage(restaurantId, cart)
            .listen((id) {
          logger.w('ID IS $id');
          cartRestId = id;
          cartRestaurantIdSubject.sink.add(cartRestId);
        });
        return cartRestId;
      } catch (e) {
        logger.e(e.toString());
        return 0;
      }
    });
  }

  Stream<CartState> get globalStream => Rx.combineLatest2(
        getItems,
        restaurantId,
        (cartState, cartRestaurantId) {
          final cartState$ = cartState as CartState;
          final cartRestaurantId$ = cartRestaurantId as int;
          return cartState$.copyWith(
            cart: Cart(
              cartItems: cartState$.cart.cartItems,
              restaurantId: cartRestaurantId$,
            ),
          );
        },
      );

  void addRestaurantIdToCart(int id) async {
    try {
      Box restaurantId = await _localStorageRepository.openBoxRestaurantId();
      _localStorageRepository.addRestaurantIdToCart(restaurantId, id);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  void addItemToCart(Item item) async {
    try {
      Box boxCart = await _localStorageRepository.openBoxCart();
      _localStorageRepository.addItemToCart(boxCart, item);
      final newState = state.copyWith(
        cart: Cart(
          cartItems: {...state.cart.cartItems}..add(item),
        ),
      );
      cartSubject.sink.add(newState);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  void removeItemFromCartItem(Item item) async {
    try {
      Box boxCart = await _localStorageRepository.openBoxCart();
      _localStorageRepository.removeItemFromCart(boxCart, item);
      final newState = state.copyWith(
        cart: Cart(
          cartItems: {...state.cart.cartItems}..remove(item),
        ),
      );
      cartSubject.sink.add(newState);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  void removeAllItemsFromCartAndRestaurantId() async {
    try {
      Box cart = await _localStorageRepository.openBoxCart();
      Box restaurant = await _localStorageRepository.openBoxRestaurantId();
      _localStorageRepository.removeAllItemsFromCart(cart);
      _localStorageRepository.setRestaurantIdInCartTo0(restaurant);
      final newState = state.copyWith(
        cart: Cart(
          cartItems: {...state.cart.cartItems}..removeAll(state.cart.cartItems),
          restaurantId: 0,
        ),
      );
      cartSubject.sink.add(newState);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  void dispose() {
    cartSubject.sink.close();
    cartRestaurantIdSubject.sink.close();
  }
}

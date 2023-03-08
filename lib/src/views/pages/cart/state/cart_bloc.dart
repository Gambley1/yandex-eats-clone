import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:papa_burger/src/views/pages/main_page/services/restaurant_service.dart';

class CartBloc {
  CartBloc();

  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  final RestaurantService _restaurantService = RestaurantService();

  final cartSubject = BehaviorSubject<CartState>.seeded(const CartState());
  final cartRestaurantIdSubject = BehaviorSubject<int>.seeded(0);

  ValueStream<CartState> get cartStream => cartSubject.stream;
  ValueStream<int> get idStream => cartRestaurantIdSubject.stream;

  late final state = cartSubject.value;
  Set<Item> get cartItems => state.cart.cartItems;
  int get id => cartRestaurantIdSubject.value;
  // int get itemsLength => cartItems.toList().length;
  // bool get cartEmpty => state.cart.cartEmpty;
  // bool get lengthIsOne => itemsLength <= 1;
  bool inCart(Item item) => cartItems.contains(item);
  bool idEqual(int restaurantId) => id == restaurantId;
  bool idEqualToRemove(int restaurantId) => idEqual(restaurantId) || id == 0;

  Restaurant getRestaurantById(int id) => _restaurantService.restaurantById(id);

  Stream<CartState> get getItems {
    return cartSubject.distinct().asyncMap((state) async {
      try {
        final Set<Item> cachedItems =
            await _localStorageRepository.getCartItems();
        final newState = state.copyWith(
          cart: Cart(
            cartItems: {...state.cart.cartItems}..addAll(cachedItems),
          ),
        );
        cartSubject.sink.add(newState);
        return newState;
      } catch (e) {
        logger.e(e.toString());
        cartSubject.addError(e.toString());
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
        final id = await _localStorageRepository.getRestId();
        logger.w('ID IS $id');
        cartRestId = id;
        cartRestaurantIdSubject.sink.add(id);
        return cartRestId;
      } catch (e) {
        logger.e(e.toString());
        cartRestaurantIdSubject.addError(e.toString());
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
      _localStorageRepository.addId(id);
    } catch (e) {
      logger.e(e.toString());
      cartRestaurantIdSubject.addError(e.toString());
    }
  }

  void addItemToCart(Item item) async {
    try {
      _localStorageRepository.addItem(item);
      final newState = state.copyWith(
        cart: Cart(
          cartItems: {...state.cart.cartItems}..add(item),
        ),
      );
      cartSubject.sink.add(newState);
    } catch (e) {
      logger.e(e.toString());
      cartSubject.addError(e.toString());
    }
  }

  void removeItemFromCartItem(Item item) async {
    try {
      _localStorageRepository.removeItem(item);
      final newState = state.copyWith(
        cart: Cart(
          cartItems: {...state.cart.cartItems}..remove(item),
        ),
      );
      cartSubject.sink.add(newState);
    } catch (e) {
      logger.e(e.toString());
      cartSubject.addError(e.toString());
    }
  }

  void removeAllItemsFromCartAndRestaurantId() async {
    try {
      _localStorageRepository.removeAllItems();
      _localStorageRepository.setRestIdTo0();
      final newState = state.copyWith(
        cart: Cart(
          cartItems: {...state.cart.cartItems}..removeAll(state.cart.cartItems),
        ),
      );
      cartSubject.sink.add(newState);
    } catch (e) {
      logger.e(e.toString());
      cartSubject.addError(e.toString());
    }
  }

  void dispose() {
    cartSubject.close();
    cartRestaurantIdSubject.close();
  }
}

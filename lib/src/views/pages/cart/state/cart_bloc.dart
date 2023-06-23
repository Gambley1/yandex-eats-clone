// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart' show BuildContext, ValueNotifier;
import 'package:papa_burger/src/restaurant.dart'
    show
        Cart,
        Item,
        LocalStorage,
        LocalStorageRepository,
        NavigatorExtension,
        Restaurant,
        RestaurantService;

class CartBloc extends ValueNotifier<Cart> {
  factory CartBloc() => _instance;

  CartBloc._privateConstructor(super.value) {
    if (value.cartEmpty) {
      _getItemsFromCache();
    }
  }
  static final CartBloc _instance = CartBloc._privateConstructor(
    const Cart(),
  );

  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  final RestaurantService _restaurantService = RestaurantService();

  Future<Restaurant> getRestaurant(String placeId) {
    final localStorage = LocalStorage.instance;
    final lat = localStorage.latitude;
    final lng = localStorage.longitude;
    return _restaurantService.getRestaurantByPlaceId(
      placeId,
      latitude: '$lat',
      longitude: '$lng',
    );
  }

  void decreaseQuantity(
    BuildContext context,
    Item item, {
    Restaurant? restaurant,
    bool forMenu = false,
  }) {
    if (value.cartItems[item]! > 1) {
      _decreaseQuantity(item);
    } else {
      removeItemFromCart(item).then(
        (_) {
          if (value.cartEmpty) {
            removePlaceIdInCacheAndCart();
            if (restaurant != null) {
              context.navigateToMenu(context, restaurant, fromCart: true);
            }
          }
        },
      );
    }
  }

  void increaseQuantity(Item item, [int? amount]) {
    if (_allowIncrease(item)) _increaseQuantity(item, amount);
  }

  bool allowIncrease(Item item) => _allowIncrease(item);

  Future<void> _getItemsFromCache() async {
    final cachedCartItems = _localStorageRepository.getCartItems;
    final restaurantPlaceId = _localStorageRepository.getRestPlaceId();
    value = value.copyWith(
      restaurantPlaceId: restaurantPlaceId,
      cartItems: {...value.cartItems}..addAll(cachedCartItems),
    );
  }

  Future<void> addItemToCart(Item item, {required String placeId}) async {
    // logger.w('++++ ADDING ITEM TO CART $item WITH PLACE ID $placeId ++++');
    // logger.w('ADD WITH ID? $withPlaceId');

    /// Adding item to local storage Hive.
    _localStorageRepository
      // ..addItem(item)
      ..addPlaceId(placeId)
      ..addItem(item);

    // logger.w('CART BEFORE ADDING ITEM $value');
    final newPlaceId = value.copyWith(
      restaurantPlaceId: placeId,
      cartItems: {...value.cartItems}..putIfAbsent(item, () => 1),
    );
    value = newPlaceId;
    // logger.w('++++ CART AFTER ADDING ITEM $value ++++');
  }

  void _increaseQuantity(Item item, [int? amount]) {
    // logger.w('++++ INCREASING QUANTITY ON ITEM $item IN CART BLOC ++++');
    if (amount != null) {
      _localStorageRepository.increaseQuantity(item, amount);

      final increase = value.copyWith(
        cartItems: {...value.cartItems}..update(
            item,
            (value) => value + amount,
          ),
      );
      value = increase;
      // logger.w('++++ CART AFTER INCREASING QUANTITY ${value.cartItems} ++++');
    } else {
      _localStorageRepository.increaseQuantity(item);

      final increase = value.copyWith(
        cartItems: {...value.cartItems}..update(
            item,
            (value) => value + 1,
          ),
      );
      value = increase;
    }
    // logger.w('++++ CART AFTER INCREASING QUANTITY ${value.cartItems} ++++');
  }

  void _decreaseQuantity(Item item) {
    // logger.w('---- DECREASING QUANTITY ON ITEM $item IN CART BLOC ----');
    _localStorageRepository.decreaseQuantity(item);

    if (value.cartItems[item]! > 1) {
      final decrease = value.copyWith(
        cartItems: {...value.cartItems}..update(item, (value) => value - 1),
      );
      value = decrease;
      // logger.w('---- CART AFTER DECREASING QUANTITY ${value.cartItems} ----');
    } else {
      _localStorageRepository.removeItem(item);
      final removeItem = value.copyWith(
        cartItems: {...value.cartItems}..remove(item),
      );
      value = removeItem;
      // logger.w(
      //   '---- CART AFTER REMOVING ITEM WHEN DECREASING QUANTITY $value ----',
      // );
    }
  }

  bool _allowIncrease(Item item) {
    if (value.cartItems[item] == null) {
      return true;
    }
    if (value.cartItems[item]! < 100) {
      return true;
    }
    return false;
  }

  Future<void> removeItemFromCart(Item item) async {
    // logger.w('---- REMOVING ITEM FROM CART $item ----');

    /// Removing from local storage Hive.
    _localStorageRepository.removeItem(item);

    // logger.w('CART BEFORE REMOVING ITEM $value');
    final newCart = value.copyWith(
      cartItems: {...value.cartItems}..remove(item),
    );
    value = newCart;
    // logger.w('---- CART AFTER REMOVING ITEM $value ----');
  }

  Future<void> removeAllItems() async {
    // logger
    // ..w('---- REMOVING ALL ITEMS FROM CART ----')
    // ..w('REMOVING ALL ITEMS FROM LOCAL STORAGE HIVE')
    // ..w('CACHED CART ITEMS BEFORE REMOVING FROM CART '
    // '${_localStorageRepository.getCartItems} '
    // '&&&& PLACE ID IN CART ${_localStorageRepository.getRestPlaceId()}');

    _localStorageRepository.removeAllItems();
    // logger
    //   ..w(
    //     'CACHED CART ITEMS AFTER REMOVING FROM CART'
    //     ' ${_localStorageRepository.getCartItems} '
    //     '&&&& PLACE ID IN CART ${_localStorageRepository.getRestPlaceId()}',
    //   )
    //   ..w('CART BEFORE REMOVING ALL ITEMS $value');

    value = value.copyWith(
      restaurantPlaceId: '',
      cartItems: {...value.cartItems}..clear(),
    );
    // logger.w('---- CART AFTER REMOVING ALL ITEMS $value ----');
  }

  Future<void> addItemToCartAfterCallingClearCart(
    Item item,
    String placeId,
  ) async {
    /// 1.First removing all items from cart, both cached
    /// and current storing items.
    ///
    /// 3.Then adding chosen item to cart with place id of the restaurant.
    await removeAllItems().then(
      (_) => addItemToCart(item, placeId: placeId),
    );
  }

  Future<void> removePlaceIdInCacheAndCart() async {
    // logger
    //   ..w('---- REMOVE PLACE ID FROM CART ----')
    //   ..w('CART BEFORE REMOVING PLACE ID $value')
    //   ..w(
    //     'CACHED PLACE ID IN CART BEFORE REMOVING '
    //     '${_localStorageRepository.getRestPlaceId()}',
    //   );
    _localStorageRepository.setRestPlaceIdToEmpty();
    final newCart = value.copyWith(
      restaurantPlaceId: '',
    );
    value = newCart;
    // logger
    //   ..w(
    //     'CACHED PLACE ID IN CART AFTER REMOVING '
    //     '${_localStorageRepository.getRestPlaceId()}',
    //   )
    //   ..w('---- CART AFTER REMOVING PLACE ID $value ----');
  }
}

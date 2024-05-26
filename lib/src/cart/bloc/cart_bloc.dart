// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart' show BuildContext, ValueNotifier;
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/home/services/services.dart';
import 'package:papa_burger/src/menu/menu.dart';
import 'package:papa_burger/src/services/repositories/local_storage/local_storage.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:shared/shared.dart';

class CartBloc extends ValueNotifier<Cart> {
  factory CartBloc() => _instance;

  CartBloc._() : super(const Cart()) {
    if (value.isCartEmpty) {
      _getCachedCartItems();
    }
  }

  static final _instance = CartBloc._();

  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  final RestaurantService _restaurantService = RestaurantService();

  Future<Restaurant> getRestaurant(String placeId) {
    final localStorage = LocalStorage();
    final lat = localStorage.latitude;
    final lng = localStorage.longitude;
    return _restaurantService.getRestaurantByPlaceId(
      placeId,
      latitude: '$lat',
      longitude: '$lng',
    );
  }

  void decreaseItemQuantity(
    BuildContext context,
    Item item, {
    Restaurant? restaurant,
    bool forMenu = false,
  }) {
    if (value.cartItems[item]! > 1) {
      _decreaseItemQuantity(item);
    } else {
      _removeItemFromCart(item).whenComplete(
        () {
          if (value.isCartEmpty) {
            resetRestaurantPlaceId();
            if (restaurant != null) {
              context.pushNamed(
                AppRoutes.menu.name,
                extra: MenuProps(restaurant: restaurant),
              );
            }
          }
        },
      );
    }
  }

  void increaseItemQuantity(Item item, [int? amount]) {
    if (canIncreaseItemQuantity(item)) _increaseItemQuantity(item, amount);
  }

  Future<void> _getCachedCartItems() async {
    final cachedCartItems = _localStorageRepository.getCartItems;
    final restaurantPlaceId = _localStorageRepository.getRestPlaceId();
    value = value.copyWith(
      restaurantPlaceId: restaurantPlaceId,
      cartItems: {...value.cartItems}..addAll(cachedCartItems),
    );
  }

  Future<void> addItemToCart(Item item, {required String placeId}) async {
    _localStorageRepository
      ..addPlaceId(placeId)
      ..addItem(item);

    final newPlaceId = value.copyWith(
      restaurantPlaceId: placeId,
      cartItems: {...value.cartItems}..putIfAbsent(item, () => 1),
    );
    value = newPlaceId;
  }

  void _increaseItemQuantity(Item item, [int? amount]) {
    if (amount != null) {
      _localStorageRepository.increaseQuantity(item, amount);

      final increase = value.copyWith(
        cartItems: {...value.cartItems}..update(
            item,
            (value) => value + amount,
          ),
      );
      value = increase;
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
  }

  void _decreaseItemQuantity(Item item) {
    _localStorageRepository.decreaseQuantity(item);

    if (value.cartItems[item]! > 1) {
      final decrease = value.copyWith(
        cartItems: {...value.cartItems}..update(item, (value) => value - 1),
      );
      value = decrease;
    } else {
      _localStorageRepository.removeItem(item);
      final removeItem = value.copyWith(
        cartItems: {...value.cartItems}..remove(item),
      );
      value = removeItem;
    }
  }

  bool canIncreaseItemQuantity(Item item) =>
      value.cartItems[item] == null || value.cartItems[item]! < 100;

  Future<void> _removeItemFromCart(Item item) async {
    /// Removing from local storage Hive.
    _localStorageRepository.removeItem(item);

    value = value.copyWith(cartItems: {...value.cartItems}..remove(item));
  }

  Future<void> removeAllItems() async {
    _localStorageRepository.removeAllItems();

    value = value.copyWith(
      restaurantPlaceId: '',
      cartItems: {...value.cartItems}..clear(),
    );
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

  Future<void> resetRestaurantPlaceId() async {
    _localStorageRepository.resetRestaurantPlaceId();
    value = value.copyWith(restaurantPlaceId: '');
  }
}

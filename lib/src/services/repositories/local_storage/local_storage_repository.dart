// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/foundation.dart' show immutable;
import 'package:hive/hive.dart' show Box, Hive;
import 'package:papa_burger/src/services/repositories/local_storage/local_storage.dart';
import 'package:shared/shared.dart';

/// [LocalStorageRepository] class, is made to maintain all the logic with
/// Local Storage with [Hive]. [Hive] helps to storage the data locally
/// on the mobile devices in orders to user them offline and/or reuse data
/// without fetching for it once or more times
@immutable
class LocalStorageRepository extends BaseLocalStorageRepository {
  /// Constant name for each of hive boxes with UNIQUE ['name']
  // static const String _cart = 'cart_items';
  static const String _cart = 'cart_items';
  static const String _restaurantId = 'restaurant_id';
  static const String _restaurantPlaceId = 'restaurant_place_id';

  // static late final Box<Item> _cartBox;
  static late final Box<Map<dynamic, dynamic>> _cartBox;
  static late final Box<int> _idBox;
  static late final Box<String> _placeIdBox;

  static Future<void> initBoxes() async {
    _cartBox = await Hive.openBox<Map<dynamic, dynamic>>(_cart);
    _idBox = await Hive.openBox<int>(_restaurantId);
    _placeIdBox = await Hive.openBox<String>(_restaurantPlaceId);
  }

  void addItem(Item item) {
    final cartItems = _cartBox.get(item.name) ?? {};
    if (cartItems.containsKey(item)) {
      cartItems[item] = cartItems[item] + 1;
    } else {
      cartItems[item] = 1;
    }
    _cartBox.put(item.name, cartItems);
  }

  void increaseQuantity(Item item, [int? amount]) {
    final cartItems = _cartBox.get(item.name) ?? {};
    if (cartItems.containsKey(item) && cartItems[item]! as int > 0) {
      if (amount != null) {
        cartItems[item] = cartItems[item]! + amount;
      } else {
        cartItems[item] = cartItems[item]! + 1;
      }
      _cartBox.put(item.name, cartItems);
    } else {
      if (amount == 1) {
        addItem(item);
      } else {
        addItem(item);
        cartItems[item] = cartItems[item] + amount;
        _cartBox.put(item.name, cartItems);
      }
    }
  }

  void decreaseQuantity(Item item) {
    final cartItems = _cartBox.get(item.name) ?? {};
    if (cartItems.containsKey(item) && cartItems[item]! as int > 1) {
      cartItems[item] = cartItems[item]! - 1;
      _cartBox.put(item.name, cartItems);
      return;
    }
    _cartBox.delete(item.name);
  }

  @override
  Map<Item, int> get getCartItems {
    final cartItems = <Item, int>{};
    for (final itemQuantityMap in _cartBox.values) {
      for (final entry in itemQuantityMap.entries) {
        cartItems[entry.key as Item] = entry.value as int;
      }
    }
    return cartItems;
  }

  /// Remove item from cart in menu
  @override
  void removeItem(Item item) {
    _cartBox.delete(item.name);
  }

  /// Remove all items from cart
  @override
  void removeAllItems() {
    _cartBox.clear();
  }

  /// Add global id to cart, that helps to determine from which restaurant
  /// item was added to prevent adding from the same restaurant
  @override
  void addId(int id) {
    _idBox.clear().then((_) => _idBox.put(id.toString(), id));
  }

  /// Add global place id of restaurant to cart, that helps to determine from
  /// which restaurant item was added to prevent adding from the same restaurant
  @override
  void addPlaceId(String placeId) {
    _placeIdBox.clear().then(
          (_) => _placeIdBox.put(placeId.toUpperCase(), placeId),
        );
  }

  /// After removing all items from cart, manually removing all existing ids
  /// from storage and setting new value of 0, that means that no there is no
  /// items in the cart and any item from any restaurant can be added.
  @override
  void resetId() {
    _idBox.clear().then((id) => _idBox.put(id, 0));
  }

  /// Test
  @override
  void resetRestaurantPlaceId() {
    _placeIdBox.clear().then((placeId) => _placeIdBox.put(placeId, ''));
  }

  /// Get rest id
  @override
  int getRestaurantId() {
    final id = _idBox.values.first;
    return id;
  }

  /// Get restaurant place id
  @override
  String getRestPlaceId() {
    final placeId = _placeIdBox.values.first;
    return placeId;
  }
}

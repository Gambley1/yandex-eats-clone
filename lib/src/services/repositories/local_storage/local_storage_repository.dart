// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/foundation.dart' show immutable;
import 'package:hive/hive.dart' show Box, Hive;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/services/repositories/local_storage/local_storage.dart';

/// [LocalStorageRepository] class, is made to maintain all the logic with
/// Local Storage with [Hive]. [Hive] helps to storage the data localy
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

  // /// Opens cart hive box to store all items added to the cart, in hive local storage
  // Future<Box<dynamic>> openCartBox() async {
  //   Box<dynamic> cartBox = await Hive.openBox<dynamic>(cart);
  //   return cartBox;
  // }

  // /// Opens id hive box to store restaurant id in [Hive] local storage
  // Future<Box<int>> openIdBox() async {
  //   Box<int> idBox = await Hive.openBox<int>(restaurantId);
  //   return idBox;
  // }

  // /// Opens id hive box to store restaurant id in [Hive] local storage
  // Future<Box<String>> openPlaceIdBox() async {
  //   Box<String> idBox = await Hive.openBox(restaurantPlaceId);
  //   return idBox;
  // }

  static Future<void> initBoxes() async {
    // _cartBox = await Hive.openBox<Item>(_cart);
    _cartBox = await Hive.openBox<Map<dynamic, dynamic>>(_cart);
    _idBox = await Hive.openBox<int>(_restaurantId);
    _placeIdBox = await Hive.openBox<String>(_restaurantPlaceId);
  }

  // /// Add item to cart in menu
  // @override
  // void addItem(Item item) {
  //   _cartBox.put(item.name, item);
  // }

  void addItem(Item item) {
    logI('++++ ADDING ITEM TO CART $item ++++');
    final cartItems = _cartBox.get(item.name) ?? {};
    if (cartItems.containsKey(item)) {
      cartItems[item] = cartItems[item] + 1;
      logI('ADDING ITEM WITH INCREMENTING QUANTITY BY 1 ON $item');
    } else {
      cartItems[item] = 1;
      logI('ADDING ITEM WITH QUANTITY 1');
    }
    logI('++++ PUTTING ITEM INTO LOCAL STORAGE $item ++++');
    _cartBox.put(item.name, cartItems);
  }

  void increaseQuantity(Item item, [int? amount]) {
    logI('++++ INCREMENTING QUANTITY ON ITEM $item ++++');
    final cartItems = _cartBox.get(item.name) ?? {};
    if (cartItems.containsKey(item) && cartItems[item]! as int > 0) {
      logI('SATISFIES IF STATEMENT, INCREMENTING QUANTITY');
      if (amount != null) {
        cartItems[item] = cartItems[item]! + amount;
      } else {
        cartItems[item] = cartItems[item]! + 1;
      }
      _cartBox.put(item.name, cartItems);
      logI('++++ CACHED CART ITEMS AFTER INCREMENTING $cartItems ++++');
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
    // logger.w('---- DECREASING QUANTITY ON ITEM $item ----');
    final cartItems = _cartBox.get(item.name) ?? {};
    if (cartItems.containsKey(item) && cartItems[item]! as int > 1) {
      // logger.w('SATISFIES IF STATEMENT, DECREMENTING QUANTITY');
      cartItems[item] = cartItems[item]! - 1;
      _cartBox.put(item.name, cartItems);
    } else {
      // logger.w('---- DONT SATISFIES IF STATEMENT, DELETING ITEM $item ----');
      _cartBox.delete(item.name);
    }
  }

  @override
  Map<Item, int> get getCartItems {
    // logger.w('**** GETTING ITEMS FROM LOCAL STORAGE ****');
    final cartItems = <Item, int>{};
    for (final itemQuantityMap in _cartBox.values) {
      for (final entry in itemQuantityMap.entries) {
        cartItems[entry.key as Item] = entry.value as int;
      }
    }
    // logger.w('**** GOT SOME ITEMS $cartItems ****');
    return cartItems;
  }

  /// Remove item from cart in menu
  @override
  void removeItem(Item item) {
    // _cartBox.delete(item.name);
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
    _idBox.clear().then(
          (_) => _idBox.put(id.toString(), id),
        );
  }

  /// Add global palce id of restaurant to cart, that helps to determine from
  /// which restaurant item was added to prevent adding from the same restaurant
  @override
  void addPlaceId(String placeId) {
    logI('ADD PLACE ID CALLED');
    logI('ADDING PLACE ID $placeId');
    _placeIdBox.clear().then(
          (_) => _placeIdBox.put(placeId.toUpperCase(), placeId),
        );
  }

  /// After removing all items from cart, manualy removing all excisting ids
  /// from storage and setting new value of 0, that means that no there is no
  /// items in the cart and any item from any restauraurant can be added.
  @override
  void setRestIdTo0() {
    _idBox.clear().then(
          (id) => _idBox.put(id, 0),
        );
  }

  /// Test
  @override
  void setRestPlaceIdToEmpty() {
    _placeIdBox.clear().then(
          (placeId) => _placeIdBox.put(placeId, ''),
        );
  }

  /// Get rest id
  @override
  int getRestId() {
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

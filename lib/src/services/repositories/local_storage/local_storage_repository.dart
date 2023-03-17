import 'package:flutter/foundation.dart' show immutable;
import 'package:hive/hive.dart' show Hive, Box;
import 'package:papa_burger/src/restaurant.dart' show BaseLocalStorageRepository, Item;

/// [LocalStorageRepository] class, is made to maintain all the logic with Local Storage
/// with [Hive]. [Hive] helps to storage the data localy on the mobile devices
/// in orders to user them offline and/or reuse data without fetching for it once or more times
@immutable
class LocalStorageRepository extends BaseLocalStorageRepository {
  /// Constant name for each of hive boxes with UNIQUE [name]
  static const String cart = 'cart_items';
  static const String restaurantId = 'restaurant_id';
  static const String restaurantPlaceId = 'restaurant_place_id';

  /// Opens cart hive box to store all items added to the cart, in hive local storage
  Future<Box<Item>> openCartBox() async {
    Box<Item> cartBox = await Hive.openBox<Item>(cart);
    return cartBox;
  }

  /// Opens id hive box to store restaurant id in [Hive] local storage
  Future<Box<int>> openIdBox() async {
    Box<int> idBox = await Hive.openBox(restaurantId);
    return idBox;
  }

  /// Opens id hive box to store restaurant id in [Hive] local storage
  Future<Box<String>> openPlaceIdBox() async {
    Box<String> idBox = await Hive.openBox(restaurantPlaceId);
    return idBox;
  }

  /// Add item to cart in menu
  @override
  Future<void> addItem(Item item) async {
    final box = await openCartBox();
    await box.put(item.name, item);
  }

  /// Remove item from cart in menu
  @override
  Future<void> removeItem(Item item) async {
    final box = await openCartBox();
    await box.delete(item.name);
  }

  /// Remove all items from cart
  @override
  Future<void> removeAllItems() async {
    final box = await openCartBox();
    await box.clear();
  }

  /// Add global id to cart, that helps to determine from which restaurant
  /// item was added to prevent adding from the same restaurant
  @override
  Future<void> addId(int id) async {
    final box = await openIdBox();
    await box.clear().then(
          (_) => box.put(id.toString(), id),
        );
  }

  /// Test
  @override
  Future<void> addPlaceId(String placeId) async {
    final box = await openPlaceIdBox();
    await box.clear().then(
          (_) => box.put(placeId.toUpperCase(), placeId),
        );
  }

  /// After removing all items from cart, manualy removing all excisting ids from storage
  /// and setting new value of 0, that means that no there is no items in the cart
  /// and any item from any restauraurant can be added
  @override
  Future<void> setRestIdTo0() async {
    final box = await openIdBox();
    await box.clear().then(
          (id) => box.put(id, 0),
        );
  }

  /// Test
  @override
  Future<void> setRestPlaceIdToEmpty() async {
    final box = await openPlaceIdBox();
    await box.clear().then(
          (placeId) => box.put(placeId, ''),
        );
  }

  /// Getting all cart items from the local storage to display them in the cart
  /// it's done to save items localy and to show items even after terminating app
  @override
  Future<Set<Item>> getCartItems() async {
    final box = await openCartBox();
    return box.values.toSet();
  }

  /// Stream of id that determines current id that has been preveously added to the
  /// cart to then use it's value to check whether user is able to add items
  /// from the restaurant's menu or not, based on current id
  @override
  Future<int> getRestId() async {
    final box = await openIdBox();
    final id = box.values.first;
    return id;
  }

  /// Test
  @override
  Future<String> getRestPlaceId() async {
    final box = await openPlaceIdBox();
    final placeId = box.values.first;
    return placeId;
  }
}

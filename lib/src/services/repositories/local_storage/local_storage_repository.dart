import 'package:flutter/foundation.dart' show immutable;
import 'package:hive/hive.dart' show Hive, Box;
import 'package:papa_burger/src/restaurant.dart'
    show BaseLocalStorageRepository, Item, logger;

/// [LocalStorageRepository] class, is made to maintain all the logic with Local Storage
/// with [Hive]. [Hive] helps to storage the data localy on the mobile devices
/// in orders to user them offline and/or reuse data without fetching for it once or more times
@immutable
class LocalStorageRepository extends BaseLocalStorageRepository {
  /// Constant name for each of hive boxes with UNIQUE [name]
  static const String _cart = 'cart_items';
  static const String _cartTest = 'cart_items_test';
  static const String _restaurantId = 'restaurant_id';
  static const String _restaurantPlaceId = 'restaurant_place_id';

  static late final Box<Item> _cartBox;
  static late final Box<Map<dynamic, dynamic>> _cartBoxTest;
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
    _cartBox = await Hive.openBox<Item>(_cart);
    _cartBoxTest = await Hive.openBox<Map<dynamic, dynamic>>(_cartTest);
    _idBox = await Hive.openBox<int>(_restaurantId);
    _placeIdBox = await Hive.openBox<String>(_restaurantPlaceId);
  }

  /// Add item to cart in menu
  @override
  void addItem(Item item) {
    _cartBox.put(item.name, item);
  }

  void addItemTest(Item item) {
    logger.w('++++ ADDING ITEM TO CART TEST $item ++++');
    final cartItems = _cartBoxTest.get(item.name) ?? {};
    if (cartItems.containsKey(item)) {
      cartItems[item] = cartItems[item]! + 1;
      logger.w('ADDING ITEM WITH INCREMENTING QUANTITY BY 1 ON $item');
    } else {
      cartItems[item] = 1;
      logger.w('ADDING ITEM WITH QUANTITY 1');
    }
    logger.w('++++ PUTTING ITEM INTO LOCAL STORAGE $item ++++');
    _cartBoxTest.put(item.name, cartItems);
  }

  void increaseQuantity(Item item) {
    logger.w('++++ INCREMENTING QUANTITY ON ITEM $item ++++');
    final cartItems = _cartBoxTest.get(item.name) ?? {};
    if (cartItems.containsKey(item) && cartItems[item]! > 0) {
      logger.w('SATISFIES IF STATEMENT, INCREMENTING QUANTITY');
      cartItems[item] = cartItems[item]! + 1;
      _cartBoxTest.put(item.name, cartItems);
      logger.w('++++ CACHED CART ITEMS AFTER INCREMENTING $cartItems ++++');
    }
  }

  void decreaseQuantity(Item item) {
    logger.w('---- DECREASING QUANTITY ON ITEM $item ----');
    final cartItems = _cartBoxTest.get(item.name) ?? {};
    if (cartItems.containsKey(item) && cartItems[item]! > 1) {
      logger.w('SATISFIES IF STATEMENT, DECREMENTING QUANTITY');
      cartItems[item] = cartItems[item]! - 1;
      _cartBoxTest.put(item.name, cartItems);
    } else {
      logger.w('---- DONT SATISFIES IF STATEMENT, DELETING ITEM $item ----');
      _cartBoxTest.delete(item.name);
    }
  }

  Map<Item, int> get getCartItemTest {
    logger.w('**** GETTING ITEMS FROM LOCAL STORAGE ****');
    final cartItems = <Item, int>{};
    for (final itemQuantityMap in _cartBoxTest.values) {
      for (final entry in itemQuantityMap.entries) {
        cartItems[entry.key] = entry.value;
      }
    }
    logger.w('**** GOT SOME ITEMS $cartItems ****');
    return cartItems;
  }

  /// Remove item from cart in menu
  @override
  void removeItem(Item item) {
    _cartBox.delete(item.name);
    _cartBoxTest.delete(item.name);
  }

  /// Remove all items from cart
  @override
  void removeAllItems() {
    _cartBox.clear();
    _cartBoxTest.clear();
  }

  /// Add global id to cart, that helps to determine from which restaurant
  /// item was added to prevent adding from the same restaurant
  @override
  void addId(int id) {
    _idBox.clear().then(
          (_) => _idBox.put(id.toString(), id),
        );
  }

  /// Test
  @override
  void addPlaceId(String placeId) {
    logger.w('ADD PLACE ID CALLED');
    logger.w('ADDING PLACE ID $placeId');
    _placeIdBox.clear().then(
          (_) => _placeIdBox.put(placeId.toUpperCase(), placeId),
        );
  }

  /// After removing all items from cart, manualy removing all excisting ids from storage
  /// and setting new value of 0, that means that no there is no items in the cart
  /// and any item from any restauraurant can be added
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

  /// Getting all cart items from the local storage to display them in the cart
  /// it's done to save items localy and to show items even after terminating app
  @override
  Set<Item> getCartItems() {
    return _cartBox.values.toSet();
  }

  /// Stream of id that determines current id that has been preveously added to the
  /// cart to then use it's value to check whether user is able to add items
  /// from the restaurant's menu or not, based on current id
  @override
  int getRestId() {
    final id = _idBox.values.first;
    return id;
  }

  /// Test
  @override
  String getRestPlaceId() {
    final placeId = _placeIdBox.values.first;
    logger.w("GOT PLACE ID $placeId");
    return placeId;
  }
}

import 'package:hive/hive.dart';
import 'package:papa_burger/src/restaurant.dart';

class LocalStorageRepository with BaseLocalStorageRepository {
  static const String cart = 'cart_items';
  static const String restaurantId = 'restaurant_id';

  @override
  Future<Box> openBoxCart() async {
    Box boxCart = await Hive.openBox<Item>(cart);
    return boxCart;
  }

  @override
  Future<Box> openBoxRestaurantId() async {
    Box boxId = await Hive.openBox<int>(restaurantId);
    return boxId;
  }

  @override
  Future<void> addItemToCart(Box box, Item cartItem) async {
    await box.put(cartItem.name, cartItem);
  }

  @override
  Future<void> addRestaurantIdToCart(Box box, int restaurantId) async {
    await box.clear().then((value) async {
      await box.put(restaurantId.toString(), restaurantId);
    });
  }

  @override
  Future<void> setRestaurantIdInCartTo0(Box box) async {
    await box.clear().then((value) async {
      await box.put(value, 0);
    });
  }

  @override
  Set<Item> getItemsFromStorage(Box box) {
    return box.values.toSet() as Set<Item>;
  }

  @override
  Stream<int> getRestaurantIdFromStorage(Box boxId, Box boxCart) async* {
    logger.i('id from storage is ${boxId.values.toList().first as int}');
    final id = boxId.values.toList().first as int;
    yield id;
  }

  @override
  Future<void> removeAllItemsFromCart(Box box) async {
    await box.clear();
  }

  @override
  Future<void> removeItemFromCart(Box box, Item cartItem) async {
    await box.delete(cartItem.name);
  }
}

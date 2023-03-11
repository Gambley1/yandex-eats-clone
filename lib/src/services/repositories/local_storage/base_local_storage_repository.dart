import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show Item;

/// An abstract class to separate logic a bit, in order to ahchieve maximum
/// maintainability of the code base.
@immutable
abstract class BaseLocalStorageRepository {
  /// All of the following methods are only the instances of each method
  /// that is fully made and ready to use in [LocalStorageRepository].
  Future<void> addItem(Item item);
  Future<void> removeItem(Item item);
  Future<void> removeAllItems();
  Future<void> addId(int id);
  Future<void> setRestIdTo0();
  Future<Set<Item>> getCartItems();
  Future<int> getRestId();
}

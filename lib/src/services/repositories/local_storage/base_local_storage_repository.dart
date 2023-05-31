import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show Item;

/// An abstract class to separate logic a bit, in order to ahchieve maximum
/// maintainability of the code base.
@immutable
abstract class BaseLocalStorageRepository {
  /// All of the following methods are only the instances of each method
  /// that is fully made and ready to use in ['LocalStorageRepository'].
  // void addItem(Item item);
  void removeItem(Item item);
  void removeAllItems();
  void addId(int id);
  void addPlaceId(String id);
  void setRestIdTo0();
  void setRestPlaceIdToEmpty();
  Map<Item, int> get getCartItems;
  int getRestId();
  String getRestPlaceId();
}

// ignore_for_file: comment_references

import 'package:flutter/foundation.dart' show immutable;
import 'package:shared/shared.dart';

/// An abstract class to separate logic.
@immutable
abstract class BaseLocalStorageRepository {
  void removeItem(Item item);
  void removeAllItems();
  void addId(int id);
  void addPlaceId(String id);
  void resetId();
  void resetRestaurantPlaceId();
  Map<Item, int> get getCartItems;
  int getRestaurantId();
  String getRestPlaceId();
}

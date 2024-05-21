// ignore_for_file: comment_references

import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/models.dart';

/// An abstract class to separate logic.
@immutable
abstract class BaseLocalStorageRepository {
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

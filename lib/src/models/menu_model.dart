import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show FicListExtension;
import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/models.dart';

@immutable
class MenuModel {
  const MenuModel({
    this.restaurant = const Restaurant.empty(),
  });
  final Restaurant restaurant;

  List<int> getDiscounts(List<Menu> restaunrantMenu) {
    final allDiscounts = <int>{};

    for (final menu in restaunrantMenu) {
      for (final item in menu.items) {
        assert(
          item.discount <= 100,
          "Item's discount can't be more than 100%.",
        );
        if (item.discount == 0.0) {
          allDiscounts.remove(0);
        }
        allDiscounts
          ..add(item.discount.toInt())
          ..remove(0);
      }
    }
    final listDiscounts = List<int>.from(allDiscounts)
      ..lock
      ..sort();

    return listDiscounts;
  }

  bool hasDiscount(Item item) => item.discount != 0;
  String priceString(Item item) => item.priceString;
}

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:shared/shared.dart';

@immutable
class MenuModel {
  const MenuModel({this.restaurant = const Restaurant.empty()});

  final Restaurant restaurant;

  List<int> getAvailableDiscounts(List<Menu> menus) {
    final discounts = <int>{};

    for (final menu in menus) {
      for (final item in menu.items) {
        assert(
          item.discount <= 100,
          "Item's discount can't be more than 100%.",
        );
        if (item.discount == 0.0) discounts.remove(0);
        discounts
          ..add(item.discount.toInt())
          ..remove(0);
      }
    }
    return List<int>.from(discounts)
      ..lock
      ..sort();
  }

  bool hasDiscount(Item item) => item.discount != 0;
  String priceString(Item item) => item.priceToString;
}

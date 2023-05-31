import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show FicListExtension;
import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart'
    show GoogleRestaurant, Item, Menu;

@immutable
class GoogleMenuModel {
  const GoogleMenuModel({
    this.restaurant = const GoogleRestaurant.empty(),
  });
  final GoogleRestaurant restaurant;

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

  List<Menu> getMenusWithPromotions() {
    final menuWithPromotion = restaurant.menu;
    // for (final menu in restaurant.menu) {
    //   for (final item in menu.items) {
    //     Menu promotionMenu;
    //     final itemsWithDiscount =
    //         menu.items.where((element) => element.discount != 0).toList();
    //     if (item.discount == 0) {
    //       promotionMenu = menu.copyWith(categorie: 'Promotion', items: []);
    //       menuWithPromotion.add(menu);
    //     } else {
    //       promotionMenu =
    //           menu.copyWith(categorie: 'Promotion', items: itemsWithDiscount)
    //       menuWithPromotion.add(promotionMenu);
    //     }
    //   }
    // }
    return menuWithPromotion;
  }

  bool hasDiscount(Item item) => item.discount != 0;
  String priceString(Item item) => item.priceString;
}

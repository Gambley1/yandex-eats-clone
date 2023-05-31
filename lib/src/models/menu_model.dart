import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show FicListExtension;
import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show Menu, Restaurant;

@immutable
class MenuModel {
  const MenuModel({
    this.restaurant = const Restaurant.empty(),
  });
  final Restaurant restaurant;

  double priceOfItem({
    required int index,
    required int i,
  }) {
    final item = restaurant.menu[i].items[index];
    final itemPrice = item.price;

    if (item.discount == 0) return itemPrice;

    final itemDiscount = item.discount;
    assert(itemDiscount <= 100, "Item's disount can't be more than 100%.");

    if (itemDiscount > 100) return itemPrice;

    final discount = itemPrice * (itemDiscount / 100);
    final discountPrice = itemPrice - discount;

    return discountPrice;
  }

  List<int> getDiscounts() {
    final allDiscounts = <int>{};

    for (final menu in restaurant.menu) {
      for (final item in menu.items) {
        assert(item.discount <= 100, "Item's discount can't be more than 100.");
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

  List<Menu> getMenuWithPromotions() {
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
}

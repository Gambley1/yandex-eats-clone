import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart'
    show GoogleRestaurant, Item, Menu, logger;
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show FicListExtension;

@immutable
class GoogleMenuModel {
  final GoogleRestaurant restaurant;
  const GoogleMenuModel({
    this.restaurant = const GoogleRestaurant.empty(),
  });

  double priceOfItem({
    required int index,
    required int i,
  }) {
    final Item item = restaurant.menu[i].items[index];
    final double itemPrice = item.price;

    if (item.discount == 0) return itemPrice;

    final double itemDiscount = item.discount;
    assert(itemDiscount <= 100);

    if (itemDiscount > 100) return 0;

    final double discount = itemPrice * (itemDiscount / 100);
    final double discountPrice = itemPrice - discount;

    return discountPrice;
  }

  List<int> getDiscounts() {
    final Set<int> allDiscounts = <int>{};

    for (final menu in restaurant.menu) {
      for (final item in menu.items) {
        assert(item.discount <= 100);
        if (item.discount == 0.0) {
          allDiscounts.remove(0);
        }
        allDiscounts
          ..add(item.discount.toInt())
          ..remove(0);
      }
    }
    final List<int> listDiscounts = List.from(allDiscounts)
      ..lock
      ..sort();

    return listDiscounts;
  }

  List<Menu> getMenuWithPromotions() {
    final List<Menu> menuWithPromotion = restaurant.menu;
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
    //           menu.copyWith(categorie: 'Promotion', items: itemsWithDiscount);
    //       menuWithPromotion.add(promotionMenu);
    //     }
    //   }
    // }
    return menuWithPromotion;
  }
}

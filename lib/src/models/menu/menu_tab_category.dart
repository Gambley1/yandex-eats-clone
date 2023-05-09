import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/material.dart'
    show ChangeNotifier, ScrollController, TabController, TickerProvider;
import 'package:papa_burger/src/restaurant.dart'
    show GoogleMenuModel, GoogleRestaurant, Item, Menu;

class MenuBloc with ChangeNotifier {
  MenuBloc({required GoogleRestaurant restaurant}) : _restaurant = restaurant;

  final double categoryHeight = 55;
  final double productHeight = 330;
  static const double discountHeight = 80;

  final GoogleRestaurant _restaurant;
  late final _menuModel = GoogleMenuModel(restaurant: _restaurant);

  List<MenuTabCategory> tabs = [];
  List<MenuItem> items = [];
  late TabController tabController;
  late ScrollController scrollController;

  void init(TickerProvider ticker) {
    final menus = _menuModel.getMenusWithPromotions();
    final discounts = _menuModel.getDiscounts();
    final addDiscountHeight = discounts.isNotEmpty;

    double offsetFrom = 244;
    double offsetTo = 0;

    tabController = TabController(length: menus.length, vsync: ticker);
    scrollController = ScrollController();
    for (var i = 0; i < menus.length; i++) {
      final menu = menus[i];

      if (i == 0) {
        offsetFrom += addDiscountHeight
            ? discountHeight * discounts.length +
                12 +
                (12 * (menus[0].items.length / 2).ceil())
            : (12 * (menus[0].items.length / 2).ceil());
      }
      if (i > 0) {
        final itemsMainAxisCount = (menus[i - 1].items.length / 2).ceil();

        // 15 is additional padding at the bottom of the whole section, so we also
        // plus this value.
        offsetFrom += itemsMainAxisCount * productHeight + categoryHeight + 15;
      }

      if (i < menus.length - 1) {
        offsetTo = offsetFrom + menus[i + 1].items.length * productHeight;
      } else {
        offsetTo = double.infinity;
      }

      tabs.add(
        MenuTabCategory(
          menuCategory: menu,
          selected: (i == 0),
          offsetFrom: i == 0 ? 244 : offsetFrom,
          offsetTo: categoryHeight * i + (menu.items.length * productHeight),
        ),
      );
      items.add(
        MenuItem(
          category: menu,
        ),
      );
      for (int j = 0; j < menu.items.length; j++) {
        final product = menu.items[j];
        items.add(
          MenuItem(product: product),
        );
      }
    }
  }

  void onCategorySelected(int index) {
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      final condition =
          selected.menuCategory.category == tabs[i].menuCategory.category;
      tabs[i] = tabs[i].copyWith(selected: condition);
    }
    notifyListeners();

    scrollController.jumpTo(selected.offsetFrom);
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }
}

class MenuTabCategory extends Equatable {
  final Menu menuCategory;
  final bool selected;
  final double offsetFrom;
  final double offsetTo;

  const MenuTabCategory({
    required this.menuCategory,
    required this.selected,
    required this.offsetFrom,
    required this.offsetTo,
  });

  MenuTabCategory copyWith({
    Menu? menuCategory,
    bool? selected,
    double? offsetFrom,
    double? offsetTo,
  }) {
    return MenuTabCategory(
      menuCategory: menuCategory ?? this.menuCategory,
      selected: selected ?? this.selected,
      offsetFrom: offsetFrom ?? this.offsetFrom,
      offsetTo: offsetTo ?? this.offsetTo,
    );
  }

  @override
  List<Object?> get props => [menuCategory, selected];
}

class MenuItem extends Equatable {
  final Menu? category;
  final Item? product;

  const MenuItem({
    this.category,
    this.product,
  });

  bool get isCategory => category != null;

  @override
  List<Object?> get props => [category, product];
}

// ignore_for_file: avoid_void_async, omit_local_variable_types

import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/material.dart' show ChangeNotifier, ScrollController;
import 'package:papa_burger/src/models/restaurant/restaurant.dart';
import 'package:papa_burger/src/restaurant.dart'
    show Item, Menu, MenuModel, logger;
import 'package:papa_burger_server/api.dart' as server;

class MenuBloc with ChangeNotifier {
  MenuBloc({required Restaurant restaurant}) : _restaurant = restaurant;

  final double categoryHeight = 55;
  final double productHeight = 330;
  static const double discountHeight = 80;

  final Restaurant _restaurant;
  late final _menuModel = MenuModel(restaurant: _restaurant);
  MenuModel get menuModel => _menuModel;

  List<MenuTabCategory> tabs = [];
  List<MenuItem> items = [];
  List<Menu> menus = [];
  List<int> discounts = [];
  // late TabController tabController;
  final ScrollController scrollController = ScrollController();

  Stream<List<Menu>> get getMenus async* {
    try {
      final apiClient = server.ApiClient();
      final dbmenus = await apiClient.getRestaurantMenu(_restaurant.placeId);
      final menus$ = dbmenus
          .map(
            (e) => Menu(
              category: e.category,
              items: e.items.map((e) {
                return Item(
                  description: e.description,
                  discount: e.discount,
                  imageUrl: e.imageUrl,
                  name: e.name,
                  price: e.discountPrice,
                );
              }).toList(),
            ),
          )
          .toList();
      menus = menus$;
      yield menus$;
    } catch (e) {
      logger.e(e);

      yield [];
    }
  }

  void init() async {
    final apiClient = server.ApiClient();
    final dbmenus = await apiClient.getRestaurantMenu(_restaurant.placeId);
    menus = dbmenus
        .map(
          (e) => Menu(
            category: e.category,
            items: e.items.map((e) {
              return Item(
                description: e.description,
                discount: e.discount,
                imageUrl: e.imageUrl,
                name: e.name,
                price: e.discountPrice,
              );
            }).toList(),
          ),
        )
        .toList();
    // final discounts = _menuModel.getDiscounts();
    // final menus = _menuModel.getMenusWithPromotions();
    discounts = _menuModel.getDiscounts(menus);
    final addDiscountHeight = discounts.isNotEmpty;

    double offsetFrom = 244;
    double offsetTo = 0;

    // scrollController = ScrollController();
    // tabController = TabController(length: menu.length, vsync: ticker);
    for (int i = 0; i < menus.length; i++) {
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

        /// 15 is additional padding at the bottom of the whole section, so we
        /// also plus this value.
        offsetFrom += itemsMainAxisCount * productHeight + categoryHeight + 15;
      }

      if (i < menus.length - 1) {
        offsetTo = offsetFrom + menus[i + 1].items.length * productHeight;
      } else {
        offsetTo = double.infinity;
      }

      final double spaceFromTop = addDiscountHeight
          ? (discounts.length * discountHeight + 244) + 28
          : 244;

      tabs.add(
        MenuTabCategory(
          menuCategory: menu,
          selected: i == 0,
          offsetFrom: i == 0 ? spaceFromTop : offsetFrom,
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
    // tabController.dispose();
    super.dispose();
  }
}

class MenuTabCategory extends Equatable {
  const MenuTabCategory({
    required this.menuCategory,
    required this.selected,
    required this.offsetFrom,
    required this.offsetTo,
  });
  final Menu menuCategory;
  final bool selected;
  final double offsetFrom;
  final double offsetTo;

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
  const MenuItem({
    this.category,
    this.product,
  });
  final Menu? category;
  final Item? product;

  bool get isCategory => category != null;

  @override
  List<Object?> get props => [category, product];
}

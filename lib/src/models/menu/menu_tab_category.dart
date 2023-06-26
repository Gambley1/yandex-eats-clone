// ignore_for_file: avoid_void_async, omit_local_variable_types

import 'package:flutter/material.dart'
    show ChangeNotifier, Curves, ScrollController, TabController, ValueNotifier;
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
  late TabController tabController;
  late final _menuModel = MenuModel(restaurant: _restaurant);
  MenuModel get menuModel => _menuModel;

  ValueNotifier<List<MenuTabCategory>> tabs = ValueNotifier([]);
  final isScrolledNotifier = ValueNotifier<bool>(false);
  List<MenuItem> items = [];
  List<Menu> menus = [];
  List<int> discounts = [];
  final ScrollController scrollController = ScrollController();
  bool _listen = true;

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
    discounts = _menuModel.getDiscounts(menus);
    final addDiscountHeight = discounts.isNotEmpty;

    double offsetFrom = 244;
    double offsetTo = 0;

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
        offsetTo = offsetFrom + menus[i + 1].items.length * productHeight - 244;
      } else {
        offsetTo = double.infinity;
      }

      final double spaceFromTop = addDiscountHeight
          ? (discounts.length * discountHeight + 244) + 28
          : 244;

      tabs.value.add(
        MenuTabCategory(
          menuCategory: menu,
          selected: i == 0,
          offsetFrom: i == 0 ? spaceFromTop : offsetFrom,
          // offsetTo: categoryHeight * i + (menu.items.length * productHeight),
          offsetTo: offsetTo,
        ),
      );
      notifyListeners();
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

    scrollController.addListener(_onScrollListener);
  }

  void onCategorySelected(int index, {bool animationRequired = true}) async {
    final selected = tabs.value[index];
    if (selected.selected) return;
    for (int i = 0; i < tabs.value.length; i++) {
      final condition =
          selected.menuCategory.category == tabs.value[i].menuCategory.category;
      tabs.value[i] = tabs.value[i].copyWith(selected: condition);
    }
    notifyListeners();

    if (animationRequired) {
      _listen = false;
      await scrollController.animateTo(
        selected.offsetFrom,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
      _listen = true;
    }
  }

  void _onScrollListener() {
    isScrolledNotifier.value = scrollController.offset > 210;
    if (_listen) {
      for (int i = 0; i < tabs.value.length; i++) {
        final tab = tabs.value[i];

        /// 240 is a value that substracts from offsetFrom to make tab category
        /// selection a bit more desired
        if (scrollController.offset >= tab.offsetFrom - 240 &&
            scrollController.offset <= tab.offsetTo &&
            !tab.selected) {
          onCategorySelected(i, animationRequired: false);
          tabController.animateTo(i);
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController
      ..dispose()
      ..removeListener(_onScrollListener);
    tabController.dispose();
    // tabController.dispose();
    super.dispose();
  }
}

class MenuTabCategory {
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
}

class MenuItem {
  const MenuItem({
    this.category,
    this.product,
  });
  final Menu? category;
  final Item? product;

  bool get isCategory => category != null;
}

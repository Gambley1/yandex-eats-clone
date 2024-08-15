// ignore_for_file: omit_local_variable_types

import 'package:app_ui/app_ui.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:yandex_food_api/client.dart';

class MenuController with ChangeNotifier {
  MenuController();

  final categoryHeight = 55.0;
  final productHeight = 330.0;
  static const discountHeight = 72.0;

  static const _changeColorScrollOffset = 190;
  static const _isScrolledLowerScrollOffset = 220;
  static const _isScrolledUpperScrollOffset = 246;
  static const _preferredSize = 24.0;
  static const _isScrolledOffsetFrom = 244.0;

  late TabController tabController;
  final ScrollController scrollController = ScrollController();

  List<MenuTabCategory> _tabs = <MenuTabCategory>[];
  List<MenuTabCategory> get tabs => _tabs;

  List<int> _discounts = [];
  List<int> get discounts => _discounts;

  final isScrolledNotifier = ValueNotifier(false);
  final colorChangeNotifier = ValueNotifier(false);
  final preferredSizedNotifier = ValueNotifier<double>(_preferredSize);

  bool _listen = true;

  Future<void> init(List<Menu> menus) async {
    if (_tabs.isNotEmpty) _tabs.clear();

    _discounts = getAvailableDiscounts(menus);
    final addDiscountHeight = _discounts.isNotEmpty;

    double offsetFrom = _isScrolledOffsetFrom;
    double offsetTo = 0;

    int itemsMainAxisCount(int index) {
      return (menus[index].items.length / 2).ceil();
    }

    for (int i = 0; i < menus.length; i++) {
      final menu = menus[i];

      if (i == 0) {
        final itemsPaddings = AppSpacing.md * itemsMainAxisCount(0);
        // AppSpacing.xlg accounted here as padding from top and bottom of item.
        offsetFrom += addDiscountHeight
            ? discountHeight * _discounts.length + AppSpacing.md + itemsPaddings
            : itemsPaddings;
      }
      if (i > 0) {
        /// 15 is additional padding at the bottom of the whole section, so we
        /// also plus this value.
        offsetFrom +=
            itemsMainAxisCount(i - 1) * productHeight + categoryHeight + 15;
      }

      if (i < menus.length - 1) {
        offsetTo = offsetFrom +
            itemsMainAxisCount(i + 1) * productHeight -
            _isScrolledOffsetFrom;
      } else {
        offsetTo = double.infinity;
      }

      _tabs = [
        ..._tabs,
        MenuTabCategory(
          menuCategory: menu,
          selected: i == 0,
          offsetFrom: i == 0 ? _isScrolledOffsetFrom : offsetFrom,
          offsetTo: offsetTo,
        ),
      ];
      notifyListeners();
    }

    scrollController.addListener(_onScrollListener);
  }

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

  Future<void> onCategorySelected(
    int index, {
    bool animationRequired = true,
  }) async {
    final selected = _tabs[index];
    if (selected.selected) return;
    for (int i = 0; i < _tabs.length; i++) {
      final condition =
          selected.menuCategory.category == _tabs[i].menuCategory.category;
      _tabs[i] = _tabs[i].copyWith(selected: condition);
    }
    notifyListeners();

    if (animationRequired) {
      _listen = false;
      await scrollController.animateTo(
        selected.offsetFrom,
        duration: 500.ms,
        curve: Curves.linear,
      );
      _listen = true;
    }
  }

  void _onScrollListener() {
    isScrolledNotifier.value =
        scrollController.offset > _isScrolledUpperScrollOffset;
    colorChangeNotifier.value =
        scrollController.offset > _changeColorScrollOffset;

    // offset is bounded between 220 and 246 for mobile devices, accounted
    // as lower and upper limits, when the scrollable considered to be
    // scrolled under the app bar for precise calculation of preferred size.
    _calculatePreferredSized();

    if (_listen) {
      for (int i = 0; i < _tabs.length; i++) {
        final tab = _tabs[i];

        /// 240 is a value that subtracts from offsetFrom to make tab category
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

  void _calculatePreferredSized() {
    final offset = scrollController.offset
        .clamp(_isScrolledLowerScrollOffset, _isScrolledUpperScrollOffset);

    // progress will go smoothly from 1 to 0.
    final progress = (_isScrolledUpperScrollOffset - offset) /
        (_isScrolledUpperScrollOffset - _isScrolledLowerScrollOffset);

    // multiplying preferred size default value to progress. value will smoothly
    // go from 24 to 0.
    final value = (24 * progress).ceil().toDouble();
    preferredSizedNotifier.value = value;
  }

  @override
  void dispose() {
    scrollController
      ..dispose()
      ..removeListener(_onScrollListener);
    super.dispose();
  }
}

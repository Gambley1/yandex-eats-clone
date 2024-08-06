import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide MenuController;
import 'package:yandex_food_delivery_clone/src/menu/menu.dart';

class MenuTabBar extends StatelessWidget {
  const MenuTabBar({required this.controller, super.key});

  final MenuController controller;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _MenuTabBarDelegate(
        TabBar(
          dividerHeight: 0,
          isScrollable: true,
          padding:
              const EdgeInsets.only(bottom: AppSpacing.sm, left: AppSpacing.sm),
          indicator: BoxDecoration(
            color: context.customReversedAdaptiveColor(
              light: AppColors.brightGrey,
              dark: AppColors.emphasizeDarkGrey,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.lg),
          ),
          indicatorPadding: const EdgeInsets.all(
            AppSpacing.sm - AppSpacing.xxs,
          ),
          labelStyle: context.bodyLarge,
          indicatorSize: TabBarIndicatorSize.tab,
          tabAlignment: TabAlignment.start,
          onTap: controller.onCategorySelected,
          unselectedLabelColor: AppColors.grey,
          tabs: controller.tabs
              .map(
                (tab) => Tab(text: tab.menuCategory.category),
              )
              .toList(),
        ),
        isScrolled: controller.isScrolledNotifier,
      ),
    );
  }
}

class _MenuTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _MenuTabBarDelegate(this._tabBar, {required this.isScrolled});

  final TabBar _tabBar;
  final ValueNotifier<bool> isScrolled;

  @override
  double get minExtent => _tabBar.preferredSize.height + AppSpacing.sm;

  @override
  double get maxExtent => _tabBar.preferredSize.height + AppSpacing.sm;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ValueListenableBuilder(
      valueListenable: isScrolled,
      builder: (context, isScrolled, _) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.theme.canvasColor,
            boxShadow: [
              if (isScrolled)
                BoxShadow(
                  color: context.customReversedAdaptiveColor(
                    light: AppColors.brightGrey,
                    dark: AppColors.emphasizeDarkGrey,
                  ),
                  spreadRadius: 2,
                  blurRadius: 2,
                ),
            ],
          ),
          child: _tabBar,
        );
      },
    );
  }

  @override
  bool shouldRebuild(_MenuTabBarDelegate oldDelegate) {
    return true;
  }
}

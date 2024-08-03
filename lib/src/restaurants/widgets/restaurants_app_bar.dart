import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:yandex_food_delivery_clone/src/home/home.dart';
import 'package:yandex_food_delivery_clone/src/search/search.dart';

class RestaurantsAppBar extends StatelessWidget {
  const RestaurantsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      automaticallyImplyLeading: false,
      excludeHeaderSemantics: true,
      scrolledUnderElevation: 12,
      floating: true,
      collapsedHeight: 133,
      surfaceTintColor: AppColors.white,
      flexibleSpace: Column(
        children: [
          SizedBox(height: AppSpacing.md),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            child: HeaderView(),
          ),
          SizedBox(height: AppSpacing.lg),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SearchBar(enabled: false),
          ),
        ],
      ),
    );
  }
}

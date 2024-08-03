// ignore_for_file: lines_longer_than_80_chars

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/widgets/filtered_restaurants_count.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/widgets/reset_filters_button.dart';

class FilteredRestaurantsHeader extends StatelessWidget {
  const FilteredRestaurantsHeader({
    required this.filteredRestaurantsCount,
    required this.tags,
    super.key,
  });

  final List<Tag> tags;
  final int filteredRestaurantsCount;

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: AppColors.grey,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilteredRestaurantsFoundCount(),
                ResetFiltersButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

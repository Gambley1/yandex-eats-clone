// ignore_for_file: lines_longer_than_80_chars

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurants/widgets/filtered_restaurants_count.dart';
import 'package:papa_burger/src/restaurants/widgets/reset_filters_button.dart';
import 'package:shared/shared.dart';

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
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilteredRestaurantsCount(count: filteredRestaurantsCount),
                const ResetFiltersButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

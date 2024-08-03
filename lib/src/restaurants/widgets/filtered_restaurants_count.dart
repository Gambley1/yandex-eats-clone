import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/restaurants.dart';

class FilteredRestaurantsFoundCount extends StatelessWidget {
  const FilteredRestaurantsFoundCount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = context
        .select((RestaurantsBloc bloc) => bloc.state.filteredRestaurants);
    final restaurantsCount = filteredRestaurants.length;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Found $restaurantsCount restaurants',
              style: context.bodyLarge
                  ?.copyWith(fontWeight: AppFontWeight.semiBold),
            ),
            const ResetFiltersButton(),
          ],
        ),
      ),
    );
  }
}

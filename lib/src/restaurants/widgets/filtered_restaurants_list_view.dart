import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/restaurants/restaurants.dart';
import 'package:papa_burger/src/search/widgets/search_bar.dart';
import 'package:shared/shared.dart';

class FilteredRestaurantsView extends StatelessWidget {
  const FilteredRestaurantsView({
    required this.filteredRestaurants,
    super.key,
  });

  final List<Restaurant> filteredRestaurants;

  Widget _appBar(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            AppIcon(
              type: IconType.button,
              onPressed: context.pop,
              icon: Icons.adaptive.arrow_back_sharp,
            ),
            const Expanded(
              child: AppSearchBar(enabled: false),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final single = filteredRestaurants.length == 1;
    final pluralOrSingular = single ? 'restaurant' : 'restaurants';

    return AppScaffold(
      body: CustomScrollView(
        slivers: [
          _appBar(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            sliver: SliverToBoxAdapter(
              child: Text(
                '${filteredRestaurants.length} $pluralOrSingular found',
                style: context.titleLarge
                    ?.copyWith(fontWeight: AppFontWeight.bold),
              ),
            ),
          ),
          RestaurantsListView(
            restaurants: filteredRestaurants,
            hasMore: false,
          ),
        ],
      ),
    );
  }
}

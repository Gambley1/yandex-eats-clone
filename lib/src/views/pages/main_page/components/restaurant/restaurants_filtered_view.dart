import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CustomIcon,
        CustomScaffold,
        CustomSearchBar,
        DisalowIndicator,
        GoogleRestaurantsListView,
        IconType,
        KText,
        NavigatorExtension,
        kDefaultHorizontalPadding;

class RestaurantsFilteredView extends StatelessWidget {
  const RestaurantsFilteredView({
    required this.filteredRestaurants,
    super.key,
  });

  final List<GoogleRestaurant> filteredRestaurants;

  Widget _appBar(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            CustomIcon(
              type: IconType.iconButton,
              onPressed: () => context.pop(),
              icon: FontAwesomeIcons.arrowLeft,
            ),
            const Expanded(
              child: CustomSearchBar(enabled: false),
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
    return CustomScaffold(
      withSafeArea: true,
      body: CustomScrollView(
        slivers: [
          _appBar(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding,
            ),
            sliver: SliverToBoxAdapter(
              child: KText(
                text: '${filteredRestaurants.length} $pluralOrSingular found',
                size: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GoogleRestaurantsListView(
            restaurants: filteredRestaurants,
            hasMore: false,
          ),
        ],
      ).disalowIndicator(),
    );
  }
}

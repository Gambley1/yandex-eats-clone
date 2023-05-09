import 'package:flutter/material.dart';
import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CustomIcon,
        CustomScaffold,
        DisalowIndicator,
        GoogleRestaurantsListView,
        IconType,
        KText,
        NavigatorExtension,
        SearchBar,
        kDefaultHorizontalPadding;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

class RestaurantsFilteredView extends StatelessWidget {
  const RestaurantsFilteredView({
    super.key,
    required this.filteredRestaurants,
  });

  final List<GoogleRestaurant> filteredRestaurants;

  _appBar(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            CustomIcon(
              type: IconType.iconButton,
              onPressed: () => context.pop(),
              icon: FontAwesomeIcons.arrowLeft,
              size: 22,
            ),
            const Expanded(
              child: SearchBar(enabled: false),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      withSafeArea: true,
      body: CustomScrollView(
        slivers: [
          _appBar(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultHorizontalPadding),
            sliver: SliverToBoxAdapter(
              child: KText(
                text:
                    'Found ${filteredRestaurants.length.toString()} restaurants',
                size: 22,
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

import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CustomIcon,
        Restaurant,
        IconType,
        SearchBar,
        kDefaultHorizontalPadding,
        DisalowIndicator,
        RestaurantsListView,
        KText;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

class RestaurantsFilteredView extends StatelessWidget {
  const RestaurantsFilteredView({
    super.key,
    required this.filteredRestaurants,
  });

  final List<Restaurant> filteredRestaurants;

  _appBar(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            CustomIcon(
              type: IconType.iconButton,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: FontAwesomeIcons.arrowLeft,
              size: 22,
            ),
            const Expanded(
              child: SearchBar(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
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
            RestaurantsListView(restaurants: filteredRestaurants,),
          ],
        ).disalowIndicator(),
      ),
    );
  }
}

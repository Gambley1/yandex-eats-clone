import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart'
    show PageTransition, PageTransitionType;
import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CacheImageType,
        CachedImage,
        CustomCircularIndicator,
        CustomIcon,
        DisalowIndicator,
        IconType,
        InkEffect,
        KText,
        ShimmerLoading,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/views/pages/main_page/components/menu/google_menu_view.dart';

class GoogleRestaurantsListView extends StatelessWidget {
  const GoogleRestaurantsListView({
    super.key,
    required this.restaurants,
    required this.hasMore,
    this.errorMessage,
  });

  final List<GoogleRestaurant> restaurants;
  final bool hasMore;
  final Map<String, String>? errorMessage;

  @override
  Widget build(BuildContext context) {
    // GoogleRestaurantDetails? details;

    // void getRestaurantDetails(GoogleRestaurant restaurant) async {
    //   details = await restaurant.getDetails;
    // }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      sliver: errorMessage != null
          ? SliverPadding(
              padding: const EdgeInsets.only(top: 120),
              sliver: SliverToBoxAdapter(
                child: Center(
                    child: Column(
                  children: [
                    KText(
                      text: errorMessage!['title']!,
                      size: 22,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    KText(
                      text: errorMessage!['solution'] ?? '',
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                )),
              ),
            )
          : restaurants.isEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return const Padding(
                        padding: EdgeInsets.only(
                          bottom: 24,
                        ),
                        child: ShimmerLoading(
                          height: 160,
                          radius: kDefaultBorderRadius,
                          width: double.infinity,
                        ),
                      );
                    },
                    childCount: 5,
                  ),
                ).disalowIndicator()
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == restaurants.length) {
                        return const SizedBox(
                          height: 60,
                          child: CustomCircularIndicator(
                            color: Colors.black,
                          ),
                        );
                      }
                      final restaurant = restaurants[index];

                      final name = restaurant.name;
                      final numOfRatings = restaurant.userRatingsTotal;
                      final rating = restaurant.rating;
                      final tags = restaurant.types;
                      final imageUrl = restaurant.imageUrl;

                      final openNow = restaurant.openingHours?.openNow ?? false;

                      return Opacity(
                        opacity: openNow ? 1 : 0.6,
                        child: RestaurantCard(
                          restaurant: restaurant,
                          imageUrl: imageUrl,
                          name: name,
                          rating: rating ?? 0,
                          quality: 'Good',
                          numOfRatings: numOfRatings ?? 0,
                          tags: tags,
                        ),
                      );
                    },
                    childCount: restaurants.length + (hasMore ? 1 : 0),
                  ),
                ).disalowIndicator(),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.quality,
    required this.numOfRatings,
    required this.tags,
  });

  final GoogleRestaurant restaurant;
  final String imageUrl;
  final String name;
  final dynamic rating;
  final String quality;
  final int numOfRatings;
  final List<String> tags;

  _buildRestaurantInfo() => Row(
        children: [
          _buildRatingAndQuality(),
          _buildTags(tags),
        ],
      );

  _buildRating() {
    return rating <= 3
        ? const KText(text: ' Only a few ratings')
        : KText(
            text: " $rating ",
          );
  }

  _buildQualityAndNumOfRatings() {
    return rating <= 3
        ? Container()
        : KText(
            text: numOfRatings >= 50
                ? '$quality ($numOfRatings+)'
                : 'Few Ratings',
            color: numOfRatings >= 30 ? Colors.black : Colors.black54,
          );
  }

  _buildRatingAndQuality() {
    return Row(
      children: [
        CustomIcon(
          icon: FontAwesomeIcons.star,
          size: 16,
          color: rating <= 3 ? Colors.grey : Colors.green,
          type: IconType.simpleIcon,
        ),
        _buildRating(),
        _buildQualityAndNumOfRatings(),
      ],
    );
  }

  _buildTags(List<String> tags) {
    final String tag = tags.first;
    return KText(
      /// The letter ',' comes from [GoogleRestaurant] from formattedTag
      text: restaurant.formattedTag(tag),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultHorizontalPadding),
      child: InkWell(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
            PageTransition(
              child: GoogleMenuView(
                restaurant: restaurant,
              ),
              type: PageTransitionType.fade,
            ),
            (route) => true,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  PageTransition(
                    child: GoogleMenuView(
                      restaurant: restaurant,
                    ),
                    type: PageTransitionType.fade,
                  ),
                  (route) => true,
                );
              },
              child: CachedImage(
                inkEffect: InkEffect.noEffect,
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                imageType: CacheImageType.smallImageWithNoShimmer,
                imageUrl: imageUrl,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: name,
                  size: 20,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            _buildRestaurantInfo(),
          ],
        ),
      ),
    );
  }
}

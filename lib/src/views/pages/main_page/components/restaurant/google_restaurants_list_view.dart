import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CacheImageType,
        CachedImage,
        CustomCircularIndicator,
        CustomIcon,
        DisalowIndicator,
        GoogleRestaurant,
        IconType,
        InkEffect,
        KText,
        Message,
        NavigatorExtension,
        ShimmerLoading,
        currency,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

class GoogleRestaurantsListView extends StatelessWidget {
  const GoogleRestaurantsListView({
    super.key,
    required this.restaurants,
    required this.hasMore,
    this.errorMessage,
  });

  final List<GoogleRestaurant> restaurants;
  final bool hasMore;
  final Message? errorMessage;

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
                      text: errorMessage?.title ?? 'Some error occured.',
                      size: 22,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    KText(
                      text: errorMessage?.solution ??
                          'Contact me emilzulufov566@gmail.com',
                      size: 20,
                      textAlign: TextAlign.center,
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
                      final numOfRatings = restaurant.userRatingsTotal ?? 0;
                      final priceLevel = restaurant.priceLevel ?? 0;
                      final rating = restaurant.rating ?? 0;
                      final tags = restaurant.types;
                      final imageUrl = restaurant.imageUrl;
                      final quality = restaurant.quality(rating);

                      final openNow = restaurant.openingHours?.openNow ?? false;

                      return Opacity(
                        opacity: openNow ? 1 : 0.6,
                        child: RestaurantCard(
                          restaurant: restaurant,
                          imageUrl: imageUrl,
                          name: name,
                          rating: rating,
                          quality: quality,
                          numOfRatings: numOfRatings,
                          priceLevel: priceLevel,
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
    required this.priceLevel,
    required this.tags,
  });

  final GoogleRestaurant restaurant;
  final String imageUrl;
  final String name;
  final dynamic rating;
  final String quality;
  final int numOfRatings;
  final int priceLevel;
  final List<String> tags;

  _buildRestaurantInfo() => Row(
        children: [
          _buildRatingAndQuality(),
          _buildTags(),
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
                ? '$quality ($numOfRatings+)'.padRight(1)
                : 'Few Ratings'.padRight(1),
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
        RestaurantPriceLevel(priceLevel: priceLevel),
      ],
    );
  }

  _buildTags() {
    final tag = tags.isNotEmpty ? tags.first : '';
    return KText(
      /// The letter ',' comes from [GoogleRestaurant] from formattedTag
      text: tags.isEmpty ? '' : restaurant.formattedTag(tag),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultHorizontalPadding),
      child: InkWell(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        onTap: () => context.navigateToMenu(context, restaurant),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImage(
              inkEffect: InkEffect.noEffect,
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              imageType: CacheImageType.smallImageWithNoShimmer,
              onTap: () => context.navigateToMenu(context, restaurant),
              imageUrl: imageUrl,
            ),
            const SizedBox(
              height: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: name,
                  child: KText(
                    text: name,
                    size: 20,
                    fontWeight: FontWeight.bold,
                  ),
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

class RestaurantPriceLevel extends StatelessWidget {
  const RestaurantPriceLevel({
    super.key,
    required this.priceLevel,
  });

  final int priceLevel;

  @override
  Widget build(BuildContext context) {
    textToAppend(int priceLevel) => KText(
          text: priceLevel == 1
              ? '$currency$currency'
              : priceLevel == 2
                  ? currency
                  : '',
          color: Colors.grey,
        );

    switch (priceLevel) {
      case 0:
        return const KText(
          text: '',
        );
      case 1:
        return Row(
          children: [
            const KText(text: ' $currency'),
            textToAppend(priceLevel),
          ],
        );
      case 2:
        return Row(
          children: [
            const KText(text: ' $currency$currency'),
            textToAppend(priceLevel),
          ],
        );
      case 3:
        return const KText(text: ' $currency$currency$currency');
      default:
        return const KText(text: '');
    }
  }
}

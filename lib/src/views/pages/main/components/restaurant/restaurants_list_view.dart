import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class RestaurantsListView extends StatelessWidget {
  const RestaurantsListView({
    required this.restaurants,
    required this.hasMore,
    super.key,
    this.errorMessage,
  });

  final List<Restaurant> restaurants;
  final bool hasMore;
  final Message? errorMessage;

  @override
  Widget build(BuildContext context) {
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
                      Text(
                        errorMessage?.title ?? 'Something went wrong 😔',
                        style: context.headlineSmall?.copyWith(),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        errorMessage?.solution ??
                            'Contact me emilzulufov.commercial@gmail.com to '
                                'notify about error.',
                        textAlign: TextAlign.center,
                        style: context.titleLarge?.apply(color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
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
                )
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
                      final tags = restaurant.tags;
                      final imageUrl = restaurant.imageUrl;
                      final deliveryTime = restaurant.deliveryTime;
                      final quality = restaurant.quality(rating as double);

                      final openNow = restaurant.openingHours.openNow;

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
                          deliveryTime: deliveryTime,
                          tags: tags,
                        ),
                      );
                    },
                    childCount: restaurants.length + (hasMore ? 1 : 0),
                  ),
                ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    required this.restaurant,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.quality,
    required this.numOfRatings,
    required this.priceLevel,
    required this.tags,
    required this.deliveryTime,
    super.key,
  });

  final Restaurant restaurant;
  final String imageUrl;
  final String name;
  final double rating;
  final String quality;
  final int numOfRatings;
  final int priceLevel;
  final int deliveryTime;
  final List<Tag> tags;

  Widget _buildRestaurantInfo(BuildContext context) => Row(
        children: [
          _buildRatingAndQuality(context),
          _buildTags(),
        ],
      );

  Widget _buildRating() {
    return rating <= 3 ? const Text(' Only a few ratings') : Text(' $rating ');
  }

  Widget _buildQualityAndNumOfRatings(BuildContext context) {
    return rating <= 3
        ? const SizedBox.shrink()
        : Text(
            numOfRatings >= 50 ? '$quality ($numOfRatings+) ' : 'Few Ratings ',
            style: context.bodyMedium?.apply(
              color:
                  numOfRatings >= 30 ? AppColors.black : AppColors.background,
            ),
          );
  }

  Row _buildRatingAndQuality(BuildContext context) {
    return Row(
      children: [
        CustomIcon(
          icon: FontAwesomeIcons.star,
          size: 16,
          color: rating <= 4.4 ? Colors.grey : Colors.green,
          type: IconType.simpleIcon,
        ),
        _buildRating(),
        _buildQualityAndNumOfRatings(context),
        RestaurantPriceLevel(priceLevel: priceLevel),
      ],
    );
  }

  Widget _buildTags() {
    final tags$ = tags.isNotEmpty
        ? tags.length == 1
            ? [tags.first.name]
            : [tags.first.name, tags.last.name]
        : <Tag>[];
    return Text(
      /// The letter ',' comes from [Restaurant] from formattedTag
      tags$.isEmpty ? '' : restaurant.formattedTag(tags$.cast<String>()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deliverByWalk = deliveryTime < 8;
    final deliveryTime$ = deliverByWalk ? 15 : deliveryTime;
    final icon = deliverByWalk ? Icons.directions_walk : Icons.directions_car;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultHorizontalPadding),
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            onTap: () => context.goToMenu(context, restaurant),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CachedImage(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: double.infinity,
                      imageType: CacheImageType.smallImageWithNoShimmer,
                      onTap: () => context.goToMenu(context, restaurant),
                      imageUrl: imageUrl,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: FavouriteButton(
                        restaurant: restaurant,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultHorizontalPadding,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(kDefaultBorderRadius),
                            bottomLeft: Radius.circular(kDefaultBorderRadius),
                            bottomRight: Radius.circular(kDefaultBorderRadius),
                          ),
                          color: Colors.black.withOpacity(.8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${deliveryTime$} - ${deliveryTime$ + 10} '
                              'min',
                              style: context.headlineSmall
                                  ?.copyWith(fontWeight: AppFontWeight.regular),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'Menu$name',
                      child: Text(
                        name,
                        style: context.titleLarge
                            ?.copyWith(fontWeight: AppFontWeight.bold),
                      ),
                    ),
                  ],
                ),
                _buildRestaurantInfo(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({
    required this.restaurant,
    super.key,
  });

  final Restaurant restaurant;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {
        setState(() {});
      });
    _scaleAnimation = Tween<double>(begin: 1, end: 0.75).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void makeFavourite() {
    setState(() {
      final isFavourite = _isFavourite == true;
      if (isFavourite) {
        _isFavourite = false;
        widget.restaurant.copyWith(isFavourite: false);
      } else {
        _isFavourite = true;
        widget.restaurant.copyWith(isFavourite: true);
      }
    });
  }

  void onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void onTapUp(TapUpDetails details) {
    _animationController.reverse();
    HapticFeedback.heavyImpact();
    makeFavourite();
  }

  void onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(
          height: 35,
          width: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withOpacity(.8),
            shape: BoxShape.circle,
          ),
          child: Image(
            width: 22,
            image: AssetImage(
              _isFavourite ? heartFilled : heartNotFilled,
            ),
          ),
        ),
      ),
    );
  }
}

class RestaurantPriceLevel extends StatelessWidget {
  const RestaurantPriceLevel({
    required this.priceLevel,
    super.key,
  });

  final int priceLevel;

  @override
  Widget build(BuildContext context) {
    Widget textToAppend(int priceLevel) => Text(
          priceLevel == 1
              ? '$currency$currency'
              : priceLevel == 2
                  ? currency
                  : '',
          style: context.bodyMedium?.apply(color: AppColors.grey),
        );

    return switch (priceLevel) {
      == 1 => Row(
          children: [
            const Text(' $currency'),
            textToAppend(priceLevel),
          ],
        ),
      == 2 => Row(
          children: [
            const Text(' $currency$currency'),
            textToAppend(priceLevel),
          ],
        ),
      == 3 => const Text(' $currency$currency$currency'),
      _ => const Text(''),
    };
  }
}

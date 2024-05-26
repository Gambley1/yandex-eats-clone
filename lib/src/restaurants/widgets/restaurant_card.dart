import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/menu/menu.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared/shared.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({required this.restaurant, super.key});

  final Restaurant restaurant;

  bool _isRatingEnough() {
    final rating = restaurant.rating;
    return rating is int ? rating <= 3 : rating as double <= 3.0;
  }

  Widget _buildRestaurantInfo(BuildContext context) => Row(
        children: [
          _buildRatingAndQuality(context),
          _buildTags(),
        ],
      );

  Widget _buildRating() {
    return !_isRatingEnough()
        ? const Text(' Only a few ratings')
        : Text(' ${restaurant.rating} ');
  }

  Widget buildQualityAndNumOfRatings(BuildContext context) {
    final numOfRatings = restaurant.userRatingsTotal ?? 0;
    final quality = restaurant.quality(restaurant.rating as double);
    return !_isRatingEnough()
        ? const SizedBox.shrink()
        : Text(
            numOfRatings >= 50 ? '$quality ($numOfRatings+) ' : 'Few Ratings ',
            style: context.bodyMedium?.apply(
              color:
                  numOfRatings >= 30 ? AppColors.black : AppColors.background,
            ),
          );
  }

  Widget _buildRatingAndQuality(BuildContext context) {
    final rating = restaurant.rating as double;
    final priceLevel = restaurant.priceLevel ?? 0;

    return Row(
      children: [
        AppIcon(
          icon: LucideIcons.star,
          size: 16,
          color: rating <= 4.4 ? Colors.grey : Colors.green,
        ),
        _buildRating(),
        buildQualityAndNumOfRatings(context),
        RestaurantPriceLevel(priceLevel: priceLevel),
      ],
    );
  }

  Widget _buildTags() {
    final tags = restaurant.tags;
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
    final deliveryTime = restaurant.deliveryTime;
    final deliverByWalk = deliveryTime < 8;
    final deliveryTime$ = deliverByWalk ? 15 : deliveryTime;
    final icon = deliverByWalk ? Icons.directions_walk : Icons.directions_car;
    final name = restaurant.name;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
            onTap: () => context.pushNamed(
              AppRoutes.menu.name,
              extra: MenuProps(restaurant: restaurant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AppCachedImage(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: double.infinity,
                      imageType: CacheImageType.smNoShimmer,
                      onTap: () => context.pushNamed(
                        AppRoutes.menu.name,
                        extra: MenuProps(restaurant: restaurant),
                      ),
                      imageUrl: restaurant.imageUrl,
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
                          horizontal: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft:
                                Radius.circular(AppSpacing.md + AppSpacing.sm),
                            bottomLeft:
                                Radius.circular(AppSpacing.md + AppSpacing.sm),
                            bottomRight:
                                Radius.circular(AppSpacing.md + AppSpacing.sm),
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
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  bool isFavourite0 = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {
        setState(() {});
      });
    scaleAnimation = Tween<double>(begin: 1, end: 0.75).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }

  void makeFavourite() {
    setState(() {
      final isFavourite = isFavourite0 == true;
      if (isFavourite) {
        isFavourite0 = false;
        widget.restaurant.copyWith(isFavourite: false);
      } else {
        isFavourite0 = true;
        widget.restaurant.copyWith(isFavourite: true);
      }
    });
  }

  void onTapDown(TapDownDetails details) {
    animationController.forward();
  }

  void onTapUp(TapUpDetails details) {
    animationController.reverse();
    HapticFeedback.heavyImpact();
    makeFavourite();
  }

  void onTapCancel() {
    animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: Transform.scale(
        scale: scaleAnimation.value,
        child: Container(
          height: 35,
          width: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withOpacity(.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.heart,
            color: isFavourite0 ? null : AppColors.red,
            size: AppSpacing.xlg,
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
    const currency = r'$';
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

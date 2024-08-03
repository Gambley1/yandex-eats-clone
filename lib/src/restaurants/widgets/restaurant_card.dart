// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/menu/menu.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({required this.restaurant, super.key});

  final Restaurant restaurant;

  bool _isRatingEnough() {
    final rating = restaurant.rating;
    return rating is int ? rating > 3 : rating as double > 3.0;
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
    final numOfRatings = restaurant.userRatingsTotal;
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
    final priceLevel = restaurant.priceLevel;

    return Row(
      children: [
        AppIcon(
          icon: LucideIcons.star,
          iconSize: 16,
          color: rating <= 4.4 ? AppColors.grey : AppColors.green,
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
    final deliveryTime = restaurant.deliveryTime ?? 0;
    final deliverByWalk = deliveryTime < 8;
    final icon = deliverByWalk ? Icons.directions_walk : Icons.directions_car;
    final name = restaurant.name;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Stack(
        children: [
          Tappable.faded(
            borderRadius: AppSpacing.xlg - AppSpacing.xs,
            onTap: () => context.pushNamed(
              AppRoutes.menu.name,
              extra: MenuProps(restaurant: restaurant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ImageAttachmentThumbnail(
                      height: context.screenHeight * 0.2,
                      borderRadius: BorderRadius.circular(AppSpacing.md),
                      imageUrl: restaurant.imageUrl,
                    ),
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: BookmarkButton(
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
                          color: AppColors.black.withOpacity(.8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              color: AppColors.white,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              restaurant.formattedDeliveryTime(),
                              style: context.headlineSmall?.copyWith(
                                fontWeight: AppFontWeight.regular,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
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

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({
    required this.restaurant,
    super.key,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: context.read<RestaurantsRepository>().bookmarkedRestaurants(),
      builder: (context, snapshot) {
        final bookmarkedRestaurants = snapshot.data;
        final isBookmarked =
            bookmarkedRestaurants?.contains(restaurant.placeId) ?? false;

        return Tappable.scaled(
          onTap: () => context
              .read<RestaurantsRepository>()
              .bookmarRestaurant(placeId: restaurant.placeId),
          throttle: true,
          throttleDuration: 350.ms,
          child: Container(
            height: 35,
            width: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: AppColors.white,
              size: AppSpacing.xlg,
            ),
          ),
        );
      },
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

    TextStyle? effectiveStyle(int level) {
      return context.bodyLarge?.apply(
        color: priceLevel >= level ? AppColors.black : AppColors.grey,
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: currency, style: effectiveStyle(1)),
          TextSpan(text: currency, style: effectiveStyle(2)),
          TextSpan(text: '$currency ', style: effectiveStyle(3)),
        ],
      ),
    );
  }
}

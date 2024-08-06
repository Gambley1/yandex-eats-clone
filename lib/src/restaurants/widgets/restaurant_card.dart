import 'dart:math';

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

  @override
  Widget build(BuildContext context) {
    final rating = restaurant.rating as double;
    final priceLevel = restaurant.priceLevel;
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
                    RestaurantCardImage(restaurant: restaurant),
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
                Row(
                  children: [
                    AppIcon(
                      icon: LucideIcons.star,
                      iconSize: AppSize.xs,
                      color: rating <= 4.4 ? AppColors.grey : AppColors.green,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    if (_isRatingEnough())
                      Text('${restaurant.rating}')
                    else
                      const Text(' Only a few ratings'),
                    const SizedBox(width: AppSpacing.xs),
                    RestaurantReviewsInfo(
                      isRatingEnough: _isRatingEnough(),
                      numOfRatings: restaurant.userRatingsTotal,
                      quality: restaurant.quality(restaurant.rating as double),
                    ),
                    RestaurantPriceLevel(priceLevel: priceLevel),
                    const SizedBox(width: AppSpacing.xs),
                    RestaurantTags(restaurant: restaurant),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantCardImage extends StatelessWidget {
  const RestaurantCardImage({required this.restaurant, super.key});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final (:thumbnailHeight, :thumbnailWidth, :imageUrl) = () {
      // If the image is not from Unsplash, return the original image URL.
      final unsplashUrlRegExp = RegExp(r'^https:\/\/images\.unsplash\.com\/');
      if (!unsplashUrlRegExp.hasMatch(restaurant.imageUrl)) {
        return (
          thumbnailHeight: null,
          thumbnailWidth: null,
          imageUrl: restaurant.imageUrl
        );
      }

      final screenWidth = context.screenWidth;
      final pixelRatio = context.devicePixelRatio;

      // AppSpacing.md * 2 is the horizontal padding of the screen.
      final thumbnailWidth =
          min(((screenWidth - (AppSpacing.md * 2)) * pixelRatio) ~/ 1, 1920);
      final thumbnailHeight = min((thumbnailWidth * (9 / 16)).toInt(), 1080);

      final widthRegExp = RegExp(r'w=\d+');
      final heightRegExp = RegExp(r'h=\d+');
      final imageUrl = restaurant.imageUrl.replaceFirst(
        widthRegExp,
        'w=$thumbnailWidth',
      );
      final queryParameters = Uri.parse(imageUrl).queryParameters;
      final finalImageUrl = imageUrl.contains(RegExp(r'h=\d+'))
          ? imageUrl.replaceFirst(
              heightRegExp,
              'h=$thumbnailHeight',
            )
          : Uri.parse(imageUrl).replace(
              queryParameters: {
                ...queryParameters,
                'h': '$thumbnailHeight',
              },
            ).toString();
      return (
        thumbnailHeight: thumbnailHeight,
        thumbnailWidth: thumbnailWidth,
        imageUrl: finalImageUrl,
      );
    }();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ImageAttachmentThumbnail(
        memCacheHeight: thumbnailHeight,
        memCacheWidth: thumbnailWidth,
        imageUrl: imageUrl,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
    );
  }
}

class RestaurantReviewsInfo extends StatelessWidget {
  const RestaurantReviewsInfo({
    required this.isRatingEnough,
    required this.numOfRatings,
    required this.quality,
    super.key,
  });

  final bool isRatingEnough;
  final int numOfRatings;
  final String quality;

  @override
  Widget build(BuildContext context) {
    return !isRatingEnough
        ? const SizedBox.shrink()
        : Text(
            numOfRatings >= 50 ? '$quality ($numOfRatings+) ' : 'Few Ratings ',
            style: context.bodyMedium?.apply(
              color: numOfRatings >= 30
                  ? context.customReversedAdaptiveColor(
                      light: AppColors.black,
                      dark: AppColors.white,
                    )
                  : context.customReversedAdaptiveColor(
                      light: AppColors.background,
                      dark: AppColors.brightGrey,
                    ),
            ),
          );
  }
}

class RestaurantTags extends StatelessWidget {
  const RestaurantTags({required this.restaurant, super.key});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
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
              .bookmarkRestaurant(placeId: restaurant.placeId),
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
    TextStyle? effectiveStyle(int level) {
      return context.bodyMedium?.apply(
        color: priceLevel >= level
            ? context.customReversedAdaptiveColor(
                light: AppColors.black,
                dark: AppColors.white,
              )
            : AppColors.grey,
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: currency, style: effectiveStyle(1)),
          TextSpan(text: currency, style: effectiveStyle(2)),
          TextSpan(text: currency, style: effectiveStyle(3)),
        ],
      ),
    );
  }
}

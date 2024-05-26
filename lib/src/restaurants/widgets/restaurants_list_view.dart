import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurants/restaurants.dart';
import 'package:shared/shared.dart';

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
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
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
                          radius: AppSpacing.md + AppSpacing.sm,
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
                          child: AppCircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      }
                      final restaurant = restaurants[index];
                      final openNow = restaurant.openingHours.openNow;

                      return Opacity(
                        opacity: openNow ? 1 : 0.6,
                        child: RestaurantCard(
                          restaurant: restaurant,
                        ),
                      );
                    },
                    childCount: restaurants.length + (hasMore ? 1 : 0),
                  ),
                ),
    );
  }
}

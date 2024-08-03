import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/network_error/network_error.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/restaurants.dart';

class RestaurantsListView extends StatelessWidget {
  const RestaurantsListView({
    this.restaurants = const <Restaurant>[],
    super.key,
  });

  final List<Restaurant> restaurants;

  @override
  Widget build(BuildContext context) {
    final restaurantsPage =
        context.select((RestaurantsBloc bloc) => bloc.state.restaurantsPage);
    final isFailure =
        context.select((RestaurantsBloc bloc) => bloc.state.status.isFailure);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: restaurants.isEmpty
          ? SliverList.builder(
              itemBuilder: (context, index) {
                final totalRestaurants = restaurantsPage.totalRestaurants;
                final hasMoreRestaurants = restaurantsPage.hasMore;
                final restaurants = restaurantsPage.restaurants;
                final restaurant = restaurants[index];

                return _buildItem(
                  context: context,
                  index: index,
                  totalRestaurants: totalRestaurants,
                  hasMoreRestaurants: hasMoreRestaurants,
                  isFailure: isFailure,
                  restaurant: restaurant,
                );
              },
              itemCount: restaurantsPage.restaurants.length,
            )
          : SliverList.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                final openNow = restaurant.openNow;

                final card = RestaurantCard(restaurant: restaurant);
                if (openNow) return card;
                return Opacity(opacity: 0.6, child: card);
              },
            ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required int index,
    required int totalRestaurants,
    required bool hasMoreRestaurants,
    required bool isFailure,
    required Restaurant restaurant,
  }) {
    if (index + 1 == totalRestaurants && hasMoreRestaurants) {
      if (isFailure) {
        if (!hasMoreRestaurants) return const SizedBox.shrink();
        return NetworkError(
          onRetry: () {
            context
                .read<RestaurantsBloc>()
                .add(const RestaurantsFetchRequested());
          },
        );
      } else {
        return Padding(
          padding:
              EdgeInsets.only(top: totalRestaurants == 0 ? AppSpacing.md : 0),
          child: RestaurantsLoaderItem(
            key: ValueKey(index),
            onPresented: () => hasMoreRestaurants
                ? context
                    .read<RestaurantsBloc>()
                    .add(const RestaurantsFetchRequested())
                : null,
          ),
        );
      }
    }
    final openNow = restaurant.openNow;

    final card = RestaurantCard(restaurant: restaurant);
    if (openNow) return card;
    return Opacity(opacity: 0.6, child: card);
  }
}

class RestaurantsListViewEmpty extends StatelessWidget {
  const RestaurantsListViewEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: AppSpacing.xlg,
          ),
          child: ShimmerPlaceholder.rectangle(
            height: 160,
            borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
            width: double.infinity,
          ),
        );
      },
      itemCount: 5,
    );
  }
}

class RestaurantsListViewError extends StatelessWidget {
  const RestaurantsListViewError({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 120),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: Column(
            children: [
              Text(
                'Something went wrong.',
                style: context.headlineSmall?.copyWith(),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Contact me emilzulufov.commercial@gmail.com to '
                'notify about error.',
                textAlign: TextAlign.center,
                style: context.titleLarge?.apply(color: AppColors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/restaurants.dart';

class RestaurantsListView extends StatelessWidget {
  const RestaurantsListView({
    required this.restaurants,
    required this.hasMore,
    super.key,
  });

  final List<Restaurant> restaurants;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    final isError =
        context.select((RestaurantsBloc bloc) => bloc.state.status.isError);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: Builder(
        builder: (_) {
          if (isError) return const RestaurantsListViewError();
          if (restaurants.isEmpty) return const RestaurantsListViewEmpty();
          return SliverList.builder(
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              final openNow = restaurant.openNow;

              final card = RestaurantCard(restaurant: restaurant);
              if (openNow) return card;
              return Opacity(opacity: 0.6, child: card);
            },
            itemCount: restaurants.length,
          );
        },
      ),
    );
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
            bottom: 24,
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

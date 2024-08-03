import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_food_delivery_clone/src/map/map.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/restaurants.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/tags/tags.dart';

final PageStorageBucket _bucket = PageStorageBucket();

class RestaurantsPage extends StatelessWidget {
  const RestaurantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: _bucket,
      child: const RestaurantsView(),
    );
  }
}

class RestaurantsView extends StatefulWidget {
  const RestaurantsView({super.key});

  @override
  State<RestaurantsView> createState() => _MainPageBodyUIState();
}

class _MainPageBodyUIState extends State<RestaurantsView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.white,
      color: AppColors.black,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      displacement: 30,
      onRefresh: () async {
        context.read<LocationBloc>().add(const LocationFetchAddressRequested());
        context
            .read<RestaurantsBloc>()
            .add(const RestaurantsRefreshRequested());
      },
      child: BlocBuilder<RestaurantsBloc, RestaurantsState>(
        builder: (context, state) {
          final restaurants = state.restaurants;
          final withFilteredRestaurants =
              state.status.isWithFilteredRestaurants;

          final isLoading = state.status.isLoading;
          final isFailure = state.status.isError;

          return CustomScrollView(
            controller: _scrollController,
            key: const PageStorageKey('restaurantsPage'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const RestaurantsAppBar(),
              if (isLoading) const RestaurantsLoadingView(),
              if (isFailure)
                RestaurantsErrorView(
                  onTryAgain: () => context.read<RestaurantsBloc>().add(
                        const RestaurantsRefreshRequested(),
                      ),
                ),
              if (!isLoading && !isFailure) ...[
                if (restaurants.isEmpty)
                  const RestaurantsEmptyView()
                else ...[
                  if (!withFilteredRestaurants) ...[
                    const RestaurantsSectionHeader(text: 'All restaurants'),
                    const TagsSlider(),
                    RestaurantsListView(
                      restaurants: restaurants,
                      hasMore: false,
                    ),
                  ] else ...[
                    const TagsSlider(),
                    const SliverToBoxAdapter(
                      child: Divider(
                        height: 1,
                        indent: AppSpacing.md,
                        endIndent: AppSpacing.md,
                      ),
                    ),
                    const FilteredRestaurantsFoundCount(),
                    const FilteredRestaurantsView(),
                  ],
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

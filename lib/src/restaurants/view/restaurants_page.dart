// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/home/bloc/main_test_bloc.dart';
import 'package:papa_burger/src/restaurants/categories/categories.dart';
import 'package:papa_burger/src/restaurants/restaurants.dart';

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
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: Colors.black,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      displacement: 30,
      onRefresh: () async =>
          context.read<MainTestBloc>()..add(const MainTestRefreshed()),
      child: BlocConsumer<MainTestBloc, MainTestState>(
        listener: (context, state) {
          final noInternet = state.noInternet;
          final outOfTime = state.outOfTime;
          final clientFailure = state.clientFailure;
          final malformed = state.malformed;
          final message = state.errMessage;

          if (noInternet) {
            context.showUndismissableSnackBar(
              message,
              action: SnackBarAction(
                label: 'REFRESH',
                textColor: Colors.indigo.shade300,
                onPressed: () =>
                    context.read<MainTestBloc>().add(const MainTestRefreshed()),
              ),
            );
          }
          if (clientFailure) {
            context.showSnackBar(message);
          }
          if (malformed) {
            context.showSnackBar(message);
          }
          if (outOfTime) {
            context.showUndismissableSnackBar(
              message,
              action: SnackBarAction(
                label: 'TRY AGAIN',
                textColor: Colors.indigo.shade300,
                onPressed: () =>
                    context.read<MainTestBloc>().add(const MainTestRefreshed()),
              ),
            );
          }
          if (!clientFailure && !malformed && !outOfTime && !noInternet) {
            context.closeSnackBars();
          }
        },
        listenWhen: (p, c) => p.status != c.status,
        builder: (context, state) {
          final tags = state.tags;
          final restaurants = state.restaurants;
          final filteredRestaurants = state.filteredRestaurants;

          final loaded = state.withRestaurantsAndTags;
          final filtered = state.withFilteredRestaurants;
          final empty = state.empty;
          final loading = state.loading;
          final error = state.clientFailure || state.malformed;
          final noInternet = state.noInternet;
          final outOfTime = state.outOfTime;

          return CustomScrollView(
            controller: _scrollController,
            key: const PageStorageKey('restaurantsPage'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const RestaurantsAppBar(),
              if (loading) const RestaurantsLoadingView(),
              if (error)
                RestaurantsErrorView(
                  onTryAgain: () => context
                      .read<MainTestBloc>()
                      .add(const MainTestRefreshed()),
                ),
              if (noInternet) const RestaurantsNoInternetView(),
              if (outOfTime) const RestaurantsTimeoutView(),
              if (empty) const RestaurantsEmptyView(),
              if (filtered) ...[
                CategoriesSlider(tags: tags),
                FilteredRestaurantsHeader(
                  tags: tags,
                  filteredRestaurantsCount: filteredRestaurants.length,
                ),
                RestaurantsListView(
                  restaurants: filteredRestaurants,
                  hasMore: false,
                ),
              ],
              if (loaded) ...[
                const RestaurantsSectionHeader(text: 'Restaurants'),
                CategoriesSlider(tags: tags),
                RestaurantsListView(restaurants: restaurants, hasMore: false),
              ],
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papa_burger/src/config/extensions/snack_bar_extension.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CategoriesSlider,
        DisalowIndicator,
        FilteredRestaurantsListView,
        FilteredRestaurantsView,
        MainPageEmptyView,
        MainPageErrorView,
        MainPageHeader,
        MainPageLoadingView,
        MainPageNoInternetView,
        RestaurantsListView;
import 'package:papa_burger/src/views/pages/main/state/bloc/main_test_bloc.dart';

import 'package:papa_burger/src/views/pages/main/state/main_page_state.dart';

final PageStorageBucket _bucket = PageStorageBucket();

class RestaurantView extends StatelessWidget {
  const RestaurantView({
    super.key,
    this.state,
  });

  final MainPageState? state;

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: _bucket,
      child: RestaurantViewUI(
        state: state,
      ),
    );
  }
}

class RestaurantViewUI extends StatefulWidget {
  const RestaurantViewUI({
    super.key,
    this.state,
  });

  final MainPageState? state;

  @override
  State<RestaurantViewUI> createState() => _MainPageBodyUIState();
}

class _MainPageBodyUIState extends State<RestaurantViewUI> {
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  final _hasMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  bool _isAtTheEdge() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      return true;
    } else {
      return false;
    }
  }

  void _scrollListener() {
    if (_isLoading == true || !_hasMore) return;
    if (_isAtTheEdge() && _isLoading == false && _hasMore) {
      if (mounted) setState(() => _isLoading = true);
    }
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
            context.showUndismissibleSnackBar(
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
            context.showUndismissibleSnackBar(
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
          return CustomScrollView(
            controller: _scrollController,
            key: const PageStorageKey('main_page_body'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const MainPageHeader(),
              if (loading) const MainPageLoadingView(),
              if (error)
                MainPageErrorView(
                  refresh: () => context
                      .read<MainTestBloc>()
                      .add(const MainTestRefreshed()),
                ),
              if (noInternet) const MainPageNoInternetView(),
              if (empty) const MainPageEmptyView(),
              if (filtered) ...[
                CategoriesSlider(tags: tags),
                FilteredRestaurantsView(
                  tags: tags,
                  filteredRestaurantsCount: filteredRestaurants.length,
                ),
                FilteredRestaurantsListView(
                  filteredRestaurants: filteredRestaurants,
                ),
              ],
              if (loaded) ...[
                const SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                CategoriesSlider(tags: tags),
                RestaurantsListView(restaurants: restaurants, hasMore: false),
              ],
            ],
          );
        },
      ).disalowIndicator(),
    );
  }
}

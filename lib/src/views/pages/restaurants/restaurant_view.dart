// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CategoriesSlider,
        CustomCircularIndicator,
        DisalowIndicator,
        KText,
        MainBloc,
        MainPageErrorView,
        MainPageHeader,
        MainPageNoInternetView,
        MainPageService,
        Message,
        NetworkException,
        Restaurant,
        RestaurantsListView,
        RestaurantsPage,
        logger;

import 'package:papa_burger/src/views/pages/main_page/state/main_page_state.dart';

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
  final MainPageService _mainPageService = MainPageService();
  final ScrollController _scrollController = ScrollController();
  late final MainBloc _mainBloc;

  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  bool _hasMore = false;
  String? _pageToken;
  Message? _errorMessage;

  @override
  void initState() {
    super.initState();
    _mainBloc = _mainPageService.mainBloc;
    if (_mainBloc.hasNewLatLng) {
      logger.w('Updating restaurants');
      _restaurants.clear();
      _mainBloc.fetchAllRestaurantsByLocation(
        lat: _mainBloc.tempLat,
        lng: _mainBloc.tempLng,
        updateByNewLatLng: true,
      );
      if (mounted) {
        _mainBloc.removeTempLatLng;
      }
    }
    _scrollController.addListener(_scrollListener);
  }

  bool _isAtTheEdge() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _restaurants.isNotEmpty) {
      logger.w('At The Edge');
      return true;
    } else {
      return false;
    }
  }

  Future<void> _scrollListener() async {
    if (_isLoading == true || !_hasMore) return;
    if (_isAtTheEdge() && _isLoading == false && _hasMore) {
      if (mounted) setState(() => _isLoading = true);

      logger.w('Getting New Page By Page Token $_pageToken');
      // final newPage = await _mainBloc.getNextRestaurantsPage(_pageToken, true);
      final newPage = RestaurantsPage(restaurants: []);
      logger.w('Restaurants length ${newPage.restaurants.length}');

      if (mounted) {
        setState(
          () {
            _isLoading = false;
            logger.w(
              'Page Token From New Restaurant Page ${newPage.nextPageToken}',
            );
            _pageToken = newPage.nextPageToken;
            _hasMore =
                !(newPage.restaurants.length < 20) || !(_pageToken == null);
            logger.w('New Page Token $_pageToken');
            _restaurants = _restaurants + newPage.restaurants;
            logger.w('Total Length is ${_restaurants.length}');
          },
        );
      }
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
      onRefresh: () async => _mainBloc.refresh(),
      child: CustomScrollView(
        controller: _scrollController,
        key: const PageStorageKey('restaurant_view_ui'),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const MainPageHeader(),
          if (widget.state is MainPageLoading) const SliverToBoxAdapter(),
          if (widget.state is MainPageError) const SliverToBoxAdapter(),
          if (widget.state is MainPageWithNoRestaurants)
            const SliverToBoxAdapter(),
          if (widget.state is MainPageWithRestaurants)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoriesSlider(
                    tags: _mainBloc.restaurantsTags,
                  ),
                ],
              ),
            ),
          if (widget.state == null) const SliverToBoxAdapter(),
          if (widget.state is MainPageLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 24),
                child: CustomCircularIndicator(
                  color: Colors.black,
                ),
              ),
            ),
          if (widget.state is MainPageError)
            if ((widget.state as MainPageError?)?.error is NetworkException)
              const MainPageNoInternetView()
            else
              MainPageErrorView(refresh: () => _mainBloc.refresh()),
          if (widget.state is MainPageWithNoRestaurants)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 24),
                child: KText(
                  text: 'No restaurants😔',
                  size: 24,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (widget.state is MainPageWithRestaurants)
            RestaurantsListView(
              restaurants:
                  (widget.state as MainPageWithRestaurants?)?.restaurants ?? [],
              hasMore: _hasMore,
              errorMessage: _errorMessage,
            ),
          if (widget.state is MainPageWithFilteredRestaurants)
            RestaurantsListView(
              restaurants: (widget.state as MainPageWithFilteredRestaurants?)
                      ?.filteredRestaurants ??
                  [],
              hasMore: _hasMore,
              errorMessage: _errorMessage,
            ),
          if (widget.state == null)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 24),
                child: CustomCircularIndicator(
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ).disalowIndicator(),
    );
  }
}

import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart';
import 'package:papa_burger/src/models/restaurant/google_restaurant.dart';
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CategoriesSlider,
        DisalowIndicator,
        HeaderView,
        KText,
        MainBloc,
        MainPageService,
        SearchBar,
        kDefaultHorizontalPadding,
        logger;
import 'package:papa_burger/src/views/pages/main_page/components/restaurant/google_restaurants_list_view.dart';

final PageStorageBucket globalBucket = PageStorageBucket();

class MainPageBody extends StatefulWidget {
  const MainPageBody({
    super.key,
  });

  @override
  State<MainPageBody> createState() => _MainPageBodyState();
}

class _MainPageBodyState extends State<MainPageBody> {
  final MainPageService _mainPageService = MainPageService();
  final ScrollController _scrollController = ScrollController();
  late final MainBloc _mainBloc;
  late StreamSubscription _restaurantsSubscription;

  List<GoogleRestaurant> _restaurants = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String? _pageToken;
  Map<String, String>? _errorMessage;

  @override
  void initState() {
    super.initState();
    _mainBloc = _mainPageService.mainBloc;
    // _initRestaurants();

    if (_mainBloc.hasNewLatAndLng) {
      logger.w('Updating restaurants');
      _restaurants.clear();
      _mainBloc.updateRestaurants(
          _mainBloc.tempLat, _mainBloc.tempLng, null, true);
      setState(() {
        _mainBloc.removeTempLatAndLng;
      });
    }
    _restaurantsSubscription = _mainBloc.restaurantsPageStream.listen((page) {
      logger.w('status message ${page.status}');
      if (page.status == 'Connection Timeout'.toLowerCase() ||
          page.status == 'Unknown error'.toLowerCase()) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: KText(
                text: page.errorMessage!,
              ),
            ),
          );
      }
      if (mounted) {
        setState(() {
          _restaurants = page.restaurants;
          _pageToken = page.nextPageToken;
          _hasMore = page.hasMore ?? true;
          _errorMessage = RestaurantsPage.getErrorMessage(page.errorMessage);
        });
      }
    });
    _scrollController.addListener(_scrollListener);
  }

  void _initRestaurants() async {
    if (_restaurants.isEmpty) {
      logger.w('Getting Initial Page By Page Token $_pageToken');
      final firstPage = await _mainBloc.fetchFirstPage(_pageToken, true);
      setState(() {
        _restaurants = firstPage.restaurants;
        _pageToken = firstPage.nextPageToken;
        _hasMore = _pageToken == null ? false : true;
        logger.w('First Page Token $_pageToken');
        // logger.w('Restaurants length ${firstPage.restaurants.length}');
      });
    }
    return;
  }

  bool _isAtTheEdge() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      logger.w('At The Edge');
      return true;
    } else {
      return false;
    }
  }

  void _scrollListener() async {
    if (_isLoading == true || !_hasMore) return;
    if (_isAtTheEdge() && _isLoading == false && _hasMore) {
      setState(() => _isLoading = true);

      logger.w('Getting New Page By Page Token $_pageToken');
      final newPage = await _mainBloc.getNextRestaurantsPage(_pageToken, true);
      logger.w('Restaurants length ${newPage.restaurants.length}');

      setState(() {
        _isLoading = false;
        logger
            .w('Page Token From New Restaurant Page ${newPage.nextPageToken}');
        _pageToken = newPage.nextPageToken;
        _hasMore = newPage.restaurants.length < 20 || _pageToken == null
            ? false
            : true;
        logger.w('New Page Token $_pageToken');
        _restaurants = _restaurants + newPage.restaurants;
        logger.w('Total Length is ${_restaurants.length}');
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _restaurantsSubscription.cancel();
  }

  _buildHeaderName(String text) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
        ),
        child: KText(
          text: text,
          size: 26,
          fontWeight: FontWeight.bold,
        ),
      );

  _buildHeader(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      floating: true,
      collapsedHeight: 133,
      flexibleSpace: Column(
        children: const [
          SizedBox(
            height: kDefaultHorizontalPadding,
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding),
            child: HeaderView(),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding),
            child: SearchBar(),
          ),
        ],
      ),
    );
  }

  _buildUi(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: Colors.black,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      displacement: 30,
      onRefresh: () async {},
      child: CustomScrollView(
        controller: _scrollController,
        key: const PageStorageKey('main_page_body'),
        scrollDirection: Axis.vertical,
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderName('Categories'),
                CategoriesSlider(
                  restaurants: _restaurants,
                ),
                _buildHeaderName('Restaurants'),
              ],
            ),
          ),
          GoogleRestaurantsListView(
            restaurants: _restaurants,
            hasMore: _hasMore,
            errorMessage: _errorMessage,
          ),
        ],
      ).disalowIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: globalBucket,
      child: _buildUi(context),
    );
  }
}

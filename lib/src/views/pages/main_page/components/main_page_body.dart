// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CategoriesSlider,
        CustomCircularIndicator,
        CustomIcon,
        CustomSearchBar,
        DisalowIndicator,
        GoogleRestaurant,
        GoogleRestaurantsListView,
        HeaderView,
        IconType,
        KText,
        MainBloc,
        MainPageService,
        Message,
        kDefaultHorizontalPadding,
        kPrimaryBackgroundColor,
        logger;

import 'package:papa_burger/src/views/pages/main_page/state/main_page_state.dart';

final PageStorageBucket globalBucket = PageStorageBucket();

class MainPageBody extends StatefulWidget {
  const MainPageBody({
    super.key,
    this.state,
  });
  final MainPageState? state;

  @override
  State<MainPageBody> createState() => _MainPageBodyState();
}

class _MainPageBodyState extends State<MainPageBody> {
  final MainPageService _mainPageService = MainPageService();
  final ScrollController _scrollController = ScrollController();
  late final MainBloc _mainBloc;
  // late StreamSubscription _restaurantsSubscription;

  List<GoogleRestaurant> _restaurants = [];
  bool _isLoading = false;
  bool _hasMore = false;
  String? _pageToken;
  Message? _errorMessage;

  @override
  void initState() {
    super.initState();
    _mainBloc = _mainPageService.mainBloc;
    // _initRestaurants();

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
    // _restaurantsSubscription = _mainBloc.restaurantsPageStream.listen(
    //   (page) {
    //     logger.w('status message ${page.status}');
    //     if (page.status == 'Connection Timeout'.toLowerCase() ||
    //         page.status == 'Unknown error'.toLowerCase()) {
    //       ScaffoldMessenger.of(context)
    //         ..hideCurrentSnackBar()
    //         ..showSnackBar(
    //           SnackBar(
    //             content: KText(
    //               text: page.errorMessage!,
    //             ),
    //           ),
    //         );
    //     }
    //     if (mounted) {
    //       setState(() {
    //         // _restaurants = page.restaurants;
    //         _restaurants = _mainBloc.allRestaurants;
    //         _pageToken = page.nextPageToken;
    //         _hasMore = page.hasMore ?? true;
    //         _errorMessage = RestaurantsPage.getErrorMessage(page.errorMessage);
    //       });
    //     }
    //   },
    // );
    _scrollController.addListener(_scrollListener);
  }

  // void _initRestaurants() async {
  //   if (_restaurants.isEmpty) {
  //     logger.w('Getting Initial Page By Page Token $_pageToken');
  //     final firstPage = await _mainBloc.fetchFirstPage(_pageToken, true);
  //     if (mounted) {
  //       setState(() {
  //         _restaurants = firstPage.restaurants;
  //         _pageToken = firstPage.nextPageToken;
  //         _hasMore = _pageToken == null ? false : true;
  //         logger.w('First Page Token $_pageToken');
  //         // logger.w('Restaurants length ${firstPage.restaurants.length}');
  //       });
  //     }
  //   }
  //   return;
  // }

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
    // _restaurantsSubscription.cancel();
  }

  Padding _buildHeaderName(String text) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
        ),
        child: KText(
          text: text,
          size: 26,
          fontWeight: FontWeight.bold,
        ),
      );

  SliverAppBar _buildHeader(BuildContext context) {
    return const SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      excludeHeaderSemantics: true,
      scrolledUnderElevation: 12,
      floating: true,
      collapsedHeight: 133,
      flexibleSpace: Column(
        children: [
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
            child: CustomSearchBar(
              enabled: false,
            ),
          ),
        ],
      ),
    );
  }

  RefreshIndicator _buildUi(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: Colors.black,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      displacement: 30,
      onRefresh: () async => _mainBloc.refresh(),
      child: CustomScrollView(
        controller: _scrollController,
        key: const PageStorageKey('main_page_body'),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildHeader(context),
          if (widget.state is MainPageLoading) const SliverToBoxAdapter(),
          if (widget.state is MainPageError) const SliverToBoxAdapter(),
          if (widget.state is MainPageWithNoRestaurants)
            const SliverToBoxAdapter(),
          if (widget.state is MainPageWithRestaurants ||
              widget.state is MainPageWithFilteredRestaurants)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderName('Categories'),
                  CategoriesSlider(
                    tags: _mainBloc.restaurantsTags,
                  ),
                  _buildHeaderName('Restaurants'),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  children: [
                    const KText(
                      text: 'Something went wrong!',
                      size: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          kPrimaryBackgroundColor,
                        ),
                      ),
                      onPressed: _mainBloc.refresh,
                      icon: const CustomIcon(
                        type: IconType.simpleIcon,
                        icon: FontAwesomeIcons.arrowsRotate,
                        color: Colors.white,
                        size: 14,
                      ),
                      label: const KText(
                        text: 'Try again.',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
            GoogleRestaurantsListView(
              restaurants:
                  (widget.state as MainPageWithRestaurants?)?.restaurants ?? [],
              hasMore: _hasMore,
              errorMessage: _errorMessage,
            ),
          if (widget.state is MainPageWithFilteredRestaurants)
            GoogleRestaurantsListView(
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

  @override
  Widget build(BuildContext context) {
    logger.w('Build Main Page Body');
    return PageStorage(
      bucket: globalBucket,
      child: _buildUi(context),
    );
  }
}

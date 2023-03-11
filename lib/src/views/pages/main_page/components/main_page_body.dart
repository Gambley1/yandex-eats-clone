import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        Restaurant,
        MainBloc,
        kDefaultHorizontalPadding,
        mainPageKey,
        KText,
        HeaderView,
        CategoriesSlider,
        SearchBar,
        RestaurantsListView,
        DisalowIndicator;

class MainPageBody extends StatefulWidget {
  const MainPageBody({
    super.key,
    required this.restaurants,
  });

  final List<Restaurant> restaurants;

  @override
  State<MainPageBody> createState() => _MainPageBodyState();
}

class _MainPageBodyState extends State<MainPageBody> {
  final String title = 'What do you want today Sir?';

  late final MainBloc _mainBloc;

  @override
  void initState() {
    super.initState();
    _mainBloc = MainBloc();
  }

  @override
  void dispose() {
    _mainBloc.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: Colors.black,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      displacement: 30,
      onRefresh: () async {},
      child: CustomScrollView(
        key: const PageStorageKey(mainPageKey),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            collapsedHeight: 133,
            flexibleSpace: Column(children: const [
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
            ]),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderName('Categories'),
                CategoriesSlider(
                  restaurants: widget.restaurants,
                ),
                _buildHeaderName('Restaurants'),
              ],
            ),
          ),
          RestaurantsListView(
            restaurants: widget.restaurants,
          ),
        ],
      ).disalowIndicator(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart';

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
      onRefresh: () async {
        if (context.mounted) {
          _mainBloc.getRestaurants();
        }
      },
      child: CustomScrollView(
        key: const PageStorageKey(mainPageKey),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            floating: true,
            collapsedHeight: 140,
            flexibleSpace: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultHorizontalPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: const [
                  SizedBox(
                    height: kDefaultHorizontalPadding,
                  ),
                  HeaderView(
                      // location: location!,
                      ),
                  SizedBox(
                    height: 16,
                  ),
                  SearchBar(),
                ],
              ),
            ),
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

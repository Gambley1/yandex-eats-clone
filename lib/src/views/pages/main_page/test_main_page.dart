import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons, FaIcon;
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:page_transition/page_transition.dart'
    show PageTransition, PageTransitionType;
import 'package:papa_burger/src/restaurant.dart'
    show
        CartView,
        HeaderView,
        MainPageBody,
        MyThemeData,
        NavigationBloc,
        RestaurantView,
        SearchBar,
        kDefaultHorizontalPadding;
import 'package:papa_burger/src/views/pages/cart/test_cart_view.dart';

class TestMainPage extends StatefulWidget {
  const TestMainPage({super.key});

  @override
  State<TestMainPage> createState() => _TestMainPageState();
}

class _TestMainPageState extends State<TestMainPage> {
  late final NavigationBloc _navigationBloc;

  @override
  void initState() {
    super.initState();
    _navigationBloc = NavigationBloc();
  }

  _bottomNavigationBar(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.white,
        labelTextStyle: MaterialStateProperty.all(
          GoogleFonts.getFont(
            'Quicksand',
            textStyle: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
      child: NavigationBar(
        animationDuration: const Duration(
          microseconds: 500,
        ),
        selectedIndex: _navigationBloc.pageIndex,
        onDestinationSelected: (index) {
          setState(() => _navigationBloc.navigation(index));

          if (_navigationBloc.pageIndex == 2) {
            Navigator.of(context).pushAndRemoveUntil(
              PageTransition(
                child: const TestCartView(),
                type: PageTransitionType.fade,
              ),
              (route) => true,
            );
          }
        },
        height: 60,
        destinations: const [
          NavigationDestination(
            tooltip: '',
            icon: FaIcon(
              FontAwesomeIcons.house,
              color: Colors.grey,
              size: 20,
            ),
            selectedIcon: FaIcon(
              FontAwesomeIcons.house,
              size: 21,
              color: Colors.black,
            ),
            label: 'Main',
          ),
          NavigationDestination(
            tooltip: '',
            icon: FaIcon(
              FontAwesomeIcons.burger,
              color: Colors.grey,
              size: 20,
            ),
            selectedIcon: FaIcon(
              FontAwesomeIcons.burger,
              size: 21,
              color: Colors.black,
            ),
            label: 'Restaurants',
          ),
          NavigationDestination(
            tooltip: '',
            icon: FaIcon(
              FontAwesomeIcons.basketShopping,
              color: Colors.grey,
              size: 20,
            ),
            selectedIcon: FaIcon(
              FontAwesomeIcons.basketShopping,
              size: 21,
              color: Colors.black,
            ),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

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

  _buildBody(BuildContext context, int pageInedx) {
    switch (pageInedx) {
      case 0:
        return const MainPageBody();
      case 1:
        return const RestaurantView();
    }
    return const SliverToBoxAdapter();
  }

  _buildUi(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(context),
      body: SafeArea(
        child: StreamBuilder<int>(
          stream: _navigationBloc.navigationSubject.stream,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case 0:
                return const MainPageBody();
              case 1:
                return const RestaurantView();
            }
            return const Scaffold();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.globalThemeData,
      child: _buildUi(context),
    );
  }
}

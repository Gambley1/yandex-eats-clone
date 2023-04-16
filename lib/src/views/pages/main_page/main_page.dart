import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons, FaIcon;
import 'package:papa_burger/src/config/utils/app_constants.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CartBlocTest,
        CustomScaffold,
        HeaderView,
        MainPageBody,
        MyThemeData,
        NavigationBloc,
        NavigatorExtension,
        RestaurantView,
        SearchBar,
        kDefaultHorizontalPadding,
        logger;
import 'package:papa_burger/src/views/pages/main_page/components/drawer/drawer_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final NavigationBloc _navigationBloc;
  final CartBlocTest _cartBlocTest = CartBlocTest();

  @override
  void initState() {
    super.initState();

    _navigationBloc = NavigationBloc();
  }

  _bottomNavigationBar(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        elevation: 12,
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.white,
        labelTextStyle: MaterialStateProperty.all(
          defaultTextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            size: 14,
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
            context.navigateToCart();
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
    return CustomScaffold(
      drawer: const DrawerView(),
      bottomNavigationBar: _bottomNavigationBar(context),
      withSafeArea: true,
      body: StreamBuilder<int>(
        stream: _navigationBloc.navigationSubject.stream,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case 0:
              return const MainPageBody();
            case 1:
              return const RestaurantView();
          }
          return CustomScaffold(
            body: Container(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.w('Build or Rebuild UI in Test Main Page');
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.globalThemeData,
      child: _buildUi(context),
    );
  }
}

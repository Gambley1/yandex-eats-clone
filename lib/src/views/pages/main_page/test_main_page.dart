import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:papa_burger/src/views/pages/main_page/services/main_page_service.dart';

class TestMainPage extends StatefulWidget {
  const TestMainPage({super.key});

  @override
  State<TestMainPage> createState() => _TestMainPageState();
}

class _TestMainPageState extends State<TestMainPage> {
  final MainPageService _mainPageService = MainPageService();

  late final MainBloc _mainBloc;
  late final NavigationBloc _navigationBloc;

  @override
  void initState() {
    super.initState();
    _mainBloc = _mainPageService.mainBloc;
    _navigationBloc = _mainPageService.navigationBloc;
  }

  @override
  void dispose() {
    _mainBloc.dispose();
    super.dispose();
  }

  _bottomNavigationBar(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: kPrimaryBackgroundColor,
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

          if (_navigationBloc.pageIndex == 3) {
            Navigator.of(context).pushAndRemoveUntil(
              PageTransition(
                child: const CartView(),
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
              FontAwesomeIcons.listUl,
              size: 20,
              color: Colors.grey,
            ),
            selectedIcon: FaIcon(
              FontAwesomeIcons.listUl,
              size: 21,
              color: Colors.black,
            ),
            label: 'Order List',
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

  _mainPageContent(BuildContext context) {
    return StreamBuilder<List<Restaurant>>(
      stream: _mainBloc.getRestaurants(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: KText(text: 'No data'),
          );
        }
        if (snapshot.data!.isEmpty) {
          return const KText(text: 'Empty');
        }
        return MainPageBody(restaurants: snapshot.requireData);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.globalThemeData,
      child: Scaffold(
        bottomNavigationBar: _bottomNavigationBar(context),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              switch (_navigationBloc.pageIndex) {
                case 0:
                  return _mainPageContent(context);
                case 1:
                  return const RestaurantView();
                case 2:
                  return const OrdersView();
              }
              return const Scaffold();
            },
          ),
        ),
      ),
    );
  }
}

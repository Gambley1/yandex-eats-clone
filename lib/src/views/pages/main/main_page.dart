import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
import 'package:papa_burger/src/restaurant.dart'
    show
        CustomScaffold,
        MainPageBody,
        MyThemeData,
        NavigationBloc,
        NavigatorExtension,
        RestaurantView,
        defaultTextStyle;
import 'package:papa_burger/src/views/pages/main/components/drawer/drawer_view.dart';
import 'package:papa_burger/src/views/widgets/hex_color.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.globalThemeData,
      child: MainPageWrapper(),
    );
  }
}

class MainPageWrapper extends StatelessWidget {
  MainPageWrapper({
    super.key,
  });

  final _navigationBloc = NavigationBloc();

  ValueListenableBuilder<int> _bottomNavigationBar() {
    return ValueListenableBuilder(
      valueListenable: _navigationBloc,
      builder: (context, currentIndex, _) {
        return BottomNavigationBar(
          currentIndex: currentIndex,
          iconSize: 21,
          elevation: 12,
          backgroundColor: Colors.white,
          unselectedItemColor: HexColor('#bbbbbb'),
          selectedItemColor: HexColor('#232b2b'),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: defaultTextStyle(),
          unselectedLabelStyle: defaultTextStyle(size: 14),
          onTap: (index) {
            _navigationBloc.navigation = index;

            if (_navigationBloc.currentIndex == 2) {
              context.navigateToCart();
            }
          },
          items: const [
            BottomNavigationBarItem(
              tooltip: 'Main',
              icon: FaIcon(
                FontAwesomeIcons.house,
              ),
              label: 'Main',
            ),
            BottomNavigationBarItem(
              tooltip: 'Restaurants',
              icon: FaIcon(
                FontAwesomeIcons.burger,
              ),
              label: 'Restaurants',
            ),
            BottomNavigationBarItem(
              tooltip: 'Your cart',
              icon: FaIcon(
                FontAwesomeIcons.basketShopping,
              ),
              label: 'Cart',
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      drawer: const DrawerView(),
      bottomNavigationBar: _bottomNavigationBar(),
      withSafeArea: true,
      body: ValueListenableBuilder<int>(
        valueListenable: _navigationBloc,
        builder: (context, index, _) {
          switch (index) {
            case 0:
              return const MainPageBody();
            case 1:
              return const RestaurantView();
            default:
              return CustomScaffold(
                body: Container(),
              );
          }
        },
      ),
    );
  }
}

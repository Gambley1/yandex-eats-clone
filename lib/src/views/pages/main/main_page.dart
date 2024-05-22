import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/drawer_view.dart';
import 'package:papa_burger/src/views/pages/main/components/main_page_body.dart';
import 'package:papa_burger/src/views/pages/main/navigation_state/navigation_bloc.dart';
import 'package:papa_burger/src/views/pages/restaurants/restaurants_view.dart';
import 'package:papa_burger/src/views/widgets/app_scaffold.dart';
import 'package:papa_burger/src/views/widgets/hex_color.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  ValueListenableBuilder<int> _bottomNavigationBar() {
    return ValueListenableBuilder(
      valueListenable: NavigationBloc(),
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
            NavigationBloc().navigation = index;

            if (NavigationBloc().currentIndex == 2) {
              context.goToCart();
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
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: const DrawerView(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: ValueListenableBuilder<int>(
        valueListenable: NavigationBloc(),
        builder: (context, index, _) {
          switch (index) {
            case 0:
              return const MainPageBody();
            case 1:
              return const RestaurantsView();
            default:
              return const AppScaffold(body: SizedBox.shrink());
          }
        },
      ),
    );
  }
}

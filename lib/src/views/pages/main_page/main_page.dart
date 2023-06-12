import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
import 'package:papa_burger/src/models/exceptions.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CustomScaffold,
        KText,
        MainBloc,
        MainPageBody,
        MyThemeData,
        NavigationBloc,
        NavigatorExtension,
        RestaurantView,
        defaultTextStyle;
import 'package:papa_burger/src/views/pages/main_page/components/drawer/drawer_view.dart';
import 'package:papa_burger/src/views/pages/main_page/state/main_page_state.dart';
import 'package:papa_burger/src/views/widgets/hex_color.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  final _mainBloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.globalThemeData,
      child: MainPageWrapper(
        scaffoldMessengerKey: _scaffoldMessengerKey,
        mainBloc: _mainBloc,
      ),
    );
  }
}

class MainPageWrapper extends StatelessWidget {
  MainPageWrapper({
    required this.scaffoldMessengerKey,
    required this.mainBloc,
    super.key,
  });

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final MainBloc mainBloc;

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
    return StreamBuilder<MainPageState>(
      stream: mainBloc.mainPageState,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state is MainPageError) {
          final error = state.error;
          if (error is NetworkException) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              scaffoldMessengerKey.currentState
                ?..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: KText(
                      text: error.message,
                      color: Colors.white,
                    ),
                    duration: const Duration(days: 1),
                    behavior: SnackBarBehavior.floating,
                    dismissDirection: DismissDirection.none,
                    action: SnackBarAction(
                      label: 'REFRESH',
                      textColor: Colors.indigo.shade300,
                      onPressed: mainBloc.refresh,
                    ),
                  ),
                );
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              scaffoldMessengerKey.currentState
                ?..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: const KText(
                      text: 'Something went wrong.',
                      color: Colors.white,
                    ),
                    duration: const Duration(days: 1),
                    behavior: SnackBarBehavior.floating,
                    dismissDirection: DismissDirection.none,
                    action: SnackBarAction(
                      label: 'REFRESH',
                      textColor: Colors.indigo.shade300,
                      onPressed: mainBloc.refresh,
                    ),
                  ),
                );
            });
          }
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scaffoldMessengerKey.currentState?.clearSnackBars();
          });
        }
        return ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: CustomScaffold(
            drawer: const DrawerView(),
            bottomNavigationBar: _bottomNavigationBar(),
            withSafeArea: true,
            body: ValueListenableBuilder<int>(
              valueListenable: _navigationBloc,
              builder: (context, index, _) {
                switch (index) {
                  case 0:
                    return MainPageBody(
                      state: state,
                    );
                  case 1:
                    return RestaurantView(
                      state: state,
                    );
                }
                return CustomScaffold(
                  body: Container(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

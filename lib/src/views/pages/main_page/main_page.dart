import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
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
        defaultTextStyle,
        logger;
import 'package:papa_burger/src/views/pages/main_page/components/drawer/drawer_view.dart';
import 'package:papa_burger/src/views/pages/main_page/state/main_page_state.dart';
import 'package:papa_burger/src/views/widgets/hex_color.dart';
import 'package:rxdart/rxdart.dart' show CompositeSubscription;

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  final _mainBloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    logger.w('Build Main Page');

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.globalThemeData,
      child: MainPageWrapper(
        scaffoldMessengerKey: _scaffoldMessengerKey,
        mainBloc: _mainBloc,
      ),
    );
  }
}

class MainPageWrapper extends StatefulWidget {
  const MainPageWrapper({
    required this.scaffoldMessengerKey,
    required this.mainBloc,
    super.key,
  });

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final MainBloc mainBloc;

  @override
  State<MainPageWrapper> createState() => _MainPageWrapperState();
}

class _MainPageWrapperState extends State<MainPageWrapper> {
  final _navigationBloc = NavigationBloc();

  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    super.initState();
    _subscriptions.add(
      widget.mainBloc.mainPageState.listen(
        (state) {
          final scaffoldMessenger = widget.scaffoldMessengerKey.currentState;
          if (scaffoldMessenger == null) {
            return;
          }
          if (state is MainPageError) {
            scaffoldMessenger
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(
                  duration: Duration(days: 1),
                  behavior: SnackBarBehavior.fixed,
                  content: KText(
                    text: 'Server is temporarily unavailable.',
                    color: Colors.white,
                  ),
                ),
              );
          } else {
            scaffoldMessenger.hideCurrentSnackBar();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _subscriptions.dispose();
    super.dispose();
  }

  ValueListenableBuilder<int> _bottomNavigationBar(BuildContext context) {
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
      stream: widget.mainBloc.mainPageState,
      builder: (context, snapshot) {
        final state = snapshot.data;
        return ScaffoldMessenger(
          key: widget.scaffoldMessengerKey,
          child: CustomScaffold(
            drawer: const DrawerView(),
            bottomNavigationBar: _bottomNavigationBar(context),
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
                    return const RestaurantView();
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

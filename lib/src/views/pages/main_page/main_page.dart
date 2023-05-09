import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons, FaIcon;
import 'package:papa_burger/src/restaurant.dart'
    show
        CustomScaffold,
        KText,
        MainPageBody,
        MainPageService,
        MyThemeData,
        NavigationBloc,
        NavigatorExtension,
        RestaurantView,
        defaultTextStyle,
        logger;
import 'package:papa_burger/src/views/pages/main_page/components/drawer/drawer_view.dart';
import 'package:papa_burger/src/views/pages/main_page/state/main_page_state.dart';
import 'package:rxdart/rxdart.dart' show CompositeSubscription;

import '../../widgets/hex_color.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    logger.w('Build Main Page');

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.globalThemeData,
      child: MainPageWrapper(
        scaffoldMessengerKey: _scaffoldMessengerKey,
      ),
    );
  }
}

class MainPageWrapper extends StatefulWidget {
  const MainPageWrapper({
    super.key,
    required this.scaffoldMessengerKey,
  });

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  @override
  State<MainPageWrapper> createState() => _MainPageWrapperState();
}

class _MainPageWrapperState extends State<MainPageWrapper> {
  final _navigationBloc = NavigationBloc();
  final _mainPageService = MainPageService();

  final _subscriptions = CompositeSubscription();

  @override
  void initState() {
    super.initState();
    _subscriptions.add(
      _mainPageService.mainBloc.mainPageState.listen(
        (state) {
          final scaffoldMessenger = widget.scaffoldMessengerKey.currentState;
          if (scaffoldMessenger == null) {
            logger.w("Scaffold Messenger is null, can't show SnackBar");
            return;
          }
          if (state is MainPageError) {
            logger.w('Server is unavaialble');
            logger.w('Show SnackBar with error');
            scaffoldMessenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  duration: Duration(days: 1),
                  behavior: SnackBarBehavior.fixed,
                  content: KText(
                    text: 'Server is temporarily unavailable!',
                    color: Colors.white,
                  ),
                ),
              );
          } else {
            logger.w('Server is available');
            logger.w('Close any possible SnackBars');
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

  _bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _navigationBloc.pageIndex,
      iconSize: 21,
      elevation: 12,
      backgroundColor: Colors.white,
      unselectedItemColor: HexColor('#bbbbbb'),
      selectedItemColor: HexColor('#232b2b'),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: defaultTextStyle(),
      unselectedLabelStyle: defaultTextStyle(size: 14),
      onTap: (index) {
        setState(() => _navigationBloc.navigation(index));

        if (_navigationBloc.pageIndex == 2) {
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
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: widget.scaffoldMessengerKey,
      child: Scaffold(
        body: CustomScaffold(
          drawer: const DrawerView(),
          bottomNavigationBar: _bottomNavigationBar(context),
          withSafeArea: true,
          body: StreamBuilder<int>(
            stream: _navigationBloc.navigationStream,
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
        ),
      ),
    );
  }
}

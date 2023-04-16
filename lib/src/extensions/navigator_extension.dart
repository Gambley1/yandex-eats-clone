import 'package:flutter/material.dart'
    show BuildContext, Navigator, Route, Widget;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:page_transition/page_transition.dart'
    show PageTransition, PageTransitionType;
import 'package:papa_burger/src/restaurant.dart'
    show
        GoogleMapView,
        GoogleRestaurant,
        LoginView,
        MainPage,
        NavigationBloc,
        PlaceDetails,
        SearchLocationWithAutoComplete,
        SearchView;
import 'package:papa_burger/src/views/pages/cart/test_cart_view.dart';
import 'package:papa_burger/src/views/pages/main_page/components/drawer/views/profile/profile_view.dart';
import 'package:papa_burger/src/views/pages/main_page/components/menu/google_menu_view.dart';

final NavigationBloc _navigationBloc = NavigationBloc();

Route<dynamic> _defaultRoute({
  required Widget child,
  PageTransitionType type = PageTransitionType.fade,
}) =>
    PageTransition(
      child: child,
      type: type,
    );

extension NavigatorExtension on BuildContext {
  void navigateToMainPage() {
    _navigationBloc.navigation(0);
    Navigator.pushAndRemoveUntil(
      this,
      _defaultRoute(
        child: const MainPage(),
      ),
      (route) => false,
    );
  }

  void navigateToMenu(BuildContext context, GoogleRestaurant restaurant,
      {bool fromCart = false}) {
    if (restaurant == const GoogleRestaurant.empty()) {
      context.navigateToMainPage();
    } else {
      Navigator.pushAndRemoveUntil(
        this,
        _defaultRoute(
          child: GoogleMenuView(
            restaurant: restaurant,
            fromCart: fromCart,
          ),
        ),
        (route) => true,
      );
    }
  }

  void pop({bool withHaptickFeedback = false}) {
    if (withHaptickFeedback) {
      HapticFeedback.heavyImpact();
      Navigator.pop(this);
    } else {
      Navigator.pop(this);
    }
  }

  void navigateToCart() => Navigator.pushAndRemoveUntil(
        this,
        _defaultRoute(
          child: TestCartView(),
        ),
        (route) => true,
      );

  void navigateToLogin() => Navigator.pushAndRemoveUntil(
      this,
      _defaultRoute(
        child: const LoginView(),
      ),
      (route) => false);

  void navigateToGoolgeMapView([PlaceDetails? placeDetails]) =>
      Navigator.pushAndRemoveUntil(
        this,
        _defaultRoute(
          child: GoogleMapView(
            placeDetails: placeDetails,
          ),
        ),
        (route) => true,
      );

  void navigateToSearchView() => Navigator.pushAndRemoveUntil(
        this,
        _defaultRoute(
          child: const SearchView(),
        ),
        (route) => true,
      );

  void navigateToSearchLocationWithAutoComplete() =>
      Navigator.pushAndRemoveUntil(
        this,
        _defaultRoute(
          child: const SearchLocationWithAutoComplete(),
        ),
        (route) => true,
      );

  void navigateToProfile() => Navigator.pushAndRemoveUntil(
        this,
        _defaultRoute(
          child: const ProfileView(),
        ),
        (route) => true,
      );
}

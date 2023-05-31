import 'package:flutter/material.dart'
    show BuildContext, Navigator, Route, Widget;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:page_transition/page_transition.dart'
    show PageTransition, PageTransitionType;
import 'package:papa_burger/src/restaurant.dart'
    show
        AppRoutes,
        GoogleMapView,
        GoogleRestaurant,
        NavigationBloc,
        PlaceDetails,
        RestaurantsFilteredView;

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
    _navigationBloc.navigation = 0;
    Navigator.pushNamedAndRemoveUntil(
      this,
      AppRoutes.mainRoute,
      (route) => false,
    );
  }

  void navigateToMenu(
    BuildContext context,
    GoogleRestaurant restaurant, {
    bool fromCart = false,
  }) {
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

  void navigateToCart() => Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.cartRoute,
        (route) => true,
      );

  void navigateToLogin() => Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.loginRoute,
        (route) => false,
      );

  void navigateToRegister() => Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.registerRoute,
        (route) => true,
      );

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

  void navigateToSearchView() => Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.searchRoute,
        (route) => true,
      );

  void navigateToSearchLocationWithAutoComplete() =>
      Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.searchLocationRoute,
        (route) => true,
      );

  void navigateToProfile() => Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.profileRoute,
        (route) => true,
      );

  void navigateToFilteredRestaurants(
    List<GoogleRestaurant> filteredRestaurants,
  ) =>
      Navigator.pushAndRemoveUntil(
        this,
        _defaultRoute(
          child: RestaurantsFilteredView(
            filteredRestaurants: filteredRestaurants,
          ),
        ),
        (route) => true,
      );
}

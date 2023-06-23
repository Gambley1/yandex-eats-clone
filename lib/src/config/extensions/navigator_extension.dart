import 'package:flutter/material.dart'
    show
        BuildContext,
        GlobalKey,
        Navigator,
        Route,
        ScaffoldMessengerState,
        Widget;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:page_transition/page_transition.dart'
    show PageTransition, PageTransitionType;
import 'package:papa_burger/src/restaurant.dart'
    show
        AppRoutes,
        GoogleMapView,
        NavigationBloc,
        PlaceDetails,
        Restaurant,
        RestaurantsFilteredView;
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/components/order_details/order_details_view.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_bloc_test.dart';

import 'package:papa_burger/src/views/pages/main/components/menu/menu_view.dart';

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
    Restaurant restaurant, {
    bool fromCart = false,
  }) {
    if (restaurant == const Restaurant.empty()) {
      context.navigateToMainPage();
    } else {
      Navigator.pushAndRemoveUntil(
        this,
        _defaultRoute(
          child: MenuView(
            restaurant: restaurant,
            fromCart: fromCart,
          ),
        ),
        (route) => true,
      );
    }
  }

  void pop({bool withHaptickFeedback = false, dynamic result}) {
    if (withHaptickFeedback) {
      HapticFeedback.heavyImpact();
      Navigator.pop(this, result);
    } else {
      Navigator.pop(this, result);
    }
  }

  void navigateToCart({Object? arguments}) => Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.cartRoute,
        (route) => true,
        arguments: arguments,
      );

  void navigateToLogin({Object? arguments}) =>
      Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.loginRoute,
        (route) => false,
        arguments: arguments,
      );

  void navigateToRegister({Object? arguments}) =>
      Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.registerRoute,
        (route) => true,
        arguments: arguments,
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

  void navigateToGoogleMapViewAfterRegisterOrLogin() =>
      Navigator.pushReplacement(
        this,
        _defaultRoute(
          child: const GoogleMapView(
            fromLogin: true,
          ),
        ),
      );

  void navigateToSearchView({Object? arguments}) =>
      Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.searchRoute,
        (route) => true,
        arguments: arguments,
      );

  void navigateToSearchLocationWithAutoComplete({Object? arguments}) =>
      Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.searchLocationRoute,
        (route) => true,
        arguments: arguments,
      );

  void navigateToProfile({Object? arguments}) =>
      Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.profileRoute,
        (route) => true,
        arguments: arguments,
      );

  void navigateToOrdersView({Object? arguments}) =>
      Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.ordersRoute,
        (route) => true,
        arguments: arguments,
      );

  void navigateToOrderDetailsView(
    OrderId orderId, {
    GlobalKey<ScaffoldMessengerState>? scaffoldMessangerKey,
  }) =>
      Navigator.pushAndRemoveUntil(
        this,
        _defaultRoute(
          child: OrderDetailsView(
            orderId: orderId,
            scaffoldMessengerKey: scaffoldMessangerKey,
          ),
        ),
        (route) => true,
      );

  void navigateToFilteredRestaurants(
    List<Restaurant> filteredRestaurants,
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

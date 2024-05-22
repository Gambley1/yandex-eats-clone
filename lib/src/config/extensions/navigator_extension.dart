import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:page_transition/page_transition.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/components/order_details/order_details_view.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_bloc_test.dart';
import 'package:papa_burger/src/views/pages/main/components/location/google_map_view.dart';
import 'package:papa_burger/src/views/pages/main/components/menu/menu_view.dart';
import 'package:papa_burger/src/views/pages/main/components/restaurant/restaurants_filtered_view.dart';

Route<dynamic> _defaultRoute({
  required Widget child,
  PageTransitionType type = PageTransitionType.fade,
}) =>
    PageTransition(
      child: child,
      type: type,
    );

extension NavigatorExtension on BuildContext {
  void goToHome() {
    Navigator.pushNamedAndRemoveUntil(
      this,
      AppRoutes.main.route,
      (route) => false,
    );
  }

  void goToMenu(
    BuildContext context,
    Restaurant restaurant, {
    bool fromCart = false,
  }) {
    if (restaurant == const Restaurant.empty()) {
      context.goToHome();
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

  void pop({bool withHapticFeedback = false, dynamic result}) {
    if (withHapticFeedback) {
      HapticFeedback.heavyImpact();
      Navigator.pop(this, result);
    } else {
      Navigator.pop(this, result);
    }
  }

  void goToCart({Object? arguments}) => Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.cart.route,
        (route) => true,
        arguments: arguments,
      );

  void goToLogin({Object? arguments}) => Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.login.route,
        (route) => false,
        arguments: arguments,
      );

  void goToSignUp({Object? arguments}) => Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.signUp.route,
        (route) => true,
        arguments: arguments,
      );

  void goToGoogleMap([PlaceDetails? placeDetails]) =>
      Navigator.pushAndRemoveUntil(
        this,
        _defaultRoute(
          child: GoogleMapView(
            placeDetails: placeDetails,
          ),
        ),
        (route) => true,
      );

  void goToGoogleMapReplacement() => Navigator.pushReplacement(
        this,
        _defaultRoute(
          child: const GoogleMapView(
            fromLogin: true,
          ),
        ),
      );

  void goToSearch({Object? arguments}) => Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.search.route,
        (route) => true,
        arguments: arguments,
      );

  void goToSearchLocation({Object? arguments}) =>
      Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.searchLocation.route,
        (route) => true,
        arguments: arguments,
      );

  void goToProfile({Object? arguments}) => Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.profile.route,
        (route) => true,
        arguments: arguments,
      );

  void goToOrders({Object? arguments}) => Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.orders.route,
        (route) => true,
        arguments: arguments,
      );

  void goToNotifications({Object? arguments}) =>
      Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.notifications.route,
        (route) => true,
        arguments: arguments,
      );

  void goToOrderDetails(
    OrderId orderId, {
    GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
  }) =>
      Navigator.pushAndRemoveUntil(
        this,
        _defaultRoute(
          child: OrderDetailsView(
            orderId: orderId,
            scaffoldMessengerKey: scaffoldMessengerKey,
          ),
        ),
        (route) => true,
      );

  void goToFilteredRestaurants(
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

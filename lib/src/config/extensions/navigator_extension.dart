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
  void navigateToMainPage() {
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

  void pop({bool withHapticFeedback = false, dynamic result}) {
    if (withHapticFeedback) {
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

  void navigateToGoogleMapView([PlaceDetails? placeDetails]) =>
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

  void navigateToNotificationsView({Object? arguments}) =>
      Navigator.pushNamedAndRemoveUntil(
        this,
        AppRoutes.notificationsRoute,
        (route) => true,
        arguments: arguments,
      );

  void navigateToOrderDetailsView(
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

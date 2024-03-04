import 'package:flutter/material.dart' show BuildContext, Widget;
import 'package:papa_burger/src/config/config.dart';

class Routes {
  const Routes();

  static final Map<String, Widget Function(BuildContext context)> routes = {
    AppRoutes.homeRoute: (_) => AppRoutes.homePage,
    AppRoutes.mainRoute: (_) => AppRoutes.mainPage,
    AppRoutes.loginRoute: (_) => AppRoutes.loginPage,
    AppRoutes.registerRoute: (_) => AppRoutes.registerPage,
    AppRoutes.cartRoute: (_) => AppRoutes.cartPage,
    AppRoutes.profileRoute: (_) => AppRoutes.profilePage,
    AppRoutes.restaurantsRoute: (_) => AppRoutes.restaurantsPage,
    AppRoutes.searchLocationRoute: (_) => AppRoutes.searchLocationPage,
    AppRoutes.searchRoute: (_) => AppRoutes.searchPage,
    AppRoutes.ordersRoute: (_) => AppRoutes.ordersPage,
    AppRoutes.notificationsRoute: (_) => AppRoutes.notificationsPage,
  };
}

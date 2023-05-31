import 'package:flutter/material.dart' show BuildContext, Widget;
import 'package:papa_burger/src/restaurant.dart' show AppRoutes;

class Routes {
  const Routes();

  static final Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.homeRoute: (BuildContext context) => AppRoutes.homePage,
    AppRoutes.mainRoute: (BuildContext context) => AppRoutes.mainPage,
    AppRoutes.loginRoute: (BuildContext context) => AppRoutes.loginPage,
    AppRoutes.registerRoute: (BuildContext context) => AppRoutes.registerPage,
    AppRoutes.cartRoute: (BuildContext context) => AppRoutes.cartPage,
    AppRoutes.profileRoute: (BuildContext context) => AppRoutes.profilePage,
    AppRoutes.restaurantsRoute: (BuildContext context) =>
        AppRoutes.restaurantsPage,
    AppRoutes.searchLocationRoute: (BuildContext context) =>
        AppRoutes.searchLocationPage,
    AppRoutes.searchRoute: (BuildContext context) => AppRoutes.searchPage,
  };
}

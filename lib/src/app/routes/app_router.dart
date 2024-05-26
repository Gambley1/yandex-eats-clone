import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/cart/cart.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/home/home.dart';
import 'package:papa_burger/src/map/map.dart';
import 'package:papa_burger/src/orders/orders.dart';
import 'package:papa_burger/src/profile/profile.dart';
import 'package:papa_burger/src/restaurants/restaurants.dart';
import 'package:papa_burger/src/search/view/search_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  AppRouter();

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.restaurants.route,
    routes: [
      GoRoute(
        path: AppRoutes.cart.route,
        name: AppRoutes.cart.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CartView(),
      ),
      GoRoute(
        path: AppRoutes.profile.route,
        name: AppRoutes.profile.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: AppRoutes.googleMap.route,
        name: AppRoutes.googleMap.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const GoogleMapView(),
      ),
      GoRoute(
        path: AppRoutes.orders.route,
        name: AppRoutes.orders.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OrdersView(),
      ),
      GoRoute(
        path: AppRoutes.search.route,
        name: AppRoutes.search.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SearchView(),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) {
          return HomePage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.restaurants.route,
                name: AppRoutes.restaurants.name,
                builder: (context, state) => const RestaurantsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/go-to-cart',
                redirect: (context, state) => null,
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

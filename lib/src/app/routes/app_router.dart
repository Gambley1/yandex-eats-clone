import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/auth/auth.dart';
import 'package:yandex_food_delivery_clone/src/cart/cart.dart';
import 'package:yandex_food_delivery_clone/src/home/home.dart';
import 'package:yandex_food_delivery_clone/src/map/map.dart';
import 'package:yandex_food_delivery_clone/src/menu/menu.dart';
import 'package:yandex_food_delivery_clone/src/orders/order/order.dart';
import 'package:yandex_food_delivery_clone/src/orders/orders.dart';
import 'package:yandex_food_delivery_clone/src/profile/profile.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/restaurants.dart';
import 'package:yandex_food_delivery_clone/src/search/search.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  AppRouter();

  GoRouter router(AppBloc appBloc) => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: AppRoutes.restaurants.route,
        routes: [
          GoRoute(
            path: AppRoutes.auth.route,
            name: AppRoutes.auth.name,
            builder: (context, state) => const AuthPage(),
          ),
          GoRoute(
            path: AppRoutes.cart.route,
            name: AppRoutes.cart.name,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const CartPage(),
          ),
          GoRoute(
            path: AppRoutes.profile.route,
            name: AppRoutes.profile.name,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const ProfileView(),
            routes: [
              GoRoute(
                path: AppRoutes.updateEmail.name,
                name: AppRoutes.updateEmail.name,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const UserUpdateEmailForm(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.googleMap.route,
            name: AppRoutes.googleMap.name,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              final props = state.extra as GoogleMapProps?;
              return GoogleMapPage(props: props ?? const GoogleMapProps());
            },
          ),
          GoRoute(
            path: AppRoutes.orders.route,
            name: AppRoutes.orders.name,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const OrdersView(),
            routes: [
              GoRoute(
                path: '${AppRoutes.order.name}/:order_id',
                name: AppRoutes.order.name,
                builder: (context, state) => OrderPage(
                  orderId: state.pathParameters['order_id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.search.route,
            name: AppRoutes.search.name,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: AppRoutes.searchLocation.route,
            name: AppRoutes.searchLocation.name,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const SearchLocationAutoCompletePage(),
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
                    routes: [
                      GoRoute(
                        path: AppRoutes.menu.name,
                        name: AppRoutes.menu.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final props = state.extra! as MenuProps;
                          return MenuPage(props: props);
                        },
                      ),
                    ],
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
        redirect: (context, state) {
          final authenticated = appBloc.state.status == AppStatus.authenticated;
          final hasLocation = !appBloc.state.location.isUndefined;
          final authenticating = state.matchedLocation == AppRoutes.auth.route;
          final isInRestaurants =
              state.matchedLocation == AppRoutes.restaurants.route;

          if (isInRestaurants && !authenticated) return AppRoutes.auth.route;
          if (!authenticated) return AppRoutes.auth.route;
          if (!hasLocation && authenticating) return AppRoutes.googleMap.route;
          if (authenticating && authenticated) {
            return AppRoutes.restaurants.route;
          }

          return null;
        },
        refreshListenable: GoRouterAppBlocRefreshStream(appBloc.stream),
      );
}

/// {@template go_router_refresh_stream}
/// A [ChangeNotifier] that notifies listeners when a [Stream] emits a value.
/// This is used to rebuild the UI when the [AppBloc] emits a new state.
/// {@endtemplate}
class GoRouterAppBlocRefreshStream extends ChangeNotifier {
  /// {@macro go_router_refresh_stream}
  GoRouterAppBlocRefreshStream(Stream<AppState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((appState) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

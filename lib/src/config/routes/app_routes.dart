import 'package:flutter/material.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:papa_burger/src/views/pages/cart/cart_view.dart';
import 'package:papa_burger/src/views/pages/login/login.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/notifications/notifications_view.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/orders_view.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/profile/profile_view.dart';
import 'package:papa_burger/src/views/pages/main/components/location/google_map_view.dart';
import 'package:papa_burger/src/views/pages/main/components/location/search_location_with_autocomplete.dart';
import 'package:papa_burger/src/views/pages/main/components/search/search_view.dart';
import 'package:papa_burger/src/views/pages/main/main_page.dart';
import 'package:papa_burger/src/views/pages/restaurants/restaurants_view.dart';
import 'package:papa_burger/src/views/pages/sign_up/view/sign_up_view.dart';

enum AppRoutes {
  home,
  main,
  login,
  signUp,
  cart,
  profile,
  orders,
  notifications,
  restaurants,
  searchLocation,
  search;

  String get route => switch (this) {
        home => '/',
        main => '/main',
        login => '/login',
        signUp => '/sign_up',
        cart => '/cart',
        profile => '/profile',
        orders => '/orders',
        notifications => '/notificiations',
        restaurants => '/restaurants',
        searchLocation => '/search_location',
        search => '/search',
      };

  Widget get page => switch (this) {
        home => const HomeView(),
        main => const MainView(),
        login => const LoginView(),
        signUp => const SignUpView(),
        cart => const CartView(),
        profile => const ProfileView(),
        orders => const OrdersView(),
        notifications => const NotificationsView(),
        restaurants => const RestaurantsView(),
        searchLocation => const SearchLocationView(),
        search => const SearchView(),
      };

  static Map<String, Widget Function(BuildContext context)> get routes => {
        home.route: (_) => home.page,
        main.route: (_) => main.page,
        login.route: (_) => login.page,
        signUp.route: (_) => signUp.page,
        cart.route: (_) => cart.page,
        profile.route: (_) => profile.page,
        restaurants.route: (_) => restaurants.page,
        searchLocation.route: (_) => searchLocation.page,
        search.route: (_) => search.page,
        orders.route: (_) => orders.page,
        notifications.route: (_) => notifications.page,
      };
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = LocalStorage().getUser;
    final hasAddress = LocalStorage().hasAddress;
    if (user == null) {
      return const LoginView();
    }
    if (!hasAddress) {
      return const GoogleMapView();
    } else {
      return const MainView();
    }
  }
}

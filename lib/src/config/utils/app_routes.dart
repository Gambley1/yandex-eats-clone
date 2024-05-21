import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget;
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:papa_burger/src/views/pages/cart/cart_view.dart';
import 'package:papa_burger/src/views/pages/login/login_view.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/notifications/notifications_view.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/orders_view.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/profile/profile_view.dart';
import 'package:papa_burger/src/views/pages/main/components/location/google_map_view.dart';
import 'package:papa_burger/src/views/pages/main/components/location/search_location_with_autocomplete.dart';
import 'package:papa_burger/src/views/pages/main/components/search/search_view.dart';
import 'package:papa_burger/src/views/pages/main/main_page.dart';
import 'package:papa_burger/src/views/pages/register/register_view.dart';
import 'package:papa_burger/src/views/pages/restaurants/restaurant_view.dart';

class AppRoutes {
  static const homeRoute = '/';
  static const mainRoute = '/main';
  static const loginRoute = '/login';
  static const registerRoute = '/register';
  static const cartRoute = '/cart';
  static const profileRoute = '/profile';
  static const ordersRoute = '/orders';
  static const notificationsRoute = '/notifications';
  static const restaurantsRoute = '/restaurants';
  static const searchLocationRoute = '/search_location';
  static const searchRoute = '/search';

  static HomePage homePage = const HomePage();
  static const mainPage = MainPage();
  static const loginPage = LoginView();
  static const cartPage = CartView();
  static const profilePage = ProfileView();
  static const restaurantsPage = RestaurantView();
  static const searchLocationPage = SearchLocationWithAutoComplete();
  static const searchPage = SearchView();
  static const registerPage = RegisterView();
  static const notificationsPage = NotificationsView();
  static final ordersPage = OrdersView();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      return const MainPage();
    }
  }
}

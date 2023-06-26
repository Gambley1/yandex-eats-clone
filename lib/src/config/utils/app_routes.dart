import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget;
import 'package:papa_burger/src/restaurant.dart'
    show
        GoogleMapView,
        LocalStorage,
        LoginView,
        MainPage,
        RegisterView,
        RestaurantView,
        SearchLocationWithAutoComplete,
        SearchView;
import 'package:papa_burger/src/views/pages/cart/cart_view.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/notifications/components/custom_refresh_indicator.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/orders_view.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/profile/profile_view.dart';

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

  static HomePage homePage = HomePage();
  static const mainPage = MainPage();
  static const loginPage = LoginView();
  static const cartPage = CartView();
  static const profilePage = ProfileView();
  static const restaurantsPage = RestaurantView();
  static const searchLocationPage = SearchLocationWithAutoComplete();
  static const searchPage = SearchView();
  static const registerPage = RegisterView();
  static const notificationsPage = CustomRefreshIndicator();
  static OrdersVieww ordersPage = OrdersVieww();
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final localStorage = LocalStorage.instance;
  late final user = localStorage.getUser;
  late final hasAddress = localStorage.hasAddress;

  @override
  Widget build(BuildContext context) {
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

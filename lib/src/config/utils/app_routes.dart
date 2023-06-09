import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget;
import 'package:papa_burger/src/restaurant.dart'
    show
        LocalStorage,
        LoginView,
        MainPage,
        RegisterView,
        RestaurantView,
        SearchLocationWithAutoComplete,
        SearchView;
import 'package:papa_burger/src/views/pages/cart/test_cart_view.dart';
import 'package:papa_burger/src/views/pages/main_page/components/drawer/views/orders/orders_view.dart';
import 'package:papa_burger/src/views/pages/main_page/components/drawer/views/profile/profile_view.dart';

class AppRoutes {
  static const homeRoute = '/';
  static const mainRoute = '/main';
  static const loginRoute = '/login';
  static const registerRoute = '/register';
  static const cartRoute = '/cart';
  static const profileRoute = '/profile';
  static const ordersRoute = '/orders';
  static const restaurantsRoute = '/restaurants';
  static const searchLocationRoute = '/search_location';
  static const searchRoute = '/search';

  static HomePage homePage = HomePage();
  static MainPage mainPage = MainPage();
  static const loginPage = LoginView();
  static final cartPage = TestCartView();
  static const profilePage = ProfileView();
  static const restaurantsPage = RestaurantView();
  static const searchLocationPage = SearchLocationWithAutoComplete();
  static const searchPage = SearchView();
  static const registerPage = RegisterView();
  static OrdersVieww ordersPage = OrdersVieww();
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final localStorage = LocalStorage.instance;
  late final user = localStorage.getUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const LoginView();
    }
    return MainPage();
    // return StreamBuilder<User?>(
    //   stream: LocalStorage.instance.userFromDB,
    //   builder: (context, snapshot) {
    //     final user = snapshot.data;
    //     return user != null ? const MainPage() : const LoginView();
    //   },
    // );
    // return StreamBuilder<User?>(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (context, snapshot) {
    //     final user = snapshot.data;
    //     return user != null ? const MainPage() : const LoginView();
    //   },
    // );
  }
}

import 'package:firebase_auth/firebase_auth.dart' show User, FirebaseAuth;
import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, StreamBuilder, Widget;
import 'package:papa_burger/src/restaurant.dart'
    show
        LoginView,
        MainPage,
        RestaurantView,
        SearchLocationWithAutoComplete,
        SearchView;
import 'package:papa_burger/src/views/pages/main_page/components/drawer/views/profile/profile_view.dart';

import '../../views/pages/cart/test_cart_view.dart';

class AppRoutes {
  static const homeRoute = '/';
  static const mainRoute = '/main';
  static const loginRoute = '/login';
  static const cartRoute = '/cart';
  static const profileRoute = '/profile';
  static const restaurantsRoute = '/restaurants';
  static const searchLocationRoute = '/search_location';
  static const searchRoute = '/search';

  static const homePage = HomePage();
  static const mainPage = MainPage();
  static const loginPage = LoginView();
  static final cartPage = TestCartView();
  static const profilePage = ProfileView();
  static const restaurantsPage = RestaurantView();
  static const searchLocationPage = SearchLocationWithAutoComplete();
  static const searchPage = SearchView();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return snapshot.data != null ? const MainPage() : const LoginView();
      },
    );
  }
}

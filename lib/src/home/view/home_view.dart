import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_food_delivery_clone/src/drawer/drawer.dart';
import 'package:yandex_food_delivery_clone/src/home/home.dart';
import 'package:yandex_food_delivery_clone/src/navigation/navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return HomeView(navigationShell: navigationShell);
  }
}

class HomeView extends StatefulWidget {
  const HomeView({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    HomeConfig().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      releaseFocus: true,
      drawer: const DrawerView(),
      bottomNavigationBar:
          BottomNavBar(navigationShell: widget.navigationShell),
      body: widget.navigationShell,
    );
  }
}

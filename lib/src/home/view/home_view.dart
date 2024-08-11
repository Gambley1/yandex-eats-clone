import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_food_delivery_clone/src/drawer/drawer.dart';
import 'package:yandex_food_delivery_clone/src/navigation/navigation.dart';

class HomeView extends StatelessWidget {
  const HomeView({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      releaseFocus: true,
      drawer: const DrawerView(),
      bottomNavigationBar: BottomNavBar(navigationShell: navigationShell),
      body: navigationShell,
    );
  }
}

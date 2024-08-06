import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final navigationBarItems = mainNavigationBarItems(
      homeLabel: 'Home',
      cartLabel: 'Cart',
    );

    return BottomNavigationBar(
      iconSize: AppSize.xlg,
      currentIndex: navigationShell.currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: context.theme.colorScheme.primary,
      onTap: (index) {
        if (index != 1) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        } else {
          context.pushNamed(AppRoutes.cart.name);
        }
      },
      items: navigationBarItems
          .map(
            (item) => BottomNavigationBarItem(
              icon: item.child ?? Icon(item.icon),
              label: item.label,
              tooltip: item.tooltip,
            ),
          )
          .toList(),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  void _drawerOptionAction(
    BuildContext context,
    DrawerOption name,
  ) =>
      switch (name) {
        DrawerOption.orders => context.pushNamed(AppRoutes.orders.name),
        DrawerOption.profile => context.pushNamed(AppRoutes.profile.name),
      };

  IconData _drawerOptionIcon(DrawerOption name) => switch (name) {
        DrawerOption.profile => LucideIcons.user,
        DrawerOption.orders => LucideIcons.shoppingCart,
      };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      width: context.screenWidth * 0.7,
      child: ListView(
        children: [
          DrawerHeader(
            child: Row(
              children: [
                Text('Yandex', style: context.headlineMedium),
                Assets.images.papaBurgerLogo.image(height: 60, width: 60),
                Text('Food', style: context.headlineMedium),
              ],
            ),
          ),
          ...DrawerOption.values.map(
            (option) => ListTile(
              horizontalTitleGap: AppSpacing.sm,
              onTap: () {
                Scaffold.of(context).closeDrawer();
                _drawerOptionAction(context, option);
              },
              leading: AppIcon(icon: _drawerOptionIcon(option)),
              title: Text(option.name),
            ),
          ),
        ],
      ),
    );
  }
}

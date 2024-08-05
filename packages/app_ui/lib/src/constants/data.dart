/// The list of options shown in drawer.
// ignore_for_file: public_member_api_docs

library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

const headerPhoto =
    'https://i.postimg.cc/TYmTcNQx/Whats-App-Image-2023-05-31-at-18-33-47.jpg';
const fakeStreet = 'Olive Street 54/12';

const googleApiKey = '';

const noLocation = 'Pick location';
const searchFoodLabel = 'Search food...';
const quickSearchLabel = 'Quick Search';
const searchLocationLabel = 'Search';

enum DrawerOption {
  profile('Profile'),
  orders('Orders');

  const DrawerOption(this.name);

  final String name;
}

/// Navigation bar items
List<NavBarItem> mainNavigationBarItems({
  required String homeLabel,
  required String cartLabel,
}) =>
    <NavBarItem>[
      NavBarItem(icon: LucideIcons.chefHat, label: homeLabel),
      NavBarItem(icon: LucideIcons.shoppingCart, label: cartLabel),
    ];

class NavBarItem {
  NavBarItem({
    this.icon,
    this.label,
    this.child,
  });

  final String? label;
  final Widget? child;
  final IconData? icon;

  String? get tooltip => label;
}

SnackBar customSnackBar(
  String text, {
  String? solution,
  bool dismissible = true,
  Color color = AppColors.white,
  Duration duration = const Duration(seconds: 4),
  SnackBarBehavior? behavior,
  SnackBarAction? snackBarAction,
  DismissDirection dismissDirection = DismissDirection.down,
}) {
  return SnackBar(
    dismissDirection: dismissible ? dismissDirection : DismissDirection.none,
    action: snackBarAction,
    duration: duration,
    behavior: behavior ?? SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.xs),
    ),
    margin: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
    content: solution == null
        ? Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: color),
          )
        : Column(
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: color),
              ),
              Text(
                solution,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: AppColors.brightGrey, fontSize: 14),
              ),
            ],
          ),
  );
}

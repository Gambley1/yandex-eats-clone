import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_bottom_bar}
/// The reusable bottom bar of the application.
/// {@endtemplate}
class AppBottomBar extends StatelessWidget {
  /// {@macro app_bottom_bar}
  const AppBottomBar({required this.children, super.key});

  /// The list of children of the bottom bar.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.brightGrey,
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_bottom_bar}
/// The reusable bottom bar of the application.
/// {@endtemplate}
class AppBottomBar extends StatelessWidget {
  /// {@macro app_bottom_bar}
  const AppBottomBar({
    required this.children,
    this.color,
    this.padding,
    this.borderRadius,
    super.key,
  });

  /// The list of children of the bottom bar.
  final List<Widget> children;

  /// The color of the bottom bar.
  final Color? color;

  /// The padding of the bottom bar.
  final EdgeInsetsGeometry? padding;

  /// The border radius of the bottom bar.
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final babTheme = BottomAppBarTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.theme.canvasColor,
        boxShadow: [
          BoxShadow(
            color: context.customReversedAdaptiveColor(
              dark: AppColors.background,
              light: AppColors.brightGrey,
            ),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
        borderRadius: borderRadius,
      ),
      child: SafeArea(
        child: Padding(
          padding: padding ??
              babTheme.padding ??
              const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.lg,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

enum _IconVariant { button, icon }

class AppIcon extends StatelessWidget {
  const AppIcon({
    required this.icon,
    super.key,
    this.color = AppColors.black,
    this.iconSize = AppSize.sm,
    this.enableFeedback = true,
  })  : _variant = _IconVariant.icon,
        onTap = null,
        effect = null;

  const AppIcon.button({
    required this.icon,
    required this.onTap,
    this.effect,
    super.key,
    this.color = AppColors.black,
    this.iconSize = AppSize.md,
    this.enableFeedback = true,
  }) : _variant = _IconVariant.button;

  final IconData icon;
  final double iconSize;
  final Color color;
  final bool enableFeedback;
  final VoidCallback? onTap;
  final _IconVariant? _variant;
  final TappableVariant? effect;

  @override
  Widget build(BuildContext context) {
    if (_variant == _IconVariant.button) {
      return Tappable.raw(
        onTap: onTap,
        variant: effect ?? TappableVariant.faded,
        enableFeedback: enableFeedback,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Icon(
            icon,
            size: iconSize,
            color: color,
          ),
        ),
      );
    }
    return Icon(color: color, icon, size: iconSize);
  }
}

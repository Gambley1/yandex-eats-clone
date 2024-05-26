// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

enum IconType { button, icon }

class AppIcon extends StatelessWidget {
  const AppIcon({
    required this.icon,
    this.type = IconType.icon,
    super.key,
    this.color = Colors.black,
    this.splashRadius = 18,
    this.onPressed,
    this.size = 22,
    this.splashColor,
    this.highlightColor,
    this.enableFeedback,
  });

  final double splashRadius;
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color color;
  final Color? splashColor;
  final Color? highlightColor;
  final IconType? type;
  final bool? enableFeedback;

  @override
  Widget build(BuildContext context) {
    return type == IconType.button
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPressed ?? () {},
            child: IconButton(
              splashColor: splashColor,
              splashRadius: splashRadius,
              highlightColor: highlightColor,
              enableFeedback: enableFeedback,
              onPressed: onPressed ?? () {},
              icon: Icon(
                icon,
                size: size,
                color: color,
              ),
            ),
          )
        : type == IconType.icon
            ? Icon(
                color: color,
                icon,
                size: size,
              )
            : Container();
  }
}

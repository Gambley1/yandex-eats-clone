import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FaIcon;

enum IconType {
  iconButton,
  simpleIcon,
}

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    required this.icon,
    required IconType type,
    super.key,
    this.color = Colors.black,
    this.splashRadius = 18,
    this.onPressed,
    this.size = 22,
    this.splashColor,
    this.highlightColor,
    this.enableFeedback,
  }) : _type = type;

  final double splashRadius;
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color color;
  final Color? splashColor;
  final Color? highlightColor;
  final IconType? _type;
  final bool? enableFeedback;

  @override
  Widget build(BuildContext context) {
    return _type == IconType.iconButton
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPressed ?? () {},
            child: IconButton(
              splashColor: splashColor,
              splashRadius: splashRadius,
              highlightColor: highlightColor,
              enableFeedback: enableFeedback,
              onPressed: onPressed ?? () {},
              icon: FaIcon(
                icon,
                size: size,
                color: color,
              ),
            ),
          )
        : _type == IconType.simpleIcon
            ? FaIcon(
                color: color,
                icon,
                size: size,
              )
            : Container();
  }
}

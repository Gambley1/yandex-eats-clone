import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum IconType {
  iconButton,
  simpleIcon,
}

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    required this.icon,
    this.color = Colors.black,
    this.splashRadius = 18,
    this.onPressed,
    this.size = 22,
    required IconType type,
  }) : _type = type;

  final double splashRadius;
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color color;
  final IconType? _type;

  @override
  Widget build(BuildContext context) {
    return _type == IconType.iconButton
        ? IconButton(
            splashRadius: splashRadius,
            onPressed: onPressed ?? () {},
            icon: FaIcon(
              icon,
              size: size,
              color: color,
              textDirection: TextDirection.rtl,
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

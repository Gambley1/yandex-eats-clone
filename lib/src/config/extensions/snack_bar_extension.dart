import 'package:flutter/material.dart'
    show BuildContext, Color, Colors, ScaffoldMessenger, SnackBar;
import 'package:papa_burger/src/restaurant.dart' show KText;

extension SnackBarExtension on BuildContext {
  void showSnackBar(String text, {Color color = Colors.white}) =>
      ScaffoldMessenger.of(this)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: KText(
              text: text,
              color: color,
            ),
          ),
        );
}

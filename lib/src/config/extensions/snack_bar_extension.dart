import 'package:flutter/material.dart'
    show
        BorderRadius,
        BuildContext,
        Color,
        Colors,
        Column,
        DismissDirection,
        EdgeInsets,
        RoundedRectangleBorder,
        ScaffoldMessenger,
        SnackBar,
        SnackBarAction,
        SnackBarBehavior;
import 'package:papa_burger/src/views/widgets/custom_snack_bar.dart';

extension SnackBarExtension on BuildContext {
  void showSnackBar(
    String text, {
    bool dismissible = true,
    Color color = Colors.white,
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior? behavior,
    SnackBarAction? snackBarAction,
    String? solution,
    DismissDirection dismissDirection = DismissDirection.down,
  }) =>
      ScaffoldMessenger.of(this)
        ..clearSnackBars()
        ..showSnackBar(
          customSnackBar(
            text,
            behavior: behavior,
            color: color,
            dismissDirection: dismissDirection,
            dismissible: dismissible,
            duration: duration,
            snackBarAction: snackBarAction,
            solution: solution,
          ),
        );

  void closeSnackBars() {
    ScaffoldMessenger.of(this).clearSnackBars();
  }
}

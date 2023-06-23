import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        KText,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding,
        kDefaultVerticalPadding;

SnackBar customSnackBar(
  String text, {
  String? solution,
  bool dismissible = true,
  Color color = Colors.white,
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
      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
    ),
    margin: const EdgeInsets.symmetric(
      horizontal: kDefaultHorizontalPadding,
      vertical: kDefaultVerticalPadding,
    ),
    content: solution == null
        ? KText(
            text: text,
            textAlign: TextAlign.center,
            color: color,
          )
        : Column(
            children: [
              KText(
                text: text,
                textAlign: TextAlign.center,
                color: color,
              ),
              KText(
                text: solution,
                textAlign: TextAlign.center,
                color: Colors.grey.shade300,
                size: 14,
              ),
            ],
          ),
  );
}

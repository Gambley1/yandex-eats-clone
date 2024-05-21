import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:papa_burger/src/config/config.dart';

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

import 'package:flutter/material.dart'
    show AppBarTheme, Brightness, Colors, ThemeData;
import 'package:papa_burger/src/restaurant.dart' show kPrimaryColor;

class AppTheme {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      color: Colors.white,
    ),
    brightness: Brightness.light,
    primaryColor: kPrimaryColor,
  );
}

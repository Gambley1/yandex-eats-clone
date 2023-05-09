import 'package:flutter/material.dart'
    show AppBarTheme, Brightness, Colors, ThemeData;

class AppTheme {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(elevation: 0),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black.withOpacity(.7),
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
  );
}

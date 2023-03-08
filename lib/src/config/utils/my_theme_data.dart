import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyThemeData {
  static const SystemUiOverlayStyle globalThemeData = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  static const SystemUiOverlayStyle restaurantViewThemeData =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle restaurantHeaderThemeData =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.black45,
  );
  static const SystemUiOverlayStyle cartViewThemeData = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle googleMapView = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static setGlobalThemeSettings() {
    SystemChrome.setSystemUIOverlayStyle(MyThemeData.globalThemeData);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}

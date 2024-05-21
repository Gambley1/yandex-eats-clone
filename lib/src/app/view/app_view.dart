import 'package:flutter/material.dart';
import 'package:papa_burger/src/config/config.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Papa Burger',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routes: Routes.routes,
    );
  }
}

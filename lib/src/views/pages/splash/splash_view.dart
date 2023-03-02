import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart';

class SplashView extends StatelessWidget {
  const SplashView({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const KText(
          text: 'Splash screen',
        ),
      ),
    );
  }
}

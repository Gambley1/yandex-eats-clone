import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart' show loginLogo;

class LoginImage extends StatelessWidget {
  const LoginImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 332,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            loginLogo,
          ),
        ),
      ),
    );
  }
}

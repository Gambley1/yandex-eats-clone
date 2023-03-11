import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart' show loginLogo;


class LoginImage extends StatelessWidget {
  const LoginImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      loginLogo,
    );
  }
}

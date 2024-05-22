import 'package:flutter/material.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginImage extends StatelessWidget {
  const LoginImage({super.key});

  @override
  Widget build(BuildContext context) {
    const size = 324.0;

    return const ShadImage.square(
      loginLogo,
      size: size,
      placeholder: SizedBox(height: size),
    );
  }
}

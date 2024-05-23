import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({super.key});

  @override
  Widget build(BuildContext context) {
    const size = 324.0;

    return Assets.images.welcome.image(height: size, cacheHeight: size.toInt());
  }
}

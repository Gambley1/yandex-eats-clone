import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart' show KText;

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: const KText(
          text: 'Forgot password?',
          fontWeight: FontWeight.bold,
        ),
        onPressed: () {},
      ),
    );
  }
}

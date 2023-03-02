import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        clipBehavior: Clip.none,
        child: const KText(
          text: 'Forgot password?',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        onPressed: () {},
      ),
    );
  }
}

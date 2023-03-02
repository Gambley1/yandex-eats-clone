import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const KText(
          text: 'Don\'t have an account? ',
          textOverflow: TextOverflow.ellipsis,
          color: Colors.black54,
        ),
        GestureDetector(
          onTap: () {},
          child: const KText(
            text: 'Sign up',
            textOverflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

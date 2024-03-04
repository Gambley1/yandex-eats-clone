import 'package:flutter/material.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({
    required this.text,
    required this.onTap,
    super.key,
  });

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const KText(
          text: "Don't have an account? ",
          color: Colors.black54,
        ),
        GestureDetector(
          onTap: onTap,
          child: KText(
            text: text,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

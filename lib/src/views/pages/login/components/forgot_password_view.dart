import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text(
          'Forgot password?',
          style: context.bodyMedium?.copyWith(fontWeight: AppFontWeight.bold),
        ),
        onPressed: () {},
      ),
    );
  }
}

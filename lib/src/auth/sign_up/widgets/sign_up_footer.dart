import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({
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
        const Text('Already have an account? '),
        Tappable.faded(
          onTap: onTap,
          child: Text(
            text,
            style: context.bodyMedium?.copyWith(fontWeight: AppFontWeight.bold),
          ),
        ),
      ],
    );
  }
}

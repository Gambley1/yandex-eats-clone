import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({this.onTryAgain, super.key});

  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    return AppInfoSection(
      info: 'Something went wrong!',
      onPressed: onTryAgain,
      buttonLabel: 'Try again',
      icon: LucideIcons.refreshCcw,
    );
  }
}

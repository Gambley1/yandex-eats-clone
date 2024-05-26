// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    required this.content,
    super.key,
    this.title,
  });

  final String? title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.md + AppSpacing.xs),
          topRight: Radius.circular(AppSpacing.md + AppSpacing.xs),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title == null)
              const SizedBox.shrink()
            else
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xlg,
                  vertical: AppSpacing.lg + AppSpacing.xs,
                ),
                child: Text(
                  title!,
                  style: context.headlineSmall
                      ?.copyWith(fontWeight: AppFontWeight.semiBold),
                ),
              ),
            content,
          ],
        ),
      ),
    );
  }
}

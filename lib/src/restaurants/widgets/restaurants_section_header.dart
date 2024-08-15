import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class RestaurantsSectionHeader extends StatelessWidget {
  const RestaurantsSectionHeader({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.lg,
        ),
        child: Text(
          text,
          style:
              context.headlineMedium?.copyWith(fontWeight: AppFontWeight.bold),
        ),
      ),
    );
  }
}

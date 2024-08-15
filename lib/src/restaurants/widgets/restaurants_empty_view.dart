import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class RestaurantsEmptyView extends StatelessWidget {
  const RestaurantsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverFillRemaining(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'We are not here yet :(',
              textAlign: TextAlign.center,
              style: context.titleLarge
                  ?.copyWith(fontWeight: AppFontWeight.semiBold),
            ),
            Text(
              'But we connect dozens of new places every week. '
              "Maybe we'll be here!",
              textAlign: TextAlign.center,
              style: context.bodyMedium?.apply(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

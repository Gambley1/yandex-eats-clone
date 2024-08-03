// ignore_for_file: lines_longer_than_80_chars

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class RestaurantsTimeoutView extends StatelessWidget {
  const RestaurantsTimeoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 24),
      sliver: SliverFillRemaining(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'The client ran out of time :(',
              textAlign: TextAlign.center,
              style: context.titleLarge
                  ?.copyWith(fontWeight: AppFontWeight.semiBold),
            ),
            Text(
              'Please try again later and check your internet connection!',
              textAlign: TextAlign.center,
              style: context.bodyMedium?.apply(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: lines_longer_than_80_chars

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class RestaurantsNoInternetView extends StatelessWidget {
  const RestaurantsNoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xlg),
              child: ShimmerLoading(
                height: 160,
                radius: AppSpacing.md + AppSpacing.sm,
                width: double.infinity,
              ),
            );
          },
          childCount: 5,
        ),
      ),
    );
  }
}

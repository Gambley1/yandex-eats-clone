import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class RestaurantsLoadingView extends StatelessWidget {
  const RestaurantsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverPadding(
      padding: EdgeInsets.only(top: AppSpacing.xxlg),
      sliver: SliverFillRemaining(
        hasScrollBody: false,
        child: AppCircularProgressIndicator.adaptive(),
      ),
    );
  }
}

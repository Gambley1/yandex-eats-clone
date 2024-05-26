import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:papa_burger/src/home/widgets/header_view.dart';
import 'package:papa_burger/src/search/widgets/search_bar.dart';

class RestaurantsAppBar extends StatelessWidget {
  const RestaurantsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      excludeHeaderSemantics: true,
      scrolledUnderElevation: 12,
      floating: true,
      collapsedHeight: 133,
      flexibleSpace: Column(
        children: [
          SizedBox(
            height: AppSpacing.md,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            child: HeaderView(),
          ),
          SizedBox(height: AppSpacing.lg),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: AppSearchBar(enabled: false),
          ),
        ],
      ),
    );
  }
}

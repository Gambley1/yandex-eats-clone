import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart' show KText;

class MenuSectionHeader extends StatelessWidget {
  const MenuSectionHeader({
    required this.categoryName,
    required this.isSectionEmpty,
    required this.categoryHeight,
    super.key,
  });

  final String categoryName;
  final bool isSectionEmpty;
  final double categoryHeight;

  @override
  Widget build(BuildContext context) {
    return isSectionEmpty
        ? const SliverToBoxAdapter()
        : SliverPadding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 12,
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.centerLeft,
                height: categoryHeight,
                child: KText(
                  text: categoryName,
                  size: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
  }
}

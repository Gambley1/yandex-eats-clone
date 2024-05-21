import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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
                child: Text(
                  categoryName,
                  style: context.headlineMedium
                      ?.copyWith(fontWeight: AppFontWeight.bold),
                ),
              ),
            ),
          );
  }
}

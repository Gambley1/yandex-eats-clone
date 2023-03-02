import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart';

class MenuSectionHeader extends StatelessWidget {
  const MenuSectionHeader(
      {super.key, required this.categorieName, required this.isSectionEmpty});

  final String categorieName;
  final bool isSectionEmpty;

  @override
  Widget build(BuildContext context) {
    return isSectionEmpty
        ? const SliverToBoxAdapter(
            child: null,
          )
        : SliverPadding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 12,
            ),
            sliver: SliverToBoxAdapter(
              child: KText(
                text: categorieName,
                size: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}

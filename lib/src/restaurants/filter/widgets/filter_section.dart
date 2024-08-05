import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            title,
            style: context.headlineSmall,
          ),
        ),
        ...children,
      ],
    );
  }
}

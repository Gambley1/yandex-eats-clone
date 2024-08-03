import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class FilterSection extends StatelessWidget {
  const FilterSection.top({
    required this.title,
    required this.children,
    super.key,
  })  : borderTop = false,
        borderBottom = true;

  const FilterSection.bottom({
    required this.title,
    required this.children,
    super.key,
  })  : borderTop = true,
        borderBottom = false;

  const FilterSection.middle({
    required this.title,
    required this.children,
    super.key,
  })  : borderTop = true,
        borderBottom = true;

  final String title;
  final List<Widget> children;
  final bool borderTop;
  final bool borderBottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            title,
            style:
                context.headlineSmall?.copyWith(fontWeight: AppFontWeight.bold),
          ),
        ),
        ...children,
      ],
    );
  }
}

class SeparatedContainer extends StatelessWidget {
  const SeparatedContainer({
    required this.child,
    this.onlyTop = false,
    this.onlyBottom = true,
    super.key,
  });

  final Widget child;
  final bool onlyTop;
  final bool onlyBottom;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = onlyBottom && onlyTop
        ? BorderRadius.circular(AppSpacing.xlg)
        : onlyBottom
            ? const BorderRadius.vertical(
                bottom: Radius.circular(AppSpacing.xlg),
              )
            : const BorderRadius.vertical(top: Radius.circular(AppSpacing.xlg));
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: effectiveBorderRadius,
      ),
      child: child,
    );
  }
}

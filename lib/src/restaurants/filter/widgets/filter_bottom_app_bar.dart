import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class FilterBottomAppBar extends StatelessWidget {
  const FilterBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: InkWell(
              borderRadius:
                  BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
              onTap: () {},
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md + 6,
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
                  color: AppColors.indigo,
                ),
                child: Align(
                  child: Text(
                    'Apply',
                    style: context.titleLarge
                        ?.copyWith(fontWeight: AppFontWeight.semiBold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

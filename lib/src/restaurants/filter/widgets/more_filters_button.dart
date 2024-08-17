import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/filter/filter.dart';

class MoreFiltersButton extends StatelessWidget {
  const MoreFiltersButton({super.key});

  void _onTap(BuildContext context) {
    Future<void> showFilterModal() => context.showScrollableModal(
          pageBuilder: (scrollController, draggableScrollController) =>
              FilterModalView(
            scrollController: scrollController,
          ),
        );
    Future<void>.delayed(200.ms, showFilterModal);
  }

  @override
  Widget build(BuildContext context) {
    return Tappable.scaled(
      onTap: () => _onTap(context),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: AppColors.brightGrey,
              borderRadius:
                  BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
            ),
            child: const Icon(
              LucideIcons.arrowRight,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text('More'),
        ],
      ),
    );
  }
}

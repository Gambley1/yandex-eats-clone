import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/restaurants.dart';

class ResetFiltersButton extends StatelessWidget {
  const ResetFiltersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      borderRadius: AppSpacing.xlg - AppSpacing.xs,
      backgroundColor: AppColors.brightGrey,
      onTap: () {
        context
            .read<RestaurantsBloc>()
            .add(const RestaurantsFilterTagsClearRequested());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xlg,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          'Reset',
          style: context.bodyLarge,
        ),
      ),
    );
  }
}

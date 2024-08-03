import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location_repository/location_repository.dart';
import 'package:shared/shared.dart';
import 'package:yandex_food_delivery_clone/src/map/map.dart';

class AutoCompletesListView extends StatelessWidget {
  const AutoCompletesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final autoCompletes =
        context.select((AutoCompleteBloc bloc) => bloc.state.autoCompletes);
    final isPopulated = context
        .select((AutoCompleteBloc bloc) => bloc.state.status.isPopulated);

    if (autoCompletes.isEmpty && isPopulated) {
      return Text(
        'No results by your search term.',
        style: context.titleLarge,
      );
    }

    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          final result = autoCompletes[index];
          final mainText = result.structuredFormatting?.mainText;
          final secondaryText = result.structuredFormatting?.secondaryText;

          final placeId = result.placeId;
          return Tappable.faded(
            onTap: () async {
              void goBack(PlaceDetails? placeDetails) =>
                  context.pop(placeDetails);
              final placeDetails = await context
                  .read<LocationRepository>()
                  .getPlaceDetails(placeId);
              goBack(placeDetails);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mainText ?? '',
                    style: context.bodyLarge,
                  ),
                  Text(
                    secondaryText ?? '',
                    maxLines: 1,
                    style: context.bodyMedium?.apply(color: AppColors.grey),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: autoCompletes.length,
      ),
    );
  }
}

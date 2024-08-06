import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared/shared.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/map/map.dart';

class GoogleMapSaveLocationButton extends StatelessWidget {
  const GoogleMapSaveLocationButton({super.key});

  Future<void> _goToSearchLocationPage(BuildContext context) async {
    void animateToPlaceDetails(PlaceDetails placeDetails) =>
        context.read<MapBloc>().add(
              MapAnimateToPlaceDetails(
                placeDetails: placeDetails,
              ),
            );
    final placeDetails =
        await context.pushNamed(AppRoutes.searchLocation.name) as PlaceDetails?;
    if (placeDetails != null) {
      animateToPlaceDetails(placeDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 40,
      right: 80,
      bottom: AppSpacing.xxlg + AppSpacing.md,
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          final isCamerMoving = state.isCameraMoving;
          final isAddressFetchingFailure =
              state.status.isAddressFetchingFailure;

          return AnimatedOpacity(
            opacity: isCamerMoving ? 0 : 1,
            duration: const Duration(milliseconds: 150),
            child: ShadButton(
              text: Text(isAddressFetchingFailure ? 'Clarify address' : 'Save'),
              width: double.infinity,
              onPressed: isAddressFetchingFailure
                  ? () async => _goToSearchLocationPage(context)
                  : () {
                      context
                          .read<MapBloc>()
                          .add(const MapPositionSaveRequested());
                      context.goNamed(AppRoutes.restaurants.name);
                    },
              shadows: const [BoxShadowEffect.defaultValue],
            ),
          );
        },
      ),
    );
  }
}

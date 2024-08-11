import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location_repository/location_repository.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/map/map.dart';

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

class GoogleMapAddressView extends StatelessWidget {
  const GoogleMapAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.xxxlg * 2,
      right: 0,
      left: 0,
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          final isCameraMoving = state.isCameraMoving;
          final isAddressFetching = state.status.isAddressFetchingLoading;
          final isFailure = state.status.isAddressFetchingFailure;

          if (isCameraMoving) return const GoogleAddressLoading();
          if (isAddressFetching) {
            return GoogleAddressLoading(showLoadingIndicator: !isCameraMoving);
          }
          if (isFailure) return const GoogleAddressError();
          return const GoogleAddressName();
        },
      ),
    );
  }
}

class GoogleAddressName extends StatelessWidget {
  const GoogleAddressName({super.key});

  @override
  Widget build(BuildContext context) {
    final addressName =
        context.select((MapBloc bloc) => bloc.state.addressName);
    final isCameraMoving =
        context.select((MapBloc bloc) => bloc.state.isCameraMoving);

    return Tappable(
      onTap: () async => _goToSearchLocationPage(context),
      child: AnimatedOpacity(
        opacity: isCameraMoving ? 0 : 1,
        duration: const Duration(milliseconds: 150),
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxxlg,
          ),
          child: Column(
            children: [
              Text(
                addressName,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: context.headlineLarge?.copyWith(
                  fontWeight: AppFontWeight.semiBold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(
                height: AppSpacing.xlg,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: isCameraMoving ? 0 : 1,
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xxs,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.xlg),
                  ),
                  child: Text(
                    'Change delivery address',
                    maxLines: 1,
                    style: context.bodyMedium?.apply(color: AppColors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleAddressError extends StatelessWidget {
  const GoogleAddressError({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: () async => _goToSearchLocationPage(context),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 60,
        ),
        child: Text(
          "We don't take it here",
          textAlign: TextAlign.center,
          style: context.headlineMedium?.apply(color: AppColors.black),
        ),
      ),
    );
  }
}

class GoogleAddressLoading extends StatelessWidget {
  const GoogleAddressLoading({super.key, this.showLoadingIndicator = false});

  final bool showLoadingIndicator;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: () async => _goToSearchLocationPage(context),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 60,
        ),
        child: Column(
          children: [
            Text(
              'Finding you...',
              style: context.headlineMedium?.apply(
                color: AppColors.black,
              ),
            ),
            if (showLoadingIndicator) ...[
              const SizedBox(height: AppSpacing.sm),
              const AppCircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show CameraPosition, GoogleMap;
import 'package:location_repository/location_repository.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/map/map.dart';

class GoogleMapPage extends StatelessWidget {
  const GoogleMapPage({required this.props, super.key});

  final GoogleMapProps props;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapBloc(
        userRepository: context.read<UserRepository>(),
        locationRepository: context.read<LocationRepository>(),
      ),
      child: GoogleMapView(props: props),
    );
  }
}

class GoogleMapView extends StatelessWidget {
  const GoogleMapView({
    required this.props,
    super.key,
  });

  final GoogleMapProps props;

  PlaceDetails? get placeDetails => props.placeDetails;

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

  Widget _buildSaveLocationBtn(BuildContext context) {
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
              text: Text(isAddressFetchingFailure ? 'Сlarify address' : 'Save'),
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

  Widget _buildErrorAddress(BuildContext context) => Tappable(
        onTap: () async => _goToSearchLocationPage(context),
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(
            horizontal: 60,
          ),
          child: Text(
            "We don't take it here",
            textAlign: TextAlign.center,
            style: context.headlineMedium,
          ),
        ),
      );

  Widget _buildInProgress(BuildContext context, {bool alsoLoading = false}) {
    return Tappable(
      onTap: () async => _goToSearchLocationPage(context),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 60,
        ),
        child: Column(
          children: [
            Text('Finding you...', style: context.headlineMedium),
            if (alsoLoading) ...[
              const SizedBox(height: 6),
              const AppCircularProgressIndicator(
                color: AppColors.black,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddressName(String address) => BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          final isCameraMoving = state.isCameraMoving;
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
                      address,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: context.headlineLarge
                          ?.copyWith(fontWeight: AppFontWeight.semiBold),
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
                        child: const Text(
                          'Change delivery address',
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

  Positioned _buildAddress(BuildContext context) => Positioned(
        top: AppSpacing.xxxlg * 2,
        right: 0,
        left: 0,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            final addressName = state.addressName;
            final isCameraMoving = state.isCameraMoving;
            final isAddressFetching = state.status.isAddressFetchingLoading;
            final isFailure = state.status.isAddressFetchingFailure;

            if (isCameraMoving) {
              return _buildInProgress(context);
            }
            if (isAddressFetching) {
              return _buildInProgress(context, alsoLoading: !isCameraMoving);
            }
            if (isFailure) {
              return _buildErrorAddress(context);
            }
            return _buildAddressName(addressName);
          },
        ),
      );

  Widget _buildNavigateToPlaceDetailsAndPopBtn(BuildContext context) =>
      Positioned(
        left: AppSpacing.md,
        top: AppSpacing.xxlg + AppSpacing.lg,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            final isCameraMoving = state.isCameraMoving;
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: isCameraMoving ? 0 : 1,
              child: Row(
                children: [
                  if (context.canPop())
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadowEffect.defaultValue,
                        ],
                      ),
                      child: AppIcon.button(
                        icon: Icons.adaptive.arrow_back_sharp,
                        onTap: context.pop,
                      ),
                    ),
                  const SizedBox(
                    width: AppSpacing.md,
                  ),
                  if (placeDetails != null)
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadowEffect.defaultValue,
                        ],
                      ),
                      child: AppIcon.button(
                        icon: LucideIcons.send,
                        onTap: () {
                          context.read<MapBloc>().add(
                                MapAnimateToPlaceDetails(
                                  placeDetails: placeDetails,
                                ),
                              );
                        },
                      ),
                    ),
                ],
              ).ignorePointer(isMoving: isCameraMoving),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: AppColors.transparent,
        systemNavigationBarColor: AppColors.transparent,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            const MapView(),
            _buildAddress(context),
            _buildNavigateToPlaceDetailsAndPopBtn(context),
            _buildSaveLocationBtn(context),
          ],
        ),
        floatingActionButton: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            final isCameraMoving = state.isCameraMoving;
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: isCameraMoving ? 0 : 1,
              child: FloatingActionButton(
                onPressed: () => context
                    .read<MapBloc>()
                    .add(const MapAnimateToCurrentPositionRequested()),
                elevation: 3,
                shape: const CircleBorder(),
                backgroundColor: AppColors.white,
                child: const AppIcon(icon: LucideIcons.circleDot),
              ).ignorePointer(isMoving: isCameraMoving),
            );
          },
        ),
      ),
    );
  }
}

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();
    final mapType = context.select((MapBloc bloc) => bloc.state.mapType);
    final initialCameraPosition =
        context.select((MapBloc bloc) => bloc.state.initialCameraPosition);
    final isCameraMoving =
        context.select((MapBloc bloc) => bloc.state.isCameraMoving);

    return SizedBox(
      height: context.screenHeight,
      width: context.screenWidth,
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) =>
                bloc.add(MapCreateRequested(controller: controller)),
            mapType: mapType,
            initialCameraPosition: initialCameraPosition,
            myLocationEnabled: true,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            indoorViewEnabled: !isCameraMoving,
            padding: const EdgeInsets.fromLTRB(0, 100, 12, 160),
            zoomControlsEnabled: !isCameraMoving,
            onCameraMoveStarted: () {
              bloc.add(const MapCameraMoveStartRequested());
            },
            onCameraIdle: () {
              bloc.add(const MapCameraIdleRequested());
            },
            onCameraMove: (CameraPosition position) {
              bloc.add(MapCameraMoveRequested(position: position));
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100, right: AppSpacing.md),
              child: Assets.icons.pinIcon.svg(height: 50, width: 50),
            ).ignorePointer(isMoving: true),
          ),
        ],
      ),
    );
  }
}

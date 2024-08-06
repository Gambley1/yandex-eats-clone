import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show CameraPosition, GoogleMap;
import 'package:location_repository/location_repository.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: true,
      safeArea: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.isIOS
            ? SystemUiOverlayTheme.iOSDarkSystemBarTheme
            : SystemUiOverlayTheme.androidTransparentDarkSystemBarTheme,
        child: Stack(
          children: [
            const MapView(),
            const GoogleMapAddressView(),
            GoogleMapPlaceDetailsButton(placeDetails: placeDetails),
            GoogleMapSaveLocationButton(),
          ],
        ),
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
              child: const AppIcon(
                icon: LucideIcons.circleDot,
                color: AppColors.black,
              ),
            ).ignorePointer(isMoving: isCameraMoving),
          );
        },
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

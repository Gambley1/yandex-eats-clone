part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

final class MapCreateRequested extends MapEvent {
  const MapCreateRequested({required this.controller});

  final GoogleMapController controller;
}

final class MapCameraMoveStartRequested extends MapEvent {
  const MapCameraMoveStartRequested();
}

final class MapCameraMoveRequested extends MapEvent {
  const MapCameraMoveRequested({required this.position});

  final CameraPosition position;
}

final class MapCameraIdleRequested extends MapEvent {
  const MapCameraIdleRequested();
}

final class MapAnimateToPositionRequested extends MapEvent {
  const MapAnimateToPositionRequested({
    required this.position,
    this.zoom = 18,
  });

  final LatLng position;
  final double zoom;
}

final class MapAnimateToPlaceDetails extends MapEvent {
  const MapAnimateToPlaceDetails({required this.placeDetails});

  final PlaceDetails? placeDetails;
}

final class MapAnimateToCurrentPositionRequested extends MapEvent {
  const MapAnimateToCurrentPositionRequested();
}

final class MapPositionSaveRequested extends MapEvent {
  const MapPositionSaveRequested();
}

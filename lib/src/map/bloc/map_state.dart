part of 'map_bloc.dart';

enum MapStatus {
  initial,
  loading,
  success,
  failure,
  fetchingAddressLoading,
  fetchingAddressSuccess,
  fetchingAddressFailure;

  bool get isAddressFetchingLoading => this == MapStatus.fetchingAddressLoading;
  bool get isAddressFetchingFailure => this == MapStatus.fetchingAddressFailure;
}

class MapState extends Equatable {
  MapState.initial()
      : this._(
          addressName: '',
          status: MapStatus.initial,
          isCameraMoving: false,
          mapController: Completer<GoogleMapController>(),
          initialCameraPosition: _initialCamerPosition,
          currentPosition: _initialCamerPosition.target,
          mapType: MapType.normal,
        );

  const MapState._({
    required this.addressName,
    required this.status,
    required this.isCameraMoving,
    required this.mapController,
    required this.initialCameraPosition,
    required this.currentPosition,
    required this.mapType,
  });

  static const _almatyCenterPosition = LatLng(43.2364, 76.9185);
  static const _initialCamerPosition =
      CameraPosition(target: _almatyCenterPosition, zoom: 11);

  final String addressName;
  final MapStatus status;
  final bool isCameraMoving;
  final Completer<GoogleMapController> mapController;
  final CameraPosition initialCameraPosition;
  final LatLng currentPosition;
  final MapType mapType;

  @override
  List<Object?> get props => [
        addressName,
        status,
        isCameraMoving,
        mapController,
        initialCameraPosition,
        currentPosition,
        mapType,
      ];

  MapState copyWith({
    String? addressName,
    MapStatus? status,
    bool? isCameraMoving,
    Completer<GoogleMapController>? mapController,
    CameraPosition? initalCameraPosition,
    LatLng? currentPosition,
    MapType? mapType,
  }) {
    return MapState._(
      addressName: addressName ?? this.addressName,
      status: status ?? this.status,
      isCameraMoving: isCameraMoving ?? this.isCameraMoving,
      mapController: mapController ?? this.mapController,
      initialCameraPosition: initalCameraPosition ?? initialCameraPosition,
      currentPosition: currentPosition ?? this.currentPosition,
      mapType: mapType ?? this.mapType,
    );
  }
}

extension on LatLng {
  Location get asLocation => Location(lat: latitude, lng: longitude);
}

extension on Position {
  LatLng get asLatLng => LatLng(latitude, longitude);
}

extension on Location {
  LatLng get asLatLng => LatLng(lat, lng);
}

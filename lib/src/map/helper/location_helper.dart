// ignore_for_file: unnecessary_statements

import 'dart:async' show Completer;

import 'package:flutter/material.dart' show AnimationController;
import 'package:geolocator/geolocator.dart' show Position;
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show
        CameraPosition,
        CameraUpdate,
        GoogleMapController,
        LatLng,
        MapType,
        Marker;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/home/bloc/location_bloc.dart';
import 'package:papa_burger/src/services/network/api/api.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared/shared.dart';

class LocationHelper {
  LocationHelper({
    required LocationApi locationApi,
    required LocationBloc locationBloc,
    required LocationNotifier locationNotifier,
  })  : _locationApi = locationApi,
        _locationBloc = locationBloc,
        _locationNotifier = locationNotifier;

  final LocationApi _locationApi;
  final LocationBloc _locationBloc;
  final LocationNotifier _locationNotifier;

  MapType get mapType => _mapType;
  Set<Marker> get markers => _markers;
  CameraPosition get initialCameraPosition => _initialCameraPosition;
  LatLng get dynamicMarkerPosition => _dynamicMarkerPosition;
  void onMapCreated(GoogleMapController controller) =>
      _onMapCreated(controller);
  void get initMapConfiguration => _initMapConfiguration();
  void navigateToCurrentPosition() => _navigateToCurrentPosition();
  void navigateToPlaceDetails(PlaceDetails? placeDetails) =>
      _navigateToPlaceDetails(placeDetails);
  Future<void> saveLocation(LatLng location) => _saveLocation(location);

  Stream<LatLng> get dynamicMarkerPositionStream =>
      _dynamicMarkerPositionSubject.stream;

  final MapType _mapType = MapType.normal;
  final Set<Marker> _markers = <Marker>{};
  final CameraPosition _initialCameraPosition =
      const CameraPosition(target: almatyCenterPosition, zoom: 11);
  late LatLng _dynamicMarkerPosition = _initialCameraPosition.target;
  final Completer<GoogleMapController> _mapController = Completer();

  final _dynamicMarkerPositionSubject =
      BehaviorSubject<LatLng>.seeded(almatyCenterPosition);

  void dispose() => _mapController.future.then((gMap) => gMap.dispose());

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void onCameraMove(CameraPosition position) {
    final location = position.target;
    _dynamicMarkerPosition = location;
    _dynamicMarkerPositionSubject.sink.add(location);
    _locationBloc.findLocation.add(position.target);
    _locationBloc.onCameraMove.add(position.target);
    _locationBloc.isFetching.add(true);
  }

  void onCameraIdle(
    AnimationController animationController, {
    required bool isLoading,
  }) {
    isLoading ? null : animationController.forward();
    _locationBloc.isFetching.add(false);
  }

  void onCameraStarted(AnimationController animationController) {
    animationController.reverse();
    _locationBloc.isFetching.add(true);
  }

  Future<void> _initMapConfiguration() async {
    final cookiePosition = LocalStorage().getAddress;

    if (cookiePosition == 'No location, please pick one') {
      return;
    } else {
      await _navigateToSavedPosition();
      logI('Navigating to saved position');
    }
  }

  Future<void> _navigateToCurrentPosition() async {
    await _getCurrentPosition().then((newPosition) {
      final latLng = LatLng(newPosition.latitude, newPosition.longitude);
      _animateCamera(latLng);
    });
  }

  Future<void> _navigateToSavedPosition() async {
    final lat = LocalStorage().latitude;
    final lng = LocalStorage().longitude;
    if (lat == 0 && lng == 0) return;

    final cookiePosition = LatLng(lat, lng);

    await Future.delayed(
      const Duration(milliseconds: 600),
      () => _animateCamera(cookiePosition),
    );
  }

  void _navigateToPlaceDetails(PlaceDetails? placeDetails) {
    final lat = placeDetails?.geometry.location.lat;
    final lng = placeDetails?.geometry.location.lng;

    if (lat == null && lng == null) return;

    final newPosition = LatLng(lat!, lng!);

    _animateCamera(newPosition);
  }

  void _animateCamera(LatLng newPosition, {double zoom = 18}) {
    _mapController.future.then(
      (gMap) => gMap.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newPosition,
            zoom: zoom,
          ),
        ),
      ),
    );
  }

  Future<void> _saveLocation(LatLng location) async {
    final latitude = LocalStorage().latitude;
    final longitude = LocalStorage().longitude;
    if (location.latitude == latitude && location.longitude == longitude) {
      return;
    }
    final lat = location.latitude;
    final lng = location.longitude;
    LocalStorage()
      ..saveLatLng(location.latitude, location.longitude)
      ..saveTemporaryLatLngForUpdate(location.latitude, location.longitude);

    final addressName = await _getCurrentAddressName(lat, lng);
    LocalStorage().saveAddressName(addressName);
    _locationNotifier.updateLocation(lat, lng);
  }

  Future<Position> _getCurrentPosition() async {
    final position = await _locationApi.determineCurrentPosition();
    return position;
  }

  Future<String> _getCurrentAddressName(double lat, double lng) async {
    final address = await _locationApi.getFormattedAddress(lat, lng);
    if (address.isEmpty) {
      return 'Got address, but API is disabled.';
    } else {
      return address;
    }
  }
}

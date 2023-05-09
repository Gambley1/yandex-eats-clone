import 'dart:async' show Completer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:papa_burger/src/restaurant.dart';
import 'package:rxdart/rxdart.dart';

class LocationHelper {
  LocationHelper(
      {required LocalStorage localStorage,
      required LocationApi locationApi,
      required LocationBloc locationBloc,
      required LocationNotifier locationNotifier})
      : _localStorage = localStorage,
        _locationApi = locationApi,
        _locationBloc = locationBloc,
        _locationNotifier = locationNotifier;

  final LocalStorage _localStorage;
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
  void get navigateToCurrentPosition => _navigateToCurrentPosition();
  void navigateToPlaceDetails(PlaceDetails? placeDetails) =>
      _navigateToPlaceDetails(placeDetails);
  Future<void> saveLocation(LatLng location) => _saveLocation(location);

  Stream<LatLng> get dynamicMarkerPositionStream =>
      _dynamicMarkerPositionSubject.stream;

  final MapType _mapType = MapType.normal;
  final Set<Marker> _markers = <Marker>{};
  final CameraPosition _initialCameraPosition =
      const CameraPosition(target: kazakstanCenterPosition, zoom: 18);
  late LatLng _dynamicMarkerPosition = _initialCameraPosition.target;
  final Completer<GoogleMapController> _mapController = Completer();

  final _dynamicMarkerPositionSubject =
      BehaviorSubject<LatLng>.seeded(kazakstanCenterPosition);

  void dispose() => _mapController.future.then((gMap) => gMap.dispose());

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void onCameraMove(CameraPosition position) {
    final location = position.target;
    // logger.w("On Move Camera Location is $location");
    _dynamicMarkerPosition = location;
    // logger.w('New Dynamic Marker Position $_dynamicMarkerPosition');
    _dynamicMarkerPositionSubject.sink.add(location);
    _locationBloc.findLocation.add(position.target);
    _locationBloc.onCameraMove.add(position.target);
    _locationBloc.isFetching.add(true);
  }

  void onCameraIdle(bool isLoading, AnimationController animationController) {
    isLoading ? null : animationController.forward();
    _locationBloc.isFetching.add(false);
  }

  void onCameraStarted(AnimationController animationController) {
    animationController.reverse();
    _locationBloc.isFetching.add(true);
  }

  _initMapConfiguration() async {
    final cookiePosition = _localStorage.getAddress;

    if (cookiePosition == 'No location, please pick one') {
      return;
    } else {
      _navigateToSavedPosition();
      logger.w('NAVIGATING TO SAVED POSITION');
    }
  }

  Future<void> _navigateToCurrentPosition() async {
    _getCurrentPosition().then((newPosition) {
      final latlng = LatLng(newPosition.latitude, newPosition.longitude);
      _animateCamera(latlng);
    });
  }

  Future<void> _navigateToSavedPosition() async {
    final lat = _localStorage.latitude;
    final lng = _localStorage.longitude;
    if (lat == 0 && lng == 0) return;

    final cookiePosition = LatLng(lat, lng);

    await Future.delayed(const Duration(milliseconds: 600)).then(
      (value) => _animateCamera(cookiePosition),
    );
  }

  _navigateToPlaceDetails(PlaceDetails? placeDetails) {
    final lat = placeDetails?.geometry.location.lat;
    final lng = placeDetails?.geometry.location.lng;

    if (lat == null && lng == null) return;

    final newPosition = LatLng(lat!, lng!);

    _animateCamera(newPosition);
  }

  _animateCamera(LatLng newPosition, {double zoom = 18}) {
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
    final lat = location.latitude;
    final lng = location.longitude;
    _localStorage.saveLatLng(location.latitude, location.longitude);
    _localStorage.saveTemporaryLatLngForUpdate(
        location.latitude, location.longitude);

    final addressName = await _getCurrentAddressName(lat, lng);
    _localStorage.saveAddressName(addressName);
    _locationNotifier.updateLocation(addressName);

    final userAddresses = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('address');

    final querySnapshot = await userAddresses.get();

    if (querySnapshot.docs.isNotEmpty) {
      logger.w('Query Snapshot docs are not empty.');
      userAddresses.doc(querySnapshot.docs.first.id).delete();
      userAddresses.add({
        'address_name': addressName,
      });
    } else {
      userAddresses.add({
        'address_name': addressName,
      });
    }

    logger.w('SAVING LOCATION $location AND ADDRESS $addressName');
  }

  // Future<BitmapDescriptor> _getCustomIcon() async {
  //   final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
  //     const ImageConfiguration(size: Size(2, 2)),
  //     'assets/icons/pin.png',
  //   );
  //   return customIcon;
  // }

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

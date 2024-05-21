import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/services/network/api/api.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:papa_burger/src/views/pages/main/state/address_result.dart';
import 'package:papa_burger/src/views/pages/main/state/location_result.dart';
import 'package:rxdart/rxdart.dart'
    show
        BehaviorSubject,
        DebounceExtensions,
        OnErrorExtensions,
        Rx,
        StartWithExtension,
        SwitchMapExtension;

@immutable
class LocationBloc {
  factory LocationBloc({
    required LocationApi locationApi,
  }) {
    final autocompleteSubject = BehaviorSubject<String>();

    final result = autocompleteSubject
        .distinct()
        .debounceTime(const Duration(milliseconds: 400))
        .switchMap<LocationResult>(
      (String term) {
        logW(term);
        if (term.isNotEmpty && term.length >= 2) {
          return Rx.fromCallable(() => locationApi.getAutoComplete(query: term))
              .map(
                (autoCompletes) => autoCompletes.isNotEmpty
                    ? LocationResultWithResults(autoCompletes)
                    : const LocationResultNoResults(),
              )
              .startWith(const LocationResultLoading())
              .onErrorReturnWith((error, stacktrace) {
            logE('$error, $stacktrace');
            return LocationResultError(error);
          });
        } else {
          return Stream<LocationResult>.value(const LocationResultEmpty());
        }
      },
    ).startWith(const LocationResultEmpty());

    final addressSubject = BehaviorSubject<LatLng>.seeded(almatyCenterPosition);

    /// Using this subject to then check whether user moving google map camera
    /// or it's idle to then accordingly emit or not emit the value of
    /// address subject.
    final userMoveCamera = BehaviorSubject<bool>.seeded(false);

    final addressName = userMoveCamera.distinct().switchMap((moves) {
      if (moves == false) {
        return addressSubject
            .distinct()
            .debounceTime(const Duration(milliseconds: 300))
            .switchMap<AddressResult>((latLng) {
          final lat = latLng.latitude;
          final lng = latLng.longitude;
          return Rx.fromCallable(
            () => locationApi.getFormattedAddress(lat, lng),
          )
              .map((address) {
                if (address.isNotEmpty) {
                  return AddressWithResult(address);
                }
                return const AddressWithNoResult();
              })
              .startWith(const Loading())
              .onErrorReturnWith((error, stackTrace) {
                logE(stackTrace);
                return AddressError(error);
              });
        });
      } else {
        return Stream<AddressResult>.value(const InProgress());
      }
    });

    final locationSubject = BehaviorSubject<String>.seeded(noLocation);

    final address = locationSubject.distinct().map((address) {
      final address$ = LocalStorage().getAddress;
      address = address$;
      locationSubject.sink.add(address);
      return address;
    });

    final positionSubject =
        BehaviorSubject<LatLng>.seeded(almatyCenterPosition);

    final position = positionSubject.distinct().map((cameraPosition) {
      final latLng = cameraPosition;
      return LatLng(latLng.latitude, latLng.longitude);
    });

    // final saveLocationSubject = BehaviorSubject<LatLng>();

    // final saveLocation = saveLocationSubject.distinct().map<void>((userPos) {
    //   final userId = localStorage.getToken;
    //   logger.w('USER ID IS $userId');
    //   logger.w('USER POSITION TO SAVE $userPos');
    //   firebaseDB.collection('users').doc(userId).set({
    //     'user_location': userPos,
    //   });
    // });

    return LocationBloc._(
      search: autocompleteSubject.sink,
      findLocation: addressSubject.sink,
      onCameraMove: positionSubject.sink,
      saveLocation: locationSubject.sink,
      isFetching: userMoveCamera.sink,
      result: result,
      address: address,
      moving: userMoveCamera,
      addressName: addressName,
      position: position,
    );
  }
  const LocationBloc._({
    required this.search,
    required this.findLocation,
    required this.onCameraMove,
    required this.saveLocation,
    required this.isFetching,
    required this.result,
    required this.moving,
    required this.address,
    required this.addressName,
    required this.position,
  });
  final Sink<String> search;
  final Sink<LatLng> findLocation;
  final Sink<LatLng> onCameraMove;
  final Sink<String> saveLocation;
  final Sink<bool> isFetching;
  final Stream<LocationResult> result;
  final Stream<bool> moving;
  final Stream<String> address;
  final Stream<AddressResult> addressName;
  final Stream<LatLng> position;

  void dispose() {
    search.close();
    findLocation.close();
    onCameraMove.close();
    isFetching.close();
  }
}

class LocationNotifier extends ValueNotifier<String> {
  factory LocationNotifier() => _instance;

  LocationNotifier._() : super('') {
    final lat = LocalStorage().latitude;
    final lng = LocalStorage().longitude;
    _getAddress(lat, lng).then((address) => value = address);
  }
  static final _instance = LocationNotifier._();

  void updateLocation(double latitude, double longitude) =>
      _getAddress(latitude, longitude).then((address) => value = address);

  void clearLocation() => value = '';

  Future<String> _getAddress(double latitude, double longitude) async {
    if (latitude == 0 || longitude == 0) {
      return 'Please select your address🙏';
    }
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final parts = <String?>[
          placemark.street,
          placemark.locality,
          placemark.country,
        ]..removeWhere((part) => part == null || part.isEmpty);
        final address = parts.join(', ');
        return address;
      }
      return 'Please select your address🙏';
    } catch (e) {
      throw Exception('Failed to get address. $e');
    }
  }
}

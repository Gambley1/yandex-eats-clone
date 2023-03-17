import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter/foundation.dart' show immutable;
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:papa_burger/src/restaurant.dart'
    show
        LocalStorage,
        LocationApi,
        LocationResult,
        LocationResultError,
        LocationResultLoading,
        LocationResultNoResults,
        LocationResultWithResults,
        kazakstanCenterPosition,
        logger,
        noLocation;
import 'package:rxdart/rxdart.dart'
    show
        Rx,
        BehaviorSubject,
        DebounceExtensions,
        SwitchMapExtension,
        StartWithExtension,
        OnErrorExtensions;

@immutable
class LocationBloc {
  final Sink<String> search;
  final Sink<LatLng?> findLocation;
  final Sink<LatLng> onCameraMove;
  final Sink<LatLng> saveLocation;
  final Stream<LocationResult?> result;
  final Stream<String> address;
  final Stream<String> addressName;
  final Stream<LatLng> position;

  const LocationBloc._privateConstrucator({
    required this.search,
    required this.findLocation,
    required this.onCameraMove,
    required this.saveLocation,
    required this.result,
    required this.address,
    required this.addressName,
    required this.position,
  });

  void dispose() {
    search.close();
    findLocation.close();
    onCameraMove.close();
  }

  factory LocationBloc({
    required LocationApi locationApi,
    required LocalStorage localStorage,
  }) {
    final firebaseDB = FirebaseFirestore.instance;

    final autocompleteSubject = BehaviorSubject<String>();

    final result = autocompleteSubject
        .distinct()
        .debounceTime(const Duration(milliseconds: 400))
        .switchMap<LocationResult?>(
      (String term) {
        logger.w(term);
        if (term.isNotEmpty && term.length >= 2) {
          return Rx.fromCallable(() => locationApi.getAutoComplete(query: term))
              .map((autoCompletes) => autoCompletes.isNotEmpty
                  ? LocationResultWithResults(autoCompletes)
                  : const LocationResultNoResults())
              .startWith(const LocationResultLoading())
              .onErrorReturnWith((error, stacktrace) {
            logger.e('${error.toString()}, ${stacktrace.toString()}');
            return LocationResultError(error);
          });
        } else {
          return Stream<LocationResult?>.value(null);
        }
      },
    );

    final addressSubject =
        BehaviorSubject<LatLng>.seeded(kazakstanCenterPosition);

    final addressName = addressSubject
        .distinct()
        .debounceTime(const Duration(milliseconds: 200))
        .switchMap((latlng) {
      final lat = latlng.latitude;
      final lng = latlng.longitude;
      return Rx.fromCallable(
        () => locationApi.getFormattedAddress(lat, lng),
      ).map((address) {
        return address;
      });
    });

    final locationSubject = BehaviorSubject<String>.seeded(noLocation);

    final address = locationSubject.distinct().map((address) {
      final address$ = localStorage.getAddress;
      address = address$;
      locationSubject.sink.add(address);
      return address;
    });

    final positionSubject =
        BehaviorSubject<LatLng>.seeded(kazakstanCenterPosition);

    final position = positionSubject.distinct().map((cameraPosition) {
      final latlng = cameraPosition;
      return LatLng(latlng.latitude, latlng.longitude);
    });

    final saveLocationSubject = BehaviorSubject<LatLng>();

    final saveLocation = saveLocationSubject.distinct().map<void>((userPos) {
      final userId = localStorage.getToken;
      logger.w('USER ID IS $userId');
      logger.w('USER POSITION TO SAVE $userPos');
      firebaseDB.collection('users').doc(userId).set({
        'user_location': userPos,
      });
    });

    return LocationBloc._privateConstrucator(
      search: autocompleteSubject.sink,
      findLocation: addressSubject.sink,
      onCameraMove: positionSubject.sink,
      saveLocation: saveLocationSubject.sink,
      result: result,
      address: address,
      addressName: addressName,
      position: position,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:papa_burger/src/restaurant.dart'
    show
        AddressError,
        AddressResult,
        AddressWithNoResult,
        AddressWithResult,
        ConnectivityService,
        InProggress,
        Loading,
        LocalStorage,
        LocationApi,
        LocationResult,
        LocationResultEmpty,
        LocationResultError,
        LocationResultLoading,
        LocationResultNoResults,
        LocationResultWithResults,
        kazakstanCenterPosition,
        logger,
        noLocation;
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

  const LocationBloc._privateConstrucator({
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

  void dispose() {
    search.close();
    findLocation.close();
    onCameraMove.close();
    isFetching.close();
  }

  factory LocationBloc(
      {required LocationApi locationApi,
      required LocalStorage localStorage,
      required ConnectivityService connectivityService}) {
    // final firebaseDB = FirebaseFirestore.instance;

    final autocompleteSubject = BehaviorSubject<String>();

    final result = autocompleteSubject
        .distinct()
        .debounceTime(const Duration(milliseconds: 400))
        .switchMap<LocationResult>(
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
          return Stream<LocationResult>.value(const LocationResultEmpty());
        }
      },
    ).startWith(const LocationResultEmpty());

    final addressSubject =
        BehaviorSubject<LatLng>.seeded(kazakstanCenterPosition);

    /// Using this subject to then check whether user moving goole map camera or
    /// it's idle to then accordingly emit or not emit the value of address subject.
    final userMoveCamera = BehaviorSubject<bool>.seeded(false);

    final addressName = userMoveCamera.distinct().switchMap((moves) {
      if (moves == false) {
        return addressSubject
            .distinct()
            .debounceTime(const Duration(milliseconds: 300))
            .switchMap<AddressResult>((latlng) {
          final lat = latlng.latitude;
          final lng = latlng.longitude;
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
                logger.e(stackTrace);
                return AddressError(error);
              });
        });
      } else {
        return Stream<AddressResult>.value(const InProggress());
      }
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

    // final saveLocationSubject = BehaviorSubject<LatLng>();

    // final saveLocation = saveLocationSubject.distinct().map<void>((userPos) {
    //   final userId = localStorage.getToken;
    //   logger.w('USER ID IS $userId');
    //   logger.w('USER POSITION TO SAVE $userPos');
    //   firebaseDB.collection('users').doc(userId).set({
    //     'user_location': userPos,
    //   });
    // });

    return LocationBloc._privateConstrucator(
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
}

class LocationNotifier extends ValueNotifier<String> {
  static final LocationNotifier _instance =
      LocationNotifier._privateConstructor('');

  factory LocationNotifier() => _instance;

  LocationNotifier._privateConstructor(super.value) {
    logger.w('Inits Singletion Location Notifier');
    value = _localStorage.getAddress;
  }

  final LocalStorage _localStorage = LocalStorage.instance;

  void updateLocation(String location) {
    logger.w('Initial value $value');
    value = location;
    notifyListeners();
    logger.w('New updated value $value');
  }
}

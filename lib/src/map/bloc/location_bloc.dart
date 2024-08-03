import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocode/geocode.dart' as geo;
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_food_api/client.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const LocationState.initial()) {
    on<LocationChanged>(_onLocationChanged);
    on<LocationFetchAddressRequested>(_onLocationFetchAddressRequested);

    _locationSubscription = _userRepository
        .currentLocation()
        .listen(_locationChanged, onError: addError);
  }

  final UserRepository _userRepository;

  StreamSubscription<Location>? _locationSubscription;

  void _locationChanged(Location location) =>
      add(LocationChanged(location: location));

  Future<void> _onLocationChanged(
    LocationChanged event,
    Emitter<LocationState> emit,
  ) async {
    emit(
      state.copyWith(
        location: event.location,
        status: LocationStatus.loading,
      ),
    );
    if (event.location.isUndefined) return;
    add(const LocationFetchAddressRequested());
  }

  Future<void> _onLocationFetchAddressRequested(
    LocationFetchAddressRequested event,
    Emitter<LocationState> emit,
  ) async {
    final location = state.location;
    emit(state.copyWith(status: LocationStatus.loading));
    try {
      final geoAddress = await geo.GeoCode().reverseGeocoding(
        latitude: location.lat,
        longitude: location.lng,
      );
      if (geoAddress.streetAddress == null &&
          geoAddress.city == null &&
          geoAddress.countryName == null) {
        return emit(
          state.copyWith(
            address: const Address(street: 'Please pick location'),
            status: LocationStatus.populated,
          ),
        );
      }
      final street =
          geoAddress.streetAddress != null && geoAddress.streetNumber != null
              ? '${geoAddress.streetAddress} ${geoAddress.streetNumber}'
              : geoAddress.streetAddress;
      final address = Address(
        street: street,
        locality: geoAddress.city,
        country: geoAddress.countryName,
      );
      emit(
        state.copyWith(address: address, status: LocationStatus.populated),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: LocationStatus.failure));
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}

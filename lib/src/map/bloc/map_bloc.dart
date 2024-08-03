import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_repository/location_repository.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_food_api/client.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({
    required LocationRepository locationRepository,
    required UserRepository userRepository,
  })  : _locationRepository = locationRepository,
        _userRepository = userRepository,
        super(MapState.initial()) {
    on<MapCreateRequested>(_onMapCreateRequested);
    on<MapCameraMoveStartRequested>(_onMapCameraMoveStartRequested);
    on<MapCameraMoveRequested>(_onMapMoveRequested);
    on<MapCameraIdleRequested>(_onMapCameraIdleRequested);
    on<MapAnimateToPositionRequested>(_onMapAnimateToPositionRequested);
    on<MapAnimateToPlaceDetails>(_onMapAnimateToPlaceDetails);
    on<MapAnimateToCurrentPositionRequested>(
      _onMapAnimateToCurrentPositionRequested,
    );
    on<MapPositionSaveRequested>(_onMapPositionSaveRequested);
  }

  final LocationRepository _locationRepository;
  final UserRepository _userRepository;

  Future<void> _onMapCreateRequested(
    MapCreateRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      final controller = event.controller;
      state.mapController.complete(controller);

      final currentPosition = _userRepository.fetchCurrentLocation();
      if (currentPosition.isUndefined) return;

      add(MapAnimateToPositionRequested(position: currentPosition.asLatLng));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MapStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onMapCameraMoveStartRequested(
    MapCameraMoveStartRequested event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(isCameraMoving: true));
  }

  Future<void> _onMapMoveRequested(
    MapCameraMoveRequested event,
    Emitter<MapState> emit,
  ) async {
    emit(
      state.copyWith(
        isCameraMoving: true,
        currentPosition: event.position.target,
      ),
    );
  }

  Future<void> _onMapCameraIdleRequested(
    MapCameraIdleRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          isCameraMoving: false,
          status: MapStatus.fetchingAddressLoading,
        ),
      );
      final addressName = await _fetchFormattedAddress(state.currentPosition);
      emit(
        state.copyWith(
          addressName: addressName,
          status: MapStatus.fetchingAddressSuccess,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MapStatus.fetchingAddressFailure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onMapAnimateToPositionRequested(
    MapAnimateToPositionRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      final mapController = state.mapController;
      await mapController.future.then(
        (gMap) => gMap.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: event.position,
              zoom: event.zoom,
            ),
          ),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MapStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onMapAnimateToPlaceDetails(
    MapAnimateToPlaceDetails event,
    Emitter<MapState> emit,
  ) async {
    final lat = event.placeDetails?.location.lat;
    final lng = event.placeDetails?.location.lng;

    if (lat == null && lng == null) return;

    final newPosition = LatLng(lat!, lng!);
    add(MapAnimateToPositionRequested(position: newPosition));
  }

  Future<void> _onMapAnimateToCurrentPositionRequested(
    MapAnimateToCurrentPositionRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      final currentPosition = await _locationRepository.getCurrentPosition();
      final position = currentPosition.asLatLng;
      add(MapAnimateToPositionRequested(position: position));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MapStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onMapPositionSaveRequested(
    MapPositionSaveRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      final currentLocation = _userRepository.fetchCurrentLocation();
      final newLocation = state.currentPosition.asLocation;
      if (newLocation == currentLocation) return;

      await _userRepository.changeLocation(location: newLocation);
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MapStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<String> _fetchFormattedAddress(LatLng location) async {
    return _locationRepository.getFormattedAddress(
      location.latitude,
      location.longitude,
    );
  }
}

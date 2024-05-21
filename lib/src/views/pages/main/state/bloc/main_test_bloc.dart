import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:papa_burger/isolates.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/services/network/api/api.dart';
import 'package:papa_burger/src/services/storage/storage.dart';

part 'main_test_event.dart';
part 'main_test_state.dart';

class MainTestBloc extends Bloc<MainTestEvent, MainTestState> {
  MainTestBloc({
    RestaurantApi? restaurantApi,
  })  : _restaurantApi = restaurantApi ?? RestaurantApi(),
        super(const MainTestState.initial()) {
    on<MainTestStarted>(_onMainTestStarted);
    on<_MainTestLatLngChanged>(_onMainTestLatLngChanged);
    on<MainTestRestaurantsAndTagsFetched>(_onMainTestFetchRestaurantsAndTags);
    on<MainTestFilterRestaurantsTagChanged>(
      _onMainTestFilterRestaurantsTagChanged,
    );
    on<_MainTestFilterRestaurantsTagAdded>(
      _onMainTestFilterRestaurantsTagAdded,
    );
    on<_MainTestFilterRestaurantsTagRemoved>(
      _onMainTestFilterRestaurantsTagRemoved,
    );
    on<MainTestTagsFiltersClear>(_onMainTestTagsFiltersReset);
    on<MainTestRefreshed>(_onMainTestRefreshed);
  }

  final RestaurantApi _restaurantApi;
  StreamSubscription<(double lat, double lng)>? _latLngSubscription;

  Future<void> _onMainTestStarted(
    MainTestStarted event,
    Emitter<MainTestState> emit,
  ) async {
    final lat = LocalStorage().latitude;
    final lng = LocalStorage().longitude;
    add(_MainTestLatLngChanged(lat, lng));

    _latLngSubscription = LocalStorage().latLngStream.listen((value) {
      final lat = value.$1;
      final lng = value.$2;
      add(_MainTestLatLngChanged(lat, lng));
    });
  }

  void _onMainTestFilterRestaurantsTagChanged(
    MainTestFilterRestaurantsTagChanged event,
    Emitter<MainTestState> emit,
  ) {
    final tag = event.tag;
    if (state.chosenTags.contains(tag)) {
      add(_MainTestFilterRestaurantsTagRemoved(tag));
    } else {
      add(_MainTestFilterRestaurantsTagAdded(tag));
    }
  }

  Future<void> _onMainTestFilterRestaurantsTagAdded(
    _MainTestFilterRestaurantsTagAdded event,
    Emitter<MainTestState> emit,
  ) async {
    final tag = event.tag;
    final loading = state.copyWith(
      status: MainPageStatus.loading,
      chosenTags: [...state.chosenTags, tag],
    );
    emit(loading);

    final lat = state.lat;
    final lng = state.lng;
    try {
      final filteredRestaurants = await _restaurantApi.getRestaurantsByTags(
        tags: state.chosenTags.map((e) => e.name).toList(),
        latitude: '$lat',
        longitude: '$lng',
      );
      final newState = state.copyWith(
        status: MainPageStatus.withFilteredRestaurants,
        filteredRestaurants: filteredRestaurants,
        chosenTags: state.chosenTags,
      );
      emit(newState);
    } catch (e) {
      _errorFormatter(e, emit);
    }
  }

  Future<void> _onMainTestFilterRestaurantsTagRemoved(
    _MainTestFilterRestaurantsTagRemoved event,
    Emitter<MainTestState> emit,
  ) async {
    final tag = event.tag;
    emit(
      state.copyWith(
        chosenTags: [...state.chosenTags]..remove(tag),
      ),
    );
    if (state.chosenTags.isEmpty) {
      add(const MainTestTagsFiltersClear());
    } else {
      final loading = state.copyWith(
        status: MainPageStatus.loading,
      );
      emit(loading);

      final lat = state.lat;
      final lng = state.lng;
      try {
        final filteredRestaurants = await _restaurantApi.getRestaurantsByTags(
          tags: state.chosenTags.map((e) => e.name).toList(),
          latitude: '$lat',
          longitude: '$lng',
        );
        final newState = state.copyWith(
          status: MainPageStatus.withFilteredRestaurants,
          filteredRestaurants: filteredRestaurants,
        );
        emit(newState);
      } catch (e) {
        _errorFormatter(e, emit);
      }
    }
  }

  Future<void> _onMainTestTagsFiltersReset(
    MainTestTagsFiltersClear event,
    Emitter<MainTestState> emit,
  ) async {
    final loading = state.copyWith(
      status: MainPageStatus.loading,
    );
    emit(loading);
    await Future<void>.delayed(const Duration(seconds: 1)).whenComplete(
      () => emit(
        state.copyWith(
          status: MainPageStatus.withRestaurantsAndTags,
          filteredRestaurants: [...state.filteredRestaurants]..clear(),
          chosenTags: [...state.chosenTags]..clear(),
        ),
      ),
    );
  }

  void _onMainTestLatLngChanged(
    _MainTestLatLngChanged event,
    Emitter<MainTestState> emit,
  ) {
    emit(
      state.copyWith(
        lat: event.lat,
        lng: event.lng,
        filteredRestaurants: [...state.filteredRestaurants]..clear(),
        chosenTags: [...state.chosenTags]..clear(),
      ),
    );

    add(const MainTestRestaurantsAndTagsFetched());
  }

  Future<void> _onMainTestFetchRestaurantsAndTags(
    MainTestRestaurantsAndTagsFetched event,
    Emitter<MainTestState> emit,
  ) async {
    final loading = state.copyWith(
      status: MainPageStatus.loading,
    );
    emit(loading);
    final lat = state.lat;
    final lng = state.lng;
    try {
      final page = await _restaurantApi.getRestaurantsPage(
        latitude: '$lat',
        longitude: '$lng',
      );
      if (page.restaurants.isEmpty) {
        final empty = state.copyWith(
          status: MainPageStatus.empty,
        );
        emit(empty);
      } else {
        final restaurants = _filterRestaurants(page.restaurants);
        final tags = await _restaurantApi.getRestaurantsTags(
          latitude: '$lat',
          longitude: '$lng',
        );
        final success = state.copyWith(
          status: MainPageStatus.withRestaurantsAndTags,
          restaurants: restaurants,
          tags: tags,
        );
        emit(success);
        await useRestaurantsIsolate();
      }
    } catch (e) {
      _errorFormatter(e, emit);
    }
  }

  void _onMainTestRefreshed(
    MainTestRefreshed event,
    Emitter<MainTestState> emit,
  ) {
    if (state.withFilteredRestaurants) {
      add(const MainTestTagsFiltersClear());
      add(const MainTestRestaurantsAndTagsFetched());
    } else {
      add(const MainTestRestaurantsAndTagsFetched());
    }
  }

  List<Restaurant> _filterRestaurants(List<Restaurant> restaurants) {
    return restaurants
      ..removeWhere(
        (restaurant) =>
            restaurant.name == 'Ne Rabotayet' ||
            (restaurant.permanentlyClosed ?? false),
      )
      ..removeDuplicates(
        by: (restaurant) => restaurant.name,
      )
      ..whereMoveToTheFront((restaurant) {
        final rating = restaurant.rating as double;
        return rating >= 4.8 || restaurant.userRatingsTotal! >= 300;
      })
      ..whereMoveToTheEnd((restaurant) {
        if (restaurant.rating != null) {
          final rating = restaurant.rating as double;
          return rating < 4.5 ||
              restaurant.userRatingsTotal == null ||
              restaurant.userRatingsTotal! <= 100;
        }
        return false;
      });
  }

  void _errorFormatter(Object? e, Emitter<MainTestState> emit) {
    logE('Error type is: $e');
    if (e is ClientTimeoutException) {
      logE('Message: ${e.message}');
      emit(
        state.copyWith(
          status: MainPageStatus.outOfTime,
          errMessage: e.message,
        ),
      );
    }
    if (e is NetworkException) {
      logE('Message: ${e.message}');
      emit(
        state.copyWith(
          status: MainPageStatus.noInternet,
          errMessage: e.message,
        ),
      );
    }
    if (e is NoRestaurantsFoundException) {
      logE('Message: ${e.message}');
      emit(
        state.copyWith(
          status: MainPageStatus.empty,
          errMessage: e.message,
        ),
      );
    }
    if (e is ClientRequestFailed) {
      logE('Message: ${e.message}');
      emit(
        state.copyWith(
          status: MainPageStatus.clientFailure,
          errMessage: e.message,
        ),
      );
    }
    if (e is MalformedClientResponse) {
      logE('Message: ${e.message}');
      emit(
        state.copyWith(
          status: MainPageStatus.malformedResponse,
          errMessage: e.message,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _latLngSubscription?.cancel();
    return super.close();
  }
}

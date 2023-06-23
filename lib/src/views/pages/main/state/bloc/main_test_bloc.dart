import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:papa_burger/isolates.dart';
import 'package:papa_burger/src/restaurant.dart';

part 'main_test_event.dart';
part 'main_test_state.dart';

class MainTestBloc extends Bloc<MainTestEvent, MainTestState> {
  MainTestBloc({
    RestaurantApi? restaurantApi,
    LocalStorage? localStorage,
  })  : _restaurantApi = restaurantApi ?? RestaurantApi(),
        _localStorage = localStorage ?? LocalStorage.instance,
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
    on<MainTestTagsFiltersReseted>(_onMainTestTagsFiltersReset);
    on<MainTestRefreshed>(_onMainTestRefreshed);
  }

  final RestaurantApi _restaurantApi;
  final LocalStorage _localStorage;
  StreamSubscription<(double lat, double lng)>? _latLngSubscription;

  Future<void> _onMainTestStarted(
    MainTestStarted event,
    Emitter<MainTestState> emit,
  ) async {
    final lat = _localStorage.latitude;
    final lng = _localStorage.longitude;
    add(_MainTestLatLngChanged(lat, lng));

    _latLngSubscription = _localStorage.latLngStream.listen((value) {
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
    final loading = state.copyWith(
      status: MainPageStatus.loading,
    );
    emit(loading);

    final tag = event.tag;
    final lat = state.lat;
    final lng = state.lng;
    try {
      final filteredRestaurants = await _restaurantApi.getRestaurantsByTag(
        tagName: tag.name,
        latitude: '$lat',
        longitude: '$lng',
      );
      final newState = state.copyWith(
        status: MainPageStatus.withFilteredRestaurants,
        filteredRestaurants: [
          ...state.filteredRestaurants,
          ...filteredRestaurants
        ],
        chosenTags: [...state.chosenTags, tag],
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
      add(const MainTestTagsFiltersReseted());
    } else {
      final loading = state.copyWith(
        status: MainPageStatus.loading,
      );
      emit(loading);

      final lat = state.lat;
      final lng = state.lng;
      try {
        final filteredRestaurants = await _restaurantApi.getRestaurantsByTag(
          tagName: tag.name,
          latitude: '$lat',
          longitude: '$lng',
        );
        logger.i(
          'Filtered restaurants: ${filteredRestaurants.map((e) => e.toMap())}',
        );
        final restaurants = state.filteredRestaurants
          ..removeWhere(
            filteredRestaurants.contains,
          );
        logger.i(
          'Restaurants after removing: ${restaurants.map((e) => e.toMap())}',
        );
        final newState = state.copyWith(
          status: MainPageStatus.withFilteredRestaurants,
          filteredRestaurants: state.filteredRestaurants
            ..removeWhere(
              filteredRestaurants.contains,
            ),
        );
        emit(newState);
      } catch (e) {
        _errorFormatter(e, emit);
      }
    }
  }

  Future<void> _onMainTestTagsFiltersReset(
    MainTestTagsFiltersReseted event,
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
    add(const MainTestRestaurantsAndTagsFetched());
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
    logger.e('Error type is: $e');
    if (e is ClientTimeoutException) {
      logger.e('Message: ${e.message}');
      emit(
        state.copyWith(
          status: MainPageStatus.outOfTime,
          errMessage: e.message,
        ),
      );
    }
    if (e is NetworkException) {
      logger.e('Message: ${e.message}');
      emit(
        state.copyWith(
          status: MainPageStatus.noInternet,
          errMessage: e.message,
        ),
      );
    }
    if (e is NoRestaurantsFoundException) {
      logger.e('Message: ${e.message}');
      emit(
        state.copyWith(
          status: MainPageStatus.empty,
          errMessage: e.message,
        ),
      );
    }
    if (e is ClientRequestFailed) {
      logger.e('Message: ${e.message}');
      emit(
        state.copyWith(
          status: MainPageStatus.clientFailure,
          errMessage: e.message,
        ),
      );
    }
    if (e is MalformedClientResponse) {
      logger.e('Message: ${e.message}');
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

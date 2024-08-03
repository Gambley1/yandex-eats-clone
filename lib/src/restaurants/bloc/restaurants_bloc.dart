import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_food_api/client.dart';

part 'restaurants_event.dart';
part 'restaurants_state.dart';

class RestaurantsBloc extends Bloc<RestaurantsEvent, RestaurantsState> {
  RestaurantsBloc({
    required RestaurantsRepository restaurantsRepository,
    required UserRepository userRepository,
  })  : _restaurantRepository = restaurantsRepository,
        _userRepository = userRepository,
        super(const RestaurantsState.initial()) {
    on<RestaurantsLocationChanged>(_onRestaurantsLocationChanged);
    on<RestaurantsFetchRequested>(_onRestaurantsFetchRequested);
    on<RestaurantsFilterTagChanged>(_onFilterTagChanged);
    on<RestaurantsFilterTagsChanged>(_onRestaurantsFilterTagsChanged);
    on<RestaurantsRefreshRequested>(_restaurantsRefreshRequested);
    on<RestaurantsFilterTagsClearRequested>(_onFilterTagsClear);
    on<_RestaurantsFilterTadAdded>(_onFilterTagAdded);
    on<_RestaurantsFilterTagRemoved>(_onFilterTagRemoved);

    _userLocationSubscription = _userRepository
        .currentLocation()
        .listen(_onLocationChanged, onError: addError);
  }

  final RestaurantsRepository _restaurantRepository;
  final UserRepository _userRepository;
  StreamSubscription<Location>? _userLocationSubscription;

  void _onLocationChanged(Location location) =>
      add(RestaurantsLocationChanged(location: location));

  void _onRestaurantsLocationChanged(
    RestaurantsLocationChanged event,
    Emitter<RestaurantsState> emit,
  ) {
    final location = event.location;
    if (state.location == location) return;
    if (location.isUndefined) return;
    emit(
      state.copyWith(
        location: location,
        filteredRestaurants: [],
        chosenTags: [],
      ),
    );
    add(const RestaurantsFetchRequested());
  }

  Future<void> _onRestaurantsFetchRequested(
    RestaurantsFetchRequested event,
    Emitter<RestaurantsState> emit,
  ) async {
    emit(state.copyWith(status: RestaurantsStatus.loading));
    try {
      final result = await Future.wait([
        _restaurantRepository.getRestaurants(location: state.location),
        _restaurantRepository.getTags(location: state.location),
      ]);
      final restaurants = _filterRestaurants(result[0] as List<Restaurant>);
      final tags = result[1] as List<Tag>;

      emit(
        state.copyWith(
          status: RestaurantsStatus.withRestaurantsAndTags,
          restaurants: restaurants,
          tags: tags,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: RestaurantsStatus.failure));
      addError(error, stackTrace);
    }
  }

  void _onFilterTagChanged(
    RestaurantsFilterTagChanged event,
    Emitter<RestaurantsState> emit,
  ) {
    final tag = event.tag;
    !state.chosenTags.contains(tag)
        ? add(_RestaurantsFilterTadAdded(tag))
        : add(_RestaurantsFilterTagRemoved(tag));
  }

  Future<void> _onRestaurantsFilterTagsChanged(
    RestaurantsFilterTagsChanged event,
    Emitter<RestaurantsState> emit,
  ) async {
    final tags = event.tags;
    emit(
      state.copyWith(
        status: RestaurantsStatus.loading,
        chosenTags: tags,
      ),
    );

    if (tags.isEmpty) {
      return add(const RestaurantsFilterTagsClearRequested());
    }

    try {
      final restaurants = await _restaurantRepository.getRestaurantsByTags(
        tags: tags.map((e) => e.name).toList(),
        location: state.location,
      );
      final filteredRestaurants = _filterRestaurants(restaurants);
      emit(
        state.copyWith(
          filteredRestaurants: filteredRestaurants,
          status: RestaurantsStatus.withFilteredRestaurants,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: RestaurantsStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onFilterTagAdded(
    _RestaurantsFilterTadAdded event,
    Emitter<RestaurantsState> emit,
  ) async {
    final tag = event.tag;
    emit(
      state.copyWith(
        status: RestaurantsStatus.loading,
        chosenTags: [...state.chosenTags, tag],
      ),
    );

    try {
      final restaurants = await _restaurantRepository.getRestaurantsByTags(
        tags: state.chosenTags.map((e) => e.name).toList(),
        location: state.location,
      );
      final filteredRestaurants = _filterRestaurants(restaurants);
      emit(
        state.copyWith(
          filteredRestaurants: filteredRestaurants,
          status: RestaurantsStatus.withFilteredRestaurants,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: RestaurantsStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onFilterTagRemoved(
    _RestaurantsFilterTagRemoved event,
    Emitter<RestaurantsState> emit,
  ) async {
    final tag = event.tag;
    emit(
      state.copyWith(
        chosenTags: [...state.chosenTags]..remove(tag),
      ),
    );
    if (state.chosenTags.isEmpty) {
      add(const RestaurantsFilterTagsClearRequested());
    } else {
      emit(state.copyWith(status: RestaurantsStatus.loading));

      try {
        final restaurants = await _restaurantRepository.getRestaurantsByTags(
          tags: state.chosenTags.map((e) => e.name).toList(),
          location: state.location,
        );
        final filteredRestaurants = _filterRestaurants(restaurants);
        emit(
          state.copyWith(
            status: RestaurantsStatus.withFilteredRestaurants,
            filteredRestaurants: filteredRestaurants,
          ),
        );
      } catch (error, stackTrace) {
        emit(state.copyWith(status: RestaurantsStatus.failure));
        addError(error, stackTrace);
      }
    }
  }

  Future<void> _onFilterTagsClear(
    RestaurantsFilterTagsClearRequested event,
    Emitter<RestaurantsState> emit,
  ) async {
    emit(state.copyWith(status: RestaurantsStatus.loading));
    await Future<void>.delayed(const Duration(seconds: 1)).whenComplete(
      () => emit(
        state.copyWith(
          filteredRestaurants: [],
          chosenTags: [],
          status: RestaurantsStatus.withRestaurantsAndTags,
        ),
      ),
    );
  }

  void _restaurantsRefreshRequested(
    RestaurantsRefreshRequested event,
    Emitter<RestaurantsState> emit,
  ) {
    state.status.isWithFilteredRestaurants
        ? add(const RestaurantsFilterTagsClearRequested())
        : add(const RestaurantsFetchRequested());
  }

  List<Restaurant> _filterRestaurants(List<Restaurant> restaurants) {
    return restaurants
      ..removeWhere(
        (restaurant) => restaurant.name == 'Ne Rabotayet',
      )
      ..removeDuplicates(
        by: (restaurant) => restaurant.name,
      )
      ..whereMoveToTheFront((restaurant) {
        final rating = restaurant.rating as double;
        return rating >= 4.8 || restaurant.userRatingsTotal >= 300;
      })
      ..whereMoveToTheEnd((restaurant) {
        if (restaurant.rating != null) {
          final rating = restaurant.rating as double;
          return rating < 4.5 || restaurant.userRatingsTotal <= 100;
        }
        return false;
      });
  }

  @override
  Future<void> close() {
    _userLocationSubscription?.cancel();
    return super.close();
  }
}

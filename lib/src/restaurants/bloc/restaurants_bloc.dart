import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_food_api/client.dart';

part 'restaurants_bloc_mixin.dart';
part 'restaurants_event.dart';
part 'restaurants_state.dart';

class RestaurantsBloc extends Bloc<RestaurantsEvent, RestaurantsState>
    with RestaurantsBlocMixin {
  RestaurantsBloc({
    required RestaurantsRepository restaurantsRepository,
    required UserRepository userRepository,
  })  : _restaurantsRepository = restaurantsRepository,
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

  final RestaurantsRepository _restaurantsRepository;
  final UserRepository _userRepository;
  StreamSubscription<Location>? _userLocationSubscription;

  @override
  RestaurantsRepository get restaurantsRepository => _restaurantsRepository;

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
    add(const RestaurantsRefreshRequested());
  }

  Future<void> _onRestaurantsFetchRequested(
    RestaurantsFetchRequested event,
    Emitter<RestaurantsState> emit,
  ) async {
    try {
      final currentPage = event.page ?? state.restaurantsPage.page;
      emit(
        state.copyWith(
          status: currentPage == 0 ? RestaurantsStatus.loading : null,
        ),
      );
      final (:newPage, :hasMore, :restaurants) =
          await fetchRestaurantsPage(page: currentPage);
      final tags = currentPage == 0
          ? await _restaurantsRepository.getTags(location: state.location)
          : null;
      final filteredRestaurants = _filterRestaurants(restaurants);

      emit(
        state.copyWith(
          tags: tags,
          status: RestaurantsStatus.populated,
          restaurantsPage: state.restaurantsPage.copyWith(
            page: newPage,
            hasMore: hasMore,
            restaurants: [
              ...state.restaurantsPage.restaurants,
              ...filteredRestaurants,
            ],
            totalRestaurants: state.restaurantsPage.totalRestaurants +
                filteredRestaurants.length,
          ),
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
      final restaurants = await _restaurantsRepository.getRestaurantsByTags(
        tags: tags.map((e) => e.name).toList(),
        location: state.location,
      );
      final filteredRestaurants = _filterRestaurants(restaurants);
      emit(
        state.copyWith(
          filteredRestaurants: filteredRestaurants,
          status: RestaurantsStatus.filtered,
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
      final restaurants = await _restaurantsRepository.getRestaurantsByTags(
        tags: state.chosenTags.map((e) => e.name).toList(),
        location: state.location,
      );
      final filteredRestaurants = _filterRestaurants(restaurants);
      emit(
        state.copyWith(
          filteredRestaurants: filteredRestaurants,
          status: RestaurantsStatus.filtered,
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
        final restaurants = await _restaurantsRepository.getRestaurantsByTags(
          tags: state.chosenTags.map((e) => e.name).toList(),
          location: state.location,
        );
        final filteredRestaurants = _filterRestaurants(restaurants);
        emit(
          state.copyWith(
            status: RestaurantsStatus.filtered,
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
          status: RestaurantsStatus.populated,
        ),
      ),
    );
  }

  Future<void> _restaurantsRefreshRequested(
    RestaurantsRefreshRequested event,
    Emitter<RestaurantsState> emit,
  ) async {
    if (state.status.isFiltered) {
      add(const RestaurantsFilterTagsClearRequested());
    }

    emit(state.copyWith(status: RestaurantsStatus.loading));
    try {
      final (:newPage, :hasMore, :restaurants) = await fetchRestaurantsPage();
      final tags =
          await _restaurantsRepository.getTags(location: state.location);
      final filteredRestaurants = _filterRestaurants(restaurants);

      emit(
        state.copyWith(
          tags: tags,
          status: RestaurantsStatus.populated,
          restaurantsPage: RestaurantsPage(
            page: newPage,
            restaurants: filteredRestaurants,
            hasMore: hasMore,
            totalRestaurants: filteredRestaurants.length,
          ),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: RestaurantsStatus.failure));
      addError(error, stackTrace);
    }
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

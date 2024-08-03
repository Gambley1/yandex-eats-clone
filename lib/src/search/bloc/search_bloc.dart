import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_food_api/client.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required UserRepository userRepository,
    required RestaurantsRepository restaurantsRepository,
  })  : _userRepository = userRepository,
        _restaurantsRepository = restaurantsRepository,
        super(const SearchState.initial()) {
    on<SearchTermChanged>(
      (event, emit) async {
        if (event.searchTerm.isEmpty) {
          return _onEmptySearchRequested(event, emit);
        }
        return _onSearchTermChanged(event, emit);
      },
    );
  }

  final UserRepository _userRepository;
  final RestaurantsRepository _restaurantsRepository;

  FutureOr<void> _onEmptySearchRequested(
    SearchTermChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        searchType: SearchType.popular,
      ),
    );
    try {
      final currentLocation = _userRepository.fetchCurrentLocation();
      final popularRestaurants =
          await _restaurantsRepository.popularSearch(location: currentLocation);
      emit(
        state.copyWith(
          restaurants: popularRestaurants,
          status: SearchStatus.populated,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SearchStatus.failure));
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onSearchTermChanged(
    SearchTermChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        searchType: SearchType.relevant,
      ),
    );
    try {
      final currentLocation = _userRepository.fetchCurrentLocation();
      final relevantRestaurants = await _restaurantsRepository.relevantSearch(
        term: event.searchTerm,
        location: currentLocation,
      );
      emit(
        state.copyWith(
          restaurants: relevantRestaurants,
          status: SearchStatus.populated,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SearchStatus.failure));
      addError(error, stackTrace);
    }
  }
}

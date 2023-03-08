import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papa_burger/src/restaurant.dart';

part 'main_page_event.dart';
part 'main_page_state.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  MainPageBloc({
    required this.api,
  }) : super(
          MainPageState(),
        ) {
    on<LoadMainPageEvent>(_onLoadMainPage);
    on<FilterRestaurantsEvent>(_onFindFilteredRestaurants);
  }

  final RestaurantApi api;

  Future<void> _onLoadMainPage(
      LoadMainPageEvent event, Emitter<MainPageState> emit) async {
    emit(
      state.copyWith(
        mainPageRequest: MainPageRequest.mainPageLoading,
      ),
    );
    try {
      final restaurants = api.getListRestaurants();
      if (restaurants.isNotEmpty) {
        emit(
          state.copyWith(
            restaurants: restaurants,
            mainPageRequest: MainPageRequest.requestSuccess,
          ),
        );
      } else {
        emit(
          state.copyWith(
            restaurants: restaurants,
            mainPageRequest: MainPageRequest.requestSuccess,
          ),
        );
      }
    } catch (_) {
      errorStateMainPage(emit);
    }
  }

  Future<void> _onFindFilteredRestaurants(
      FilterRestaurantsEvent event, Emitter<MainPageState> emit) async {
    emit(
      state.copyWith(
        mainPageRequest: MainPageRequest.filterRequestLoading,
      ),
    );
    try {
      emit(
        state.copyWith(
          filteredRestaurants: event.filteredRestaurants,
          mainPageRequest: MainPageRequest.filterRequestSucces,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          mainPageRequest: MainPageRequest.filterRequestFailure,
        ),
      );
      logger.e('error whilte finding filtered restaurants');
    }
  }

  void errorStateCart(Emitter<MainPageState> emit) {
    emit(
      state.copyWith(
        cartRequest: CartRequest.requestFailure,
      ),
    );
    logger.e('cart error occured');
  }

  void errorStateMainPage(Emitter<MainPageState> emit) {
    emit(
      state.copyWith(
        mainPageRequest: MainPageRequest.mainPageRequestFailure,
      ),
    );
    logger.e('main page error occured');
  }
}

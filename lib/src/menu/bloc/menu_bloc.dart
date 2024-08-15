import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:yandex_food_api/client.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({
    required Restaurant restaurant,
    required RestaurantsRepository restaurantsRepository,
  })  : _restaurant = restaurant,
        _restaurantsRepository = restaurantsRepository,
        super(MenuState.initial(restaurant: restaurant)) {
    on<MenuFetchRequested>(_onFetchRequested);
  }

  final Restaurant _restaurant;
  final RestaurantsRepository _restaurantsRepository;

  Future<void> _onFetchRequested(
    MenuFetchRequested event,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      final menus = await _restaurantsRepository.getMenu(
        placeId: _restaurant.placeId,
      );

      emit(
        state.copyWith(
          status: MenuStatus.populated,
          menus: menus,
          restaurant: _restaurant,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MenuStatus.failure));
      addError(error, stackTrace);
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:yandex_food_api/client.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({
    required RestaurantsRepository restaurantsRepository,
  })  : _restaurantsRepository = restaurantsRepository,
        super(const MenuState.initial()) {
    on<MenuFetchRequested>(_onMenuFetchRequested);
  }

  final RestaurantsRepository _restaurantsRepository;

  Future<void> _onMenuFetchRequested(
    MenuFetchRequested event,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      final menus = await _restaurantsRepository.getMenu(
        placeId: event.restaurant.placeId,
      );

      emit(
        state.copyWith(
          status: MenuStatus.populated,
          menus: menus,
          restaurant: event.restaurant,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: MenuStatus.failure));
      addError(error, stackTrace);
    }
  }
}

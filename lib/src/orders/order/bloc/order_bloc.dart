import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:orders_repository/orders_repository.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_food_api/client.dart';

part 'order_bloc.g.dart';
part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends HydratedBloc<OrderEvent, OrderState> {
  OrderBloc({
    required String orderId,
    required OrdersRepository ordersRepository,
    required RestaurantsRepository restaurantsRepository,
    required UserRepository userRepository,
  })  : _orderId = orderId,
        _ordersRepository = ordersRepository,
        _restaurantsRepository = restaurantsRepository,
        _userRepository = userRepository,
        super(const OrderState.initial()) {
    on<OrderFetchRequested>(_onOrderFetchRequested);
    on<OrderDeleteRequested>(_onOrderDeleteRequested);
  }

  final String _orderId;
  final OrdersRepository _ordersRepository;
  final RestaurantsRepository _restaurantsRepository;
  final UserRepository _userRepository;

  @override
  String get id => _orderId;

  Future<void> _onOrderFetchRequested(
    OrderFetchRequested event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));
      final order = await _ordersRepository.getOrder(id: id);
      if (order == null) {
        return emit(state.copyWith(status: OrderStatus.success, order: order));
      }
      emit(
        state.copyWith(
          status: OrderStatus.success,
          order: order,
        ),
      );
      final userLocation = _userRepository.fetchCurrentLocation();
      final restaurant = await _restaurantsRepository.getRestaurant(
        id: order.restaurantPlaceId,
        location: Location(lat: userLocation.lat, lng: userLocation.lng),
      );

      emit(state.copyWith(restaurant: restaurant));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: OrderStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onOrderDeleteRequested(
    OrderDeleteRequested event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await _ordersRepository.deleteOrder(id: id);
      emit(state.copyWith(status: OrderStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: OrderStatus.failure));
      addError(error, stackTrace);
    }
  }

  @override
  OrderState? fromJson(Map<String, dynamic> json) => OrderState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(OrderState state) => state.toJson();
}

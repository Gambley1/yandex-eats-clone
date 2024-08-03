import 'dart:async';
import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:orders_repository/orders_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_food_api/client.dart';

part 'orders_bloc.g.dart';
part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends HydratedBloc<OrdersEvent, OrdersState> {
  OrdersBloc({
    required UserRepository userRepository,
    required OrdersRepository ordersRepository,
  })  : _userRepository = userRepository,
        _ordersRepository = ordersRepository,
        super(const OrdersState.initial()) {
    on<OrdersFetchRequested>(_onOrdersFetchRequested, transformer: droppable());
    on<OrdersRefresRequested>(_onOrdersRefresRequested);
    on<OrdersDeleteOrderRequested>(
      _onOrdersDeleteOrderRequested,
      transformer: droppable(),
    );

    _ordersStatusSubscription = _ordersRepository
        .ordersStatusChanges()
        .listen(_onOrderStatusChanged, onError: addError);
  }

  final UserRepository _userRepository;
  final OrdersRepository _ordersRepository;
  StreamSubscription<String>? _ordersStatusSubscription;

  Future<void> _onOrderStatusChanged(String jsonMessage) async {
    final user = await _userRepository.user.first;
    if (user.isAnonymous) return;

    final message = jsonDecode(jsonMessage) as List;
    final userId = message[2] as String;
    if (user.id != userId) return;

    final status = message[0] as String;
    final orderId = message[1];
    await _ordersRepository.sendUserNotification(
      orderId: '$orderId',
      status: OrderStatus.fromJson(status),
    );
    // add(const OrdersFetchRequested());
  }

  Future<void> _onOrdersFetchRequested(
    OrdersFetchRequested event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      emit(state.copyWith(status: OrdersStatus.loading));
      final orders = await _ordersRepository.getOrders();
      emit(
        state.copyWith(
          status: OrdersStatus.success,
          orders: orders,
          hasPendingOrders:
              orders.any((order) => order.status == OrderStatus.pending),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: OrdersStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onOrdersRefresRequested(
    OrdersRefresRequested event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      emit(state.copyWith(status: OrdersStatus.loading));
      final orders = await _ordersRepository.getOrders();
      emit(
        state.copyWith(
          status: OrdersStatus.success,
          orders: orders,
          hasPendingOrders:
              orders.any((order) => order.status == OrderStatus.pending),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: OrdersStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onOrdersDeleteOrderRequested(
    OrdersDeleteOrderRequested event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      await _ordersRepository.deleteOrder(id: event.orderId);
      emit(state.copyWith(status: OrdersStatus.loading));
      emit(state.copyWith(status: OrdersStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: OrdersStatus.failure));
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _ordersStatusSubscription?.cancel();
    return super.close();
  }

  @override
  OrdersState? fromJson(Map<String, dynamic> json) =>
      OrdersState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(OrdersState state) => state.toJson();
}

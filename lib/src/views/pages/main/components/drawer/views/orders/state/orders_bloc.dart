import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/services/repositories/orders/orders_repository.dart';
import 'package:papa_burger/src/services/storage/storage.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc({OrdersRepository? ordersRepository})
      : _ordersRepository = ordersRepository ?? OrdersRepository(),
        super(const OrdersState.initial()) {
    on<OrdersStarted>(_onOrdersStarted);
    on<OrdersFetched>(_onOrdersFetched);
    on<OrdersCreateOrder>(_onOrdersCreateOrder);
    on<_OrdersChanged>(_onOrdersChanged);
  }

  final OrdersRepository _ordersRepository;
  StreamSubscription<dynamic>? _ordersChangedSubscription;

  void _onOrdersStarted(OrdersStarted event, Emitter<OrdersState> emit) {
    _ordersChangedSubscription =
        _ordersRepository.orderStatusChangedMessages.listen((message) async {
      final localStorage = LocalStorage();
      final uid = localStorage.getToken;
      final list = jsonDecode(message) as List;
      final userUid = list[2];
      if (uid != userUid) {
        return;
      } else {
        final status = list[0] as String;
        final orderId = list[1];
        await _ordersRepository.sendUserNotification(
          uid,
          orderId: '$orderId',
          status: status,
        );
        add(const _OrdersChanged());
      }
    });
  }

  Future<void> _onOrdersFetched(
    OrdersFetched event,
    Emitter<OrdersState> emit,
  ) async {
    final loading = state.copyWith(
      status: OrdersStatus.loading,
    );
    emit(loading);
    try {
      final uid = LocalStorage().getToken;
      final orders = await _ordersRepository.getListOrderDetails(uid);
      if (state.orders.deepEquals(orders, ignoreOrder: true)) {
        final newState = state.copyWith(
          status: OrdersStatus.success,
        );
        emit(newState);
      } else {
        final newState = state.copyWith(
          status: OrdersStatus.success,
          orders: orders,
        );
        emit(newState);
      }
    } catch (e) {
      _errorFormatter(e, emit);
    }
  }

  Future<void> _onOrdersCreateOrder(
    OrdersCreateOrder event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final uid = LocalStorage().getToken;
      final message = await _ordersRepository.createOrder(
        uid,
        id: event.id,
        date: event.date,
        restaurantPlaceId: event.restaurantPlaceId,
        restaurantName: event.restaurantName,
        orderAddress: event.orderAddress,
        totalOrderSum: event.totalOrderSum,
        orderDeliveryFee: event.orderDeliveryFee,
      );
      final newState = state.copyWith(
        status: OrdersStatus.successfullyCreated,
        successMessage: message,
      );
      emit(newState);
    } catch (e) {
      _errorFormatter(e, emit);
    }
  }

  Future<void> _onOrdersChanged(
    _OrdersChanged event,
    Emitter<OrdersState> emit,
  ) async {
    add(const OrdersFetched());
  }

  void _errorFormatter(Object? e, Emitter<OrdersState> emit) {
    var newState = state;
    if (e is ClientRequestFailed) {
      newState = state.copyWith(
        status: OrdersStatus.clientFailure,
        errMessage: e.message,
      );
    }
    if (e is MalformedClientResponse) {
      newState = state.copyWith(
        status: OrdersStatus.malformedResponse,
        errMessage: e.message,
      );
    }
    if (e is NetworkException) {
      newState = state.copyWith(
        status: OrdersStatus.noInternet,
        errMessage: e.message,
      );
    }
    if (e is InvalidCreateUserOrderParametersException) {
      newState = state.copyWith(
        status: OrdersStatus.createOrderInvalidParameters,
        errMessage: e.message,
      );
    }
    if (e is OrderDetailsNotFoundException) {
      newState = state.copyWith(
        status: OrdersStatus.createOrderOrderDetailsNotFound,
        errMessage: e.message,
      );
    }
    emit(newState);
  }

  @override
  Future<void> close() {
    _ordersChangedSubscription?.cancel();
    return super.close();
  }
}

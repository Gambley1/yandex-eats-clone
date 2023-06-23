part of 'orders_bloc.dart';

enum OrdersStatus {
  loading,
  success,
  successfulyCreated,
  successfulyDeleted,
  idle,
  noInternet,
  clientFailure,
  createOrderInvalidParameters,
  createOrderOrderDetailsNotFound,
  malformedResponse,
}

class OrdersState extends Equatable {
  const OrdersState._({
    this.status = OrdersStatus.idle,
    this.orders = const [],
    this.errMessage = '',
    this.successMessage = '',
  });

  const OrdersState.initial() : this._();

  final OrdersStatus status;
  final List<OrderDetails> orders;
  final String errMessage;
  final String successMessage;

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderDetails>? orders,
    String? errMessage,
    String? successMessage,
  }) =>
      OrdersState._(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        errMessage: errMessage ?? this.errMessage,
        successMessage: successMessage ?? this.successMessage,
      );

  @override
  List<Object> get props => [
        status,
        orders,
      ];
}

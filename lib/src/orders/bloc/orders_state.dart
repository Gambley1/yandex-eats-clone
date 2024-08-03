// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'orders_bloc.dart';

enum OrdersStatus {
  initial,
  loading,
  success,
  failure;

  bool get isError => this == OrdersStatus.failure;
  bool get isLoading => this == OrdersStatus.loading;
}

@JsonSerializable()
class OrdersState extends Equatable {
  const OrdersState({
    required this.orders,
    required this.hasPendingOrders,
    this.status = OrdersStatus.initial,
  });

  factory OrdersState.fromJson(Map<String, dynamic> json) =>
      _$OrdersStateFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersStateToJson(this);

  const OrdersState.initial() : this(orders: const [], hasPendingOrders: true);

  @JsonKey(includeFromJson: false, includeToJson: false)
  final OrdersStatus status;
  final List<Order> orders;
  final bool hasPendingOrders;

  @override
  List<Object?> get props => [status, orders, hasPendingOrders];

  OrdersState copyWith({
    OrdersStatus? status,
    List<Order>? orders,
    bool? hasPendingOrders,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      hasPendingOrders: hasPendingOrders ?? this.hasPendingOrders,
    );
  }
}

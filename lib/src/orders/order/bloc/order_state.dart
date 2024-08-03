part of 'order_bloc.dart';

enum OrderStatus {
  initial,
  loading,
  success,
  failure;

  bool get isError => this == OrderStatus.failure;
  bool get isLoading => this == OrderStatus.loading;
}

@JsonSerializable()
class OrderState extends Equatable {
  const OrderState({
    required this.order,
    required this.restaurant,
    this.status = OrderStatus.initial,
  });

  const OrderState.initial() : this(order: null, restaurant: null);

  factory OrderState.fromJson(Map<String, dynamic> json) =>
      _$OrderStateFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStateToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  final OrderStatus status;
  final Order? order;
  final Restaurant? restaurant;

  @override
  List<Object?> get props => [status, order, restaurant];

  OrderState copyWith({
    OrderStatus? status,
    Order? order,
    Restaurant? restaurant,
  }) {
    return OrderState(
      status: status ?? this.status,
      order: order ?? this.order,
      restaurant: restaurant ?? this.restaurant,
    );
  }
}

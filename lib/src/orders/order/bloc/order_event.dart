part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

final class OrderFetchRequested extends OrderEvent {
  const OrderFetchRequested();
}

final class OrderDeleteRequested extends OrderEvent {
  const OrderDeleteRequested();
}

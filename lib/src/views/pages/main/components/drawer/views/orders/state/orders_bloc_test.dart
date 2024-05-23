import 'package:papa_burger/src/services/network/notification_service.dart';
import 'package:papa_burger/src/services/repositories/orders/orders_repository.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_result.dart';
import 'package:papa_burger/src/views/pages/main/state/main_bloc.dart';
import 'package:rxdart/rxdart.dart'
    show
        BehaviorSubject,
        OnErrorExtensions,
        Rx,
        StartWithExtension,
        SwitchMapExtension;
import 'package:shared/shared.dart';

typedef OrderId = String;

class OrdersBlocTest {
  OrdersBlocTest({
    OrdersRepository? ordersRepository,
    MainBloc? mainBloc,
  })  : _ordersRepository = ordersRepository ?? OrdersRepository(),
        _mainBloc = mainBloc ?? MainBloc();

  final MainBloc _mainBloc;
  final OrdersRepository _ordersRepository;

  final _ordersSubject = BehaviorSubject<List<OrderDetails>>.seeded([]);
  final _orderDetailsSubject = BehaviorSubject<OrderId>();

  Stream<OrdersResult> get orders {
    return _ordersSubject.distinct().switchMap<OrdersResult>((listOrders) {
      return Rx.fromCallable(getListOrderDetails)
          .map((newOrders) {
            if (newOrders.isEmpty) return const OrdersWithNoResult();
            return OrdersWithListResult(newOrders);
          })
          .startWith(const OrdersLoading())
          .onErrorReturnWith((error, stackTrace) {
            logE(stackTrace);
            return OrdersError(error);
          });
    });
  }

  Stream<OrdersResult> get orderDetails {
    return _orderDetailsSubject.distinct().switchMap((orderId) {
      return Rx.fromCallable(() => getOrderDetails(orderId))
          .map((orderDetails) {
            if (orderDetails.orderMenuItems.isEmpty) {
              return const OrdersWithNoResult();
            }
            return OrdersWithDetailsResult(orderDetails);
          })
          .startWith(const OrdersLoading())
          .onErrorReturnWith((error, stackTrace) {
            logE(stackTrace);
            return OrdersError(error);
          });
    });
  }

  Restaurant getOrderDetailsRestaurant(String restaurantPlaceId) {
    try {
      return _mainBloc.allRestaurants
          .firstWhere((element) => element.placeId == restaurantPlaceId);
    } catch (e) {
      throw NoSuchRestaurantException(
        "Couldn't find restaurant.",
      );
    }
  }

  Future<String> createOrder(
    String id,
    String date,
    String restaurantPlaceId,
    String restaurantName,
    String orderAddress,
    String totalOrderSum,
    String orderDeliveryFee,
    String deliveryDate,
  ) async {
    final uid = LocalStorage().getToken;
    final message = await _ordersRepository.createOrder(
      uid,
      id: id,
      date: date,
      restaurantPlaceId: restaurantPlaceId,
      restaurantName: restaurantName,
      orderAddress: orderAddress,
      totalOrderSum: totalOrderSum,
      orderDeliveryFee: orderDeliveryFee,
    );
    await NotificationService.showOngoingOrderNotification(deliveryDate, id);
    return message;
  }

  Future<String> deleteOrder(
    String orderId,
  ) async {
    final uid = LocalStorage().getToken;
    final message = await _ordersRepository.deleteOrderDetails(
      uid,
      orderId: orderId,
    );
    _ordersSubject.add([]);
    return message;
  }

  Future<List<OrderDetails>> getListOrderDetails() async {
    final uid = LocalStorage().getToken;
    final listOrderDetails = await _ordersRepository.getListOrderDetails(uid);
    return listOrderDetails;
  }

  Future<OrderDetails> getOrderDetails(
    String orderId,
  ) async {
    final uid = LocalStorage().getToken;
    final orderDetails =
        await _ordersRepository.getOrderDetails(uid, orderId: orderId);
    return orderDetails;
  }

  void get tryGetOrdersAgain {
    _ordersSubject.add([]);
  }

  void tryGetOrderDetailsAgain(OrderId orderId) {
    _orderDetailsSubject.add(orderId);
  }

  void fetchOrderDetails(OrderId orderId) {
    _orderDetailsSubject.add(orderId);
  }
}

import 'package:papa_burger/src/models/exceptions.dart';
import 'package:papa_burger/src/models/order/order_details.dart';
import 'package:papa_burger/src/models/restaurant/restaurant.dart';
import 'package:papa_burger/src/restaurant.dart'
    show LocalStorage, MainBloc, logger;
import 'package:papa_burger/src/services/repositories/orders/orders_repository.dart';
import 'package:papa_burger/src/views/pages/main_page/components/drawer/views/orders/state/orders_result.dart';
import 'package:rxdart/rxdart.dart'
    show
        BehaviorSubject,
        OnErrorExtensions,
        Rx,
        StartWithExtension,
        SwitchMapExtension;

typedef OrderId = String;

class OrdersBloc {
  OrdersBloc({
    OrdersRepository? ordersRepository,
    LocalStorage? localStorage,
    MainBloc? mainBloc,
  })  : _ordersRepository = ordersRepository ?? OrdersRepository(),
        _localStorage = localStorage ?? LocalStorage.instance,
        _mainBloc = mainBloc ?? MainBloc();

  final MainBloc _mainBloc;
  final OrdersRepository _ordersRepository;
  final LocalStorage _localStorage;

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
            logger.e(stackTrace);
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
            logger.e(stackTrace);
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
    String totalOrderSumm,
    String orderDeliveryFee,
  ) async {
    final uid = _localStorage.getToken;
    final message = await _ordersRepository.createOrder(
      uid,
      id: id,
      date: date,
      restaurantPlaceId: restaurantPlaceId,
      restaurantName: restaurantName,
      orderAddress: orderAddress,
      totalOrderSumm: totalOrderSumm,
      orderDeliveryFee: orderDeliveryFee,
    );
    return message;
  }

  Future<String> deleteOrder(
    String orderId,
  ) async {
    final uid = _localStorage.getToken;
    final message = await _ordersRepository.deleteOrderDetails(
      uid,
      orderId: orderId,
    );
    _ordersSubject.add([]);
    return message;
  }

  Future<List<OrderDetails>> getListOrderDetails() async {
    final uid = _localStorage.getToken;
    final listOrderDetails = await _ordersRepository.getListOrderDetails(uid);
    return listOrderDetails;
  }

  Future<OrderDetails> getOrderDetails(
    String orderId,
  ) async {
    final uid = _localStorage.getToken;
    final orderDetails =
        await _ordersRepository.getOrderDetails(uid, orderId: orderId);
    return orderDetails;
  }

  void get tryGetOrdersAgain {
    _ordersSubject.add([]);
  }

  void tryGetOrderDetailsAgain(OrderId orderId) {
    logger.i('Try get order details again by id: $orderId');
    _orderDetailsSubject.add(orderId);
  }

  void fetchOrderDetails(OrderId orderId) {
    _orderDetailsSubject.add(orderId);
  }
}

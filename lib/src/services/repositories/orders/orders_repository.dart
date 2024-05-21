import 'package:papa_burger/src/models/order_details.dart';
import 'package:papa_burger/src/services/network/api/orders_api.dart';
import 'package:papa_burger/src/services/repositories/orders/base_orders_repository.dart';
import 'package:papa_burger/src/views/pages/cart/state/cart_bloc.dart';
import 'package:web_socket_client/web_socket_client.dart';

class OrdersRepository implements BaseOrdersRepository {
  OrdersRepository({
    OrdersApi? ordersApi,
    CartBloc? cartBloc,
  })  : _ordersApi = ordersApi ?? OrdersApi(),
        _cartBloc = cartBloc ?? CartBloc();

  final OrdersApi _ordersApi;
  final CartBloc _cartBloc;
  final WebSocket _wsOrderStatusChanged = WebSocket(
    // Uri.parse(
    //   DotEnvConfig.webSocketOrderStatusChanged,
    // ),
    Uri.parse('uri'),
  );

  Stream<String> get orderStatusChangedMessages =>
      _wsOrderStatusChanged.messages.cast<String>();

  void get closeOrderStatusChanged => _wsOrderStatusChanged.close();

  Future<String> sendUserNotification(
    String uid, {
    required String orderId,
    required String status,
  }) async =>
      _ordersApi.sendUserNotification(
        uid,
        orderId: orderId,
        status: status,
      );

  @override
  Future<String> createOrder(
    String uid, {
    required String id,
    required String date,
    required String restaurantPlaceId,
    required String restaurantName,
    required String orderAddress,
    required String totalOrderSum,
    required String orderDeliveryFee,
  }) async {
    await _ordersApi
        .createOrder(
      uid,
      id: id,
      date: date,
      restaurantPlaceId: restaurantPlaceId,
      restaurantName: restaurantName,
      orderAddress: orderAddress,
      totalOrderSum: totalOrderSum,
      orderDeliveryFee: orderDeliveryFee,
    )
        .then((id) async {
      if (id is! Exception) {
        final cart = _cartBloc.value;
        final cartItems = cart.items.toList();

        for (final item in cartItems) {
          final name = item.name;
          final quantity = cart.quantity(item);
          final price = item.price * quantity;
          final imageUrl = item.imageUrl;
          final orderDetailsId = id;
          await addOrderMenuItem(
            uid,
            name: name,
            quantity: '$quantity',
            price: '$price',
            imageUrl: imageUrl,
            orderDetailsId: orderDetailsId,
          );
        }
      }
    });
    return 'Successfully created order!';
  }

  @override
  Future<String> deleteOrderDetails(
    String uid, {
    required String orderId,
  }) async {
    await deleteOrderMenuItems(uid, orderDetailsId: orderId).then(
      (value) => _ordersApi.deleteOrderDetails(uid, orderId: orderId),
    );
    return 'Successfully deleted order.';
  }

  @override
  Future<List<OrderDetails>> getListOrderDetails(
    String uid, {
    String getIdentifier = 'list',
  }) {
    return _ordersApi.getListOrderDetails(uid, getIdentifier: getIdentifier);
  }

  @override
  Future<OrderDetails> getOrderDetails(
    String uid, {
    required String orderId,
    String getIdentifier = 'single',
  }) {
    return _ordersApi.getOrderDetails(
      uid,
      orderId: orderId,
      getIdentifier: getIdentifier,
    );
  }

  @override
  Future<String> updateOrderDetails(
    String uid, {
    required String id,
    String? status,
    String? date,
    String? restaurantPlaceId,
    String? restaurantName,
    String? orderAddress,
    String? totalOrderSum,
    String? orderDeliveryFee,
  }) {
    return _ordersApi.updateOrderDetails(
      uid,
      id: id,
      status: status,
      date: date,
      restaurantPlaceId: restaurantPlaceId,
      restaurantName: restaurantName,
      orderAddress: orderAddress,
      totalOrderSum: totalOrderSum,
      orderDeliveryFee: orderDeliveryFee,
    );
  }

  @override
  Future<String> addOrderMenuItem(
    String uid, {
    required String name,
    required String quantity,
    required String price,
    required String imageUrl,
    required String orderDetailsId,
  }) {
    return _ordersApi.addOrderMenuItem(
      uid,
      name: name,
      quantity: quantity,
      price: price,
      imageUrl: imageUrl,
      orderDetailsId: orderDetailsId,
    );
  }

  @override
  Future<String> deleteOrderMenuItems(
    String uid, {
    required String orderDetailsId,
  }) {
    return _ordersApi.deleteOrderMenuItems(uid, orderDetailsId: orderDetailsId);
  }
}

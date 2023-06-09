import 'package:papa_burger/src/models/order/order_details.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:papa_burger/src/services/network/api/orders_api.dart';
import 'package:papa_burger/src/services/repositories/orders/base_orders_repository.dart';

class OrdersRepository implements BaseOrdersRepository {
  OrdersRepository({
    OrdersApi? ordersApi,
    CartBlocTest? cartBloc,
  })  : _ordersApi = ordersApi ?? OrdersApi(),
        _cartBloc = cartBloc ?? CartBlocTest();

  final OrdersApi _ordersApi;
  final CartBlocTest _cartBloc;

  @override
  Future<String> createOrder(
    String uid, {
    required String id,
    required String date,
    required String restaurantPlaceId,
    required String restaurantName,
    required String orderAddress,
    required String totalOrderSumm,
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
      totalOrderSumm: totalOrderSumm,
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
    return 'Successfuly created order!';
  }

  @override
  Future<String> deleteOrderDetails(
    String uid, {
    required String orderId,
  }) async {
    await deleteOrderMenuItems(uid, orderDetailsId: orderId).then(
      (value) => _ordersApi.deleteOrderDetails(uid, orderId: orderId),
    );
    return 'Successfuly deleted order.';
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
    String? totalOrderSumm,
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
      totalOrderSumm: totalOrderSumm,
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

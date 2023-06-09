import 'package:papa_burger/src/models/order/order_details.dart';

abstract class BaseOrdersRepository {
  Future<String> createOrder(
    String uid, {
    required String id,
    required String date,
    required String restaurantPlaceId,
    required String restaurantName,
    required String orderAddress,
    required String totalOrderSumm,
    required String orderDeliveryFee,
  });

  Future<List<OrderDetails>> getListOrderDetails(
    String uid, {
    String getIdentifier = 'list',
  });

  Future<OrderDetails> getOrderDetails(
    String uid, {
    required String orderId,
    String getIdentifier = 'single',
  });

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
  });

  Future<String> deleteOrderDetails(
    String uid, {
    required String orderId,
  });

  Future<String> addOrderMenuItem(
    String uid, {
    required String name,
    required String quantity,
    required String price,
    required String imageUrl,
    required String orderDetailsId,
  });

  Future<String> deleteOrderMenuItems(
    String uid, {
    required String orderDetailsId,
  });
}

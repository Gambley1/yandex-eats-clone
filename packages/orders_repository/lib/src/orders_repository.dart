// ignore_for_file: public_member_api_docs

import 'package:shared/shared.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:yandex_food_api/client.dart';

/// {@template orders_exception}
/// Exceptions from orders repository.
/// {@endtemplate}
abstract class OrdersException implements Exception {
  /// {@macro orders_exception}
  const OrdersException(this.error);

  /// The error which was caught.
  final Object error;

  @override
  String toString() => 'Orders exception error: $error';
}

/// {@template send_user_notification_failure}
/// Thrown during the send notification to user if a failure occurs.
/// {@endtemplate}
class SendUserNotificationFailure extends OrdersException {
  /// {@macro send_user_notification_failure}
  const SendUserNotificationFailure(super.error);
}

/// {@template create_order_failure}
/// Thrown during the create of order if a failure occurs.
/// {@endtemplate}
class CreateOrderFailure extends OrdersException {
  /// {@macro create_order_failure}
  const CreateOrderFailure(super.error);
}

/// {@template delete_order_failure}
/// Thrown during the delete of order if a failure occurs.
/// {@endtemplate}
class DeleteOrderFailure extends OrdersException {
  /// {@macro delete_order_failure}
  const DeleteOrderFailure(super.error);
}

/// {@template get_orders_failure}
/// Thrown during the get of orders if a failure occurs.
/// {@endtemplate}
class GetOrdersFailure extends OrdersException {
  /// {@macro get_orders_failure}
  const GetOrdersFailure(super.error);
}

/// {@template get_order_failure}
/// Thrown during the get of order if a failure occurs.
/// {@endtemplate}
class GetOrderFailure extends OrdersException {
  /// {@macro get_order_failure}
  const GetOrderFailure(super.error);
}

/// {@template update_order_failure}
/// Thrown during the update of order details if a failure occurs.
/// {@endtemplate}
class UpdateOrderFailure extends OrdersException {
  /// {@macro update_order_failure}
  const UpdateOrderFailure(super.error);
}

/// {@template add_order_menu_item_failure}
/// Thrown during the add of order menu item if a failure occurs.
/// {@endtemplate}
class AddOrderMenuItemFailure extends OrdersException {
  /// {@macro add_order_menu_item_failure}
  const AddOrderMenuItemFailure(super.error);
}

/// {@template delete_order_menu_items_failure}
/// Thrown during the delete of order menu items if a failure occurs.
/// {@endtemplate}
class DeleteOrderMenuItemsFailure extends OrdersException {
  /// {@macro delete_order_menu_items_failure}
  const DeleteOrderMenuItemsFailure(super.error);
}

/// {@template orders_repository}
/// A repository that manages orders.
/// {@endtemplate}
class OrdersRepository {
  /// {@macro orders_repository}
  const OrdersRepository({
    required YandexFoodApiClient apiClient,
    required BackgroundTimer backgroundTimer,
    required WebSocket wsOrdersStatus,
  })  : _apiClient = apiClient,
        _backgroundTimer = backgroundTimer,
        _wsOrdersStatus = wsOrdersStatus;

  final YandexFoodApiClient _apiClient;
  final BackgroundTimer _backgroundTimer;
  final WebSocket _wsOrdersStatus;

  Stream<String> ordersStatusChanges() =>
      _wsOrdersStatus.messages.cast<String>();

  void closeOrdersStatusWs() => _wsOrdersStatus.close();

  Future<void> sendUserNotification({
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      String notificationMessage;
      if (status == OrderStatus.completed) {
        notificationMessage =
            'Your order №$orderId has been delivered! Check it out '
            'in your orders.';
      } else {
        notificationMessage =
            'Your order №$orderId has been canceled! Please contact '
            'emilzulufov.commercial@gmail.com if it was canceled by an '
            'accident.';
      }
      return await _apiClient.sendNotification(message: notificationMessage);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SendUserNotificationFailure(error), stackTrace);
    }
  }

  Future<String> createOrder({
    required String createdAt,
    required String restaurantPlaceId,
    required String restaurantName,
    required String orderAddress,
    required String totalOrderSum,
    required String orderDeliveryFee,
  }) async {
    try {
      final orderId = await _apiClient.createOrder(
        createdAt: createdAt,
        restaurantPlaceId: restaurantPlaceId,
        restaurantName: restaurantName,
        orderAddress: orderAddress,
        totalOrderSum: totalOrderSum,
        orderDeliveryFee: orderDeliveryFee,
      );
      await _backgroundTimer.startTimer(orderId: orderId);
      return orderId;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(CreateOrderFailure(error), stackTrace);
    }
  }

  Future<void> deleteOrder({
    required String id,
  }) async {
    try {
      return await _apiClient.deleteOrder(id: id);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteOrderFailure(error), stackTrace);
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      return await _apiClient.getOrders();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetOrdersFailure(error), stackTrace);
    }
  }

  Future<Order?> getOrder({required String id}) async {
    try {
      return await _apiClient.getOrder(id: id);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetOrderFailure(error), stackTrace);
    }
  }

  Future<void> updateOrderDetails({
    required String id,
    String? status,
    String? date,
    String? restaurantPlaceId,
    String? restaurantName,
    String? orderAddress,
    String? totalOrderSum,
    String? orderDeliveryFee,
  }) async {
    try {
      return await _apiClient.updateOrder(
        id: id,
        status: status,
        date: date,
        restaurantPlaceId: restaurantPlaceId,
        restaurantName: restaurantName,
        orderAddress: orderAddress,
        totalOrderSum: totalOrderSum,
        orderDeliveryFee: orderDeliveryFee,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UpdateOrderFailure(error), stackTrace);
    }
  }

  Future<void> addOrderMenuItem({
    required String name,
    required String quantity,
    required String price,
    required String imageUrl,
    required String orderId,
  }) async {
    try {
      return await _apiClient.addOrderMenuItem(
        orderId: orderId,
        name: name,
        quantity: quantity,
        price: price,
        imageUrl: imageUrl,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AddOrderMenuItemFailure(error), stackTrace);
    }
  }

  Future<void> deleteOrderMenuItems({
    required String orderId,
  }) async {
    try {
      return await _apiClient.deleteOrderMenuItems(orderId: orderId);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteOrderMenuItemsFailure(error), stackTrace);
    }
  }
}

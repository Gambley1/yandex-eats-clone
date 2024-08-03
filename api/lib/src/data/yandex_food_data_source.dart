import 'package:yandex_food_api/api.dart';

abstract class YandexFoodDataSource {
  /// Get all restaurants from database
  Future<List<Restaurant>> getRestaurantsByLocation({
    required Location location,
  });

  /// Get restaurant by place id from database
  Future<Restaurant> getRestaurantById({
    required String id,
    Location? location,
  });

  /// Adds restaurant to database.
  Future<void> addRestaurant({
    required String id,
    required String name,
    required double rating,
    required int userRatingsTotal,
    required Location location,
    String tags = 'Fast Food',
    String imageUrl = '',
  });

  /// Updates restaurant in database.
  Future<void> updateRestaurant({
    required String id,
    String? name,
    double? rating,
    int? userRatingsTotal,
    Location? location,
    String? tags,
    String? imageUrl,
  });

  /// Deletes restaurant from database.
  Future<void> deleteRestaurant({required String id});

  /// Get popular restaurants by location.
  Future<List<Restaurant>> getPopularRestaurantsByLocation({
    required Location location,
  });

  /// Get restaurants by search query from local
  Future<List<Restaurant>> searchRestaurants({
    required String name,
    required Location location,
  });

  /// Get restaurants by tag from local
  Future<List<Restaurant>> getRestaurantsByTags({
    required List<String> tags,
    required Location location,
  });

  /// Get restaurants tags.
  Future<List<Tag>> getRestaurantsTags({required Location location});

  /// Get restaurant menu by place id
  Future<List<Menu>> getMenu({required String id});

  /// Get list user credit cards with associated user id
  Future<List<CreditCard>> getCreditCards();

  /// Create user credit card by user id, number, expiry date and cvv code
  Future<void> addCreditCard({
    required String number,
    required String expiryDate,
    required String cvv,
  });

  /// Update user credit card by number with associated user id
  Future<void> updateCreditCard({
    required String number,
    String? cvv,
    String? expiryDate,
  });

  /// Delete user credit card by number with associated user id
  Future<void> deleteCreditCard({required String number});

  /// Create user order with associated user id by order id, status, data time,
  /// restaurant place id, restaurant name, order address, total order sum and
  /// order delivery fee
  Future<String> createOrder({
    required String status,
    required String date,
    required String restaurantPlaceId,
    required String restaurantName,
    required String orderAddress,
    required String totalOrderSum,
    required String orderDeliveryFee,
  });

  /// Get orders of current user.
  Future<List<Order>> getOrders();

  /// Get order details with associated user id by order id.
  Future<Order> getOrder({required String id});

  /// Update order details with associated user id by required id and optional
  /// order id, status, date, restaurant place id, restaurant name,
  /// order address, total order sum and order delivery fee
  Future<void> updateOrder({
    required String id,
    String? status,
    String? date,
    String? restaurantPlaceId,
    String? restaurantName,
    String? orderAddress,
    String? totalOrderSum,
    String? orderDeliveryFee,
  });

  /// Delete order details with associated user id by order id
  Future<void> deleteOrder({required String id});

  /// Add order menu item into order details by name, quantity, price, image url
  /// and order details id
  Future<void> addOrderMenuItem({
    required String orderId,
    required String name,
    required String quantity,
    required String price,
    required String imageUrl,
  });

  /// Delete order menu items from order details with associated user id by
  /// order details id
  Future<void> deleteOrderMenuItems({required String id});

  /// Send user notification to the PostgreSQL database
  Future<void> sendNotification({required String message});

  /// Get list user notifications by associated user id
  Future<List<Notification>> getNotifications();
}

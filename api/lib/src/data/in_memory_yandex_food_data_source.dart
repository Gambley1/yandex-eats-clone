import 'package:yandex_food_api/api.dart';

class InMemoryYandexFoodDataSource extends YandexFoodDataSource {
  @override
  Future<List<Restaurant>> getRestaurantsByLocation({
    required Location location,
  }) async {
    final allRestaurants = FakeRestaurants.getAllRestaurants;
    return allRestaurants;
  }

  @override
  Future<List<Restaurant>> getPopularRestaurantsByLocation({
    required Location location,
  }) async {
    final popularRestaurants = FakeRestaurants.getPopularRestaurants;
    return popularRestaurants;
  }

  @override
  Future<List<Restaurant>> searchRestaurants({
    required String name,
    required Location location,
  }) async {
    final restaurants = await getRestaurantsByLocation(location: location);
    return restaurants
        .where((rest) => rest.name.trimmedContains(name))
        .toList();
  }

  @override
  Future<List<Tag>> getRestaurantsTags({
    required Location location,
  }) async {
    final allRestaurants = await getRestaurantsByLocation(location: location);
    return Set<Tag>.from(
      allRestaurants
          .map((rest) => rest.tags.cast<Tag>())
          .expand((element) => element),
    ).toList();
  }

  @override
  Future<List<Restaurant>> getRestaurantsByTags({
    required List<String> tags,
    required Location location,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Menu>> getMenu({required String id}) {
    throw UnimplementedError();
  }

  @override
  Future<String> addRestaurant({
    required String id,
    required String name,
    required double rating,
    required int userRatingsTotal,
    required Location location,
    String tags = 'Fast Food',
    String imageUrl = '',
  }) {
    throw UnimplementedError();
  }

  @override
  Future<String> deleteRestaurant({required String id}) {
    throw UnimplementedError();
  }

  @override
  Future<String> updateRestaurant({
    required String id,
    String? name,
    double? rating,
    int? userRatingsTotal,
    Location? location,
    String? tags,
    String? imageUrl,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Restaurant> getRestaurantById({
    required String id,
    Location? location,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> addCreditCard({
    required String number,
    required String expiryDate,
    required String cvv,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> addOrderMenuItem({
    required String name,
    required String quantity,
    required String price,
    required String imageUrl,
    required String orderId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<String> createOrder({
    required String status,
    required String date,
    required String restaurantPlaceId,
    required String restaurantName,
    required String orderAddress,
    required String totalOrderSum,
    required String orderDeliveryFee,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCreditCard({required String number}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteOrder({
    required String id,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteOrderMenuItems({
    required String id,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<CreditCard>> getCreditCards() {
    throw UnimplementedError();
  }

  @override
  Future<Order> getOrder({
    required String id,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<Order>> getOrders() {
    throw UnimplementedError();
  }

  @override
  Future<List<Notification>> getNotifications() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendNotification({
    required String message,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateCreditCard({
    required String number,
    String? cvv,
    String? expiryDate,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateOrder({
    required String id,
    String? status,
    String? date,
    String? restaurantPlaceId,
    String? restaurantName,
    String? orderAddress,
    String? totalOrderSum,
    String? orderDeliveryFee,
  }) {
    throw UnimplementedError();
  }
}

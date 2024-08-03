import 'package:yandex_food_api/api.dart';

/// Fake Restaurants.
class FakeRestaurants {
  const FakeRestaurants._();

  static const _fakeRestaurant1 = Restaurant(
    name: 'KFC',
    placeId: 'Avds89FA_af950-23214ga_=942',
    rating: 4.8,
    tags: [
      Tag(
        name: 'Fast Food',
        imageUrl:
            'https://img.freepik.com/premium-vector/fast-food-tasty-set-fast-food-isolated-white_67394-543.jpg',
      ),
      Tag(
        name: 'Burgers',
        imageUrl:
            'https://img.freepik.com/premium-vector/hand-drawn-big-burger-illustration_266639-146.jpg',
      ),
    ],
    imageUrl:
        'https://images.unsplash.com/photo-1513639776629-7b61b0ac49cb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8S0ZDfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
    businessStatus: 'Restaurant',
    userRatingsTotal: 250,
    openNow: true,
    priceLevel: 3,
    location: Location(
      lat: 43.2269,
      lng: 76.8641,
    ),
  );

  static const _fakeRestaurant2 = Restaurant(
    name: 'Burger King',
    placeId: 'Bagds84SA_ob150-52214og_=051',
    rating: 4.6,
    priceLevel: 2,
    tags: [
      Tag(
        name: 'Fast Food',
        imageUrl:
            'https://img.freepik.com/premium-vector/fast-food-tasty-set-fast-food-isolated-white_67394-543.jpg',
      ),
      Tag(
        name: 'Burgers',
        imageUrl:
            'https://img.freepik.com/premium-vector/hand-drawn-big-burger-illustration_266639-146.jpg',
      ),
    ],
    imageUrl:
        'https://images.unsplash.com/photo-1550547660-d9450f859349?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGJ1cmdlciUyMGtpbmd8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
    businessStatus: 'Restaurant',
    userRatingsTotal: 102,
    openNow: true,
    location: Location(
      lat: 43.2103,
      lng: 76.9022,
    ),
  );

  static const _fakeRestaurant3 = Restaurant(
    name: "Papa John's",
    placeId: 'Piaf42FA_af950-23214ga_=521',
    rating: 4.8,
    priceLevel: 3,
    tags: [
      Tag(
        name: 'Fast Food',
        imageUrl:
            'https://img.freepik.com/premium-vector/fast-food-tasty-set-fast-food-isolated-white_67394-543.jpg',
      ),
      Tag(
        name: 'Pizza',
        imageUrl:
            'https://media.istockphoto.com/id/843213562/vector/cartoon-with-contour-of-pizza-slice-with-melted-cheese-and-pepperoni.jpg?s=612x612&w=0&k=20&c=St6rIJz83w2MjwSPj4EvHA8a4x_z9Rgmsd5TYkvSGH8=',
      ),
    ],
    imageUrl:
        'https://images.unsplash.com/photo-1666040401528-c8066902d8b2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=860&q=80',
    businessStatus: 'Restaurant',
    userRatingsTotal: 251,
    openNow: true,
    location: Location(
      lat: 43.2258,
      lng: 76.9104,
    ),
  );

  static const _fakeRestaurant4 = Restaurant(
    name: 'Subway',
    placeId: 'Jhaf52FA_af950-23214ga_=025',
    rating: 4.8,
    priceLevel: 2,
    tags: [
      Tag(
        name: 'Fast Food',
        imageUrl:
            'https://img.freepik.com/premium-vector/fast-food-tasty-set-fast-food-isolated-white_67394-543.jpg',
      ),
      Tag(
        name: 'Hot Dogs',
        imageUrl:
            'https://static.vecteezy.com/system/resources/thumbnails/003/345/891/small_2x/delicious-hot-dog-fast-food-icon-free-vector.jpg',
      ),
    ],
    imageUrl:
        'https://images.unsplash.com/photo-1644625143311-9510da7614a1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
    businessStatus: 'Restaurant',
    userRatingsTotal: 90,
    openNow: true,
    location: Location(
      lat: 43.2189,
      lng: 76.897,
    ),
  );

  static const _fakeRestaurant5 = Restaurant(
    name: 'Starbucks',
    placeId: 'Oeaf62PA_bg512-0621oe_=910',
    rating: 4.9,
    priceLevel: 3,
    tags: [
      Tag(
        name: 'Coffee',
        imageUrl:
            'https://images.all-free-download.com/images/graphiclarge/cup_of_coffee_311479.jpg',
      ),
    ],
    imageUrl:
        'https://images.unsplash.com/photo-1581818802335-ba9f9188d764?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
    businessStatus: 'Restaurant',
    userRatingsTotal: 320,
    openNow: true,
    location: Location(
      lat: 43.2258,
      lng: 76.9104,
    ),
  );

  /// Method to get all fake restaurants from local
  static List<Restaurant> get getAllRestaurants => [
        _fakeRestaurant1,
        _fakeRestaurant2,
        _fakeRestaurant3,
        _fakeRestaurant4,
        _fakeRestaurant5,
      ];

  /// Method to obtain popular restaurants from local
  static List<Restaurant> get getPopularRestaurants =>
      getAllRestaurants.take(2).toList();
}

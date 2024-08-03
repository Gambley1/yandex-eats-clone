import 'package:yandex_food_api/api.dart';

/// DB Fake Restaurants Insert
class DBFakeRestaurantsInsert {
  const DBFakeRestaurantsInsert._();

  static final _fakeRestaurant1 = DBRestaurantInsertRequest(
    name: 'KFC',
    placeId: 'Avds89FA_af950-23214ga_=942',
    rating: 4.6,
    latitude: 43,
    longitude: 45,
    tags: [
      'Fast Food',
      'Burgers',
    ],
    imageUrl:
        'https://images.unsplash.com/photo-1513639776629-7b61b0ac49cb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8S0ZDfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
    businessStatus: 'Restaurant',
    userRatingsTotal: 250,
    openNow: true,
    popular: true,
  );

  static final _fakeRestaurant2 = DBRestaurantInsertRequest(
    name: 'Burger King',
    placeId: 'Bagds84SA_ob150-52214og_=051',
    rating: 4.8,
    latitude: 43.2,
    longitude: 45.8,
    tags: [
      'Fast Food',
      'Burgers',
    ],
    imageUrl:
        'https://images.unsplash.com/photo-1550547660-d9450f859349?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGJ1cmdlciUyMGtpbmd8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
    businessStatus: 'Restaurant',
    userRatingsTotal: 102,
    openNow: true,
    popular: true,
  );

  static final _fakeRestaurant3 = DBRestaurantInsertRequest(
    name: "Papa John's",
    placeId: 'Piaf42FA_af950-23214ga_=521',
    rating: 4.9,
    latitude: 42.12,
    longitude: 44.43,
    tags: [
      'Fast Food',
      'Pizza',
    ],
    imageUrl:
        'https://images.unsplash.com/photo-1666040401528-c8066902d8b2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=860&q=80',
    businessStatus: 'Restaurant',
    userRatingsTotal: 251,
    openNow: true,
    popular: true,
  );

  static final _fakeRestaurant4 = DBRestaurantInsertRequest(
    name: 'Subway',
    placeId: 'Jhaf52FA_af950-23214ga_=025',
    rating: 4.6,
    latitude: 45.5,
    longitude: 45.2,
    tags: [
      'Fast Food',
      'Hot Dogs',
    ],
    imageUrl:
        'https://images.unsplash.com/photo-1644625143311-9510da7614a1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
    businessStatus: 'Restaurant',
    userRatingsTotal: 90,
    openNow: true,
    popular: false,
  );

  static final _fakeRestaurant5 = DBRestaurantInsertRequest(
    name: 'Starbucks',
    placeId: 'Oeaf62PA_bg512-0621oe_=910',
    rating: 4.7,
    latitude: 42,
    longitude: 44,
    tags: [
      'Coffee',
    ],
    imageUrl:
        'https://images.unsplash.com/photo-1581818802335-ba9f9188d764?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
    businessStatus: 'Restaurant',
    userRatingsTotal: 320,
    openNow: true,
    popular: false,
  );

  static final _fakeRestaurant6 = DBRestaurantInsertRequest(
    name: 'Pizza Hut',
    placeId: 'Keaf32LF_pa032-64312fa_=543',
    rating: 4.7,
    latitude: 44,
    longitude: 45.4,
    tags: [
      'Coffee',
      'Pizza',
    ],
    imageUrl:
        'https://images.unsplash.com/photo-1584190926897-0023f6aa05f9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
    businessStatus: 'Restaurant',
    userRatingsTotal: 230,
    openNow: true,
    popular: false,
  );

  /// Method to insert all fake DB restaurants to PostgreSQL DB.
  static List<DBRestaurantInsertRequest> get getRestaurantToInsert => [
        _fakeRestaurant1,
        _fakeRestaurant2,
        _fakeRestaurant3,
        _fakeRestaurant4,
        _fakeRestaurant5,
        _fakeRestaurant6,
      ];
}

part of 'restaurants_bloc.dart';

enum RestaurantsStatus {
  initial,
  loading,
  withRestaurantsAndTags,
  withFilteredRestaurants,
  empty,
  failure;

  bool get isInitial => this == RestaurantsStatus.initial;
  bool get isLoading => this == RestaurantsStatus.loading;
  bool get isWithRestaurantsAndTags =>
      this == RestaurantsStatus.withFilteredRestaurants;
  bool get isWithFilteredRestaurants =>
      this == RestaurantsStatus.withFilteredRestaurants;
  bool get isEmpty => this == RestaurantsStatus.empty;
  bool get isError => this == RestaurantsStatus.failure;
}

class RestaurantsState extends Equatable {
  const RestaurantsState._({
    required this.restaurants,
    required this.filteredRestaurants,
    required this.tags,
    required this.chosenTags,
    required this.status,
    required this.location,
  });

  const RestaurantsState.initial()
      : this._(
          restaurants: const [],
          filteredRestaurants: const [],
          tags: const [],
          chosenTags: const [],
          status: RestaurantsStatus.initial,
          location: const Location.undefiend(),
        );

  final List<Restaurant> restaurants;
  final List<Restaurant> filteredRestaurants;
  final List<Tag> tags;
  final List<Tag> chosenTags;
  final RestaurantsStatus status;
  final Location location;

  @override
  List<Object> get props => [
        restaurants,
        tags,
        status,
        filteredRestaurants,
        chosenTags,
        location,
      ];

  RestaurantsState copyWith({
    List<Restaurant>? restaurants,
    List<Restaurant>? filteredRestaurants,
    List<Tag>? tags,
    List<Tag>? chosenTags,
    RestaurantsStatus? status,
    Location? location,
  }) {
    return RestaurantsState._(
      restaurants: restaurants ?? this.restaurants,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
      tags: tags ?? this.tags,
      chosenTags: chosenTags ?? this.chosenTags,
      status: status ?? this.status,
      location: location ?? this.location,
    );
  }
}

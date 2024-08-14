part of 'restaurants_bloc.dart';

enum RestaurantsStatus {
  initial,
  loading,
  filtered,
  populated,
  failure;

  bool get isLoading => this == loading;
  bool get isPopulated => this == populated;
  bool get isFiltered => this == filtered;
  bool get isFailure => this == failure;
}

class RestaurantsState extends Equatable {
  const RestaurantsState._({
    required this.restaurantsPage,
    required this.filteredRestaurants,
    required this.tags,
    required this.chosenTags,
    required this.status,
    required this.location,
  });

  const RestaurantsState.initial()
      : this._(
          restaurantsPage: const RestaurantsPage.empty(),
          filteredRestaurants: const [],
          tags: const [],
          chosenTags: const [],
          status: RestaurantsStatus.initial,
          location: const Location.undefined(),
        );

  final RestaurantsPage restaurantsPage;
  final List<Restaurant> filteredRestaurants;
  final List<Tag> tags;
  final List<Tag> chosenTags;
  final RestaurantsStatus status;
  final Location location;

  @override
  List<Object> get props => [
        restaurantsPage,
        tags,
        status,
        filteredRestaurants,
        chosenTags,
        location,
      ];

  RestaurantsState copyWith({
    RestaurantsPage? restaurantsPage,
    List<Restaurant>? filteredRestaurants,
    List<Tag>? tags,
    List<Tag>? chosenTags,
    RestaurantsStatus? status,
    Location? location,
  }) {
    return RestaurantsState._(
      restaurantsPage: restaurantsPage ?? this.restaurantsPage,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
      tags: tags ?? this.tags,
      chosenTags: chosenTags ?? this.chosenTags,
      status: status ?? this.status,
      location: location ?? this.location,
    );
  }
}

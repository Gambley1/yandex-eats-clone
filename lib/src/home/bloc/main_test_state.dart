part of 'main_test_bloc.dart';

enum MainPageStatus {
  loading,
  idle,
  withRestaurantsAndTags,
  withFilteredRestaurants,
  empty,
  noInternet,
  malformedResponse,
  clientFailure,
  outOfTime,
}

class MainTestState extends Equatable {
  const MainTestState._({
    this.restaurants = const [],
    this.filteredRestaurants = const [],
    this.tags = const [],
    this.chosenTags = const [],
    this.status = MainPageStatus.idle,
    this.errMessage = '',
    this.lat = 0,
    this.lng = 0,
  });

  const MainTestState.initial() : this._();

  final List<Restaurant> restaurants;
  final List<Restaurant> filteredRestaurants;
  final List<Tag> tags;
  final List<Tag> chosenTags;
  final MainPageStatus status;
  final String errMessage;
  final double lat;
  final double lng;

  bool get loading => status == MainPageStatus.loading;
  bool get empty => status == MainPageStatus.empty;
  bool get withRestaurantsAndTags =>
      status == MainPageStatus.withRestaurantsAndTags;
  bool get withFilteredRestaurants =>
      status == MainPageStatus.withFilteredRestaurants;
  bool get noInternet => status == MainPageStatus.noInternet;
  bool get malformed => status == MainPageStatus.malformedResponse;
  bool get clientFailure => status == MainPageStatus.clientFailure;
  bool get outOfTime => status == MainPageStatus.outOfTime;

  @override
  List<Object> get props => [
        restaurants,
        tags,
        status,
        errMessage,
        filteredRestaurants,
        chosenTags,
        lat,
        lng,
      ];

  MainTestState copyWith({
    List<Restaurant>? restaurants,
    List<Restaurant>? filteredRestaurants,
    List<Tag>? tags,
    List<Tag>? chosenTags,
    MainPageStatus? status,
    String? errMessage,
    double? lat,
    double? lng,
  }) {
    return MainTestState._(
      restaurants: restaurants ?? this.restaurants,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
      tags: tags ?? this.tags,
      chosenTags: chosenTags ?? this.chosenTags,
      status: status ?? this.status,
      errMessage: errMessage ?? this.errMessage,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}

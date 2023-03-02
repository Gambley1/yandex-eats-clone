part of 'main_page_bloc.dart';

enum MainPageRequest {
  unknown,
  loading,
  mainPageLoading,
  filterRequestSuccess,
  mainPageFailure,
  mainPageSuccess,
  requestInProgress,
  requestSuccess,
  filterRequestSucces,
  filterRequestLoading,
  filterRequestFailure,
  mainPageRequestFailure,
}

enum CartRequest {
  unknown,
  loading,
  requestInProgress,
  requestSuccess,
  requestFailure,
}

class MainPageState {
  MainPageState({
    this.filteredRestaurants = const [],
    this.restaurants = const [],
    this.mainPageRequest = MainPageRequest.unknown,
    this.cartRequest = CartRequest.unknown,
    this.currentIndex = 0,
    this.numOfMeals = 1,
  });
  final List<Restaurant> filteredRestaurants;
  final List<Restaurant> restaurants;
  final MainPageRequest mainPageRequest;
  final CartRequest cartRequest;
  final int currentIndex;
  final int numOfMeals;

  MainPageState copyWith({
    MainPageRequest? mainPageRequest,
    CartRequest? cartRequest,
    List<Restaurant>? filteredRestaurants,
    List<Restaurant>? restaurants,
    int? currentIndex,
    int? numOfMeals,
  }) {
    return MainPageState(
      mainPageRequest: mainPageRequest ?? this.mainPageRequest,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
      cartRequest: cartRequest ?? this.cartRequest,
      restaurants: restaurants ?? this.restaurants,
      currentIndex: currentIndex ?? this.currentIndex,
      numOfMeals: numOfMeals ?? this.numOfMeals,
    );
  }
}

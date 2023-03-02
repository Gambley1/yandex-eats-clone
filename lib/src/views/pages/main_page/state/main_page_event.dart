part of 'main_page_bloc.dart';

abstract class MainPageEvent extends Equatable {
  const MainPageEvent();

  @override
  List<Object> get props => [];
}

class LoadMainPageEvent extends MainPageEvent {}

class FilterRestaurantsEvent extends MainPageEvent {
  final List<Restaurant> filteredRestaurants;

  const FilterRestaurantsEvent({required this.filteredRestaurants});
}

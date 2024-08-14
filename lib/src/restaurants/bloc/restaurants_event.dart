part of 'restaurants_bloc.dart';

sealed class RestaurantsEvent extends Equatable {
  const RestaurantsEvent();

  @override
  List<Object?> get props => [];
}

final class RestaurantsFetchRequested extends RestaurantsEvent {
  const RestaurantsFetchRequested({this.page});

  final int? page;

  @override
  List<Object?> get props => [page];
}

final class RestaurantsLocationChanged extends RestaurantsEvent {
  const RestaurantsLocationChanged({required this.location});

  final Location location;

  @override
  List<Object?> get props => [location];
}

final class RestaurantsFilterTagChanged extends RestaurantsEvent {
  const RestaurantsFilterTagChanged(this.tag);

  final Tag tag;
}

final class RestaurantsFilterTagsChanged extends RestaurantsEvent {
  const RestaurantsFilterTagsChanged({this.tags});

  final List<Tag>? tags;
}

final class _RestaurantsFilterTadAdded extends RestaurantsEvent {
  const _RestaurantsFilterTadAdded(this.tag);

  final Tag tag;
}

final class _RestaurantsFilterTagRemoved extends RestaurantsEvent {
  const _RestaurantsFilterTagRemoved(this.tag);

  final Tag tag;
}

class RestaurantsFilterTagsClearRequested extends RestaurantsEvent {
  const RestaurantsFilterTagsClearRequested();
}

class RestaurantsRefreshRequested extends RestaurantsEvent {
  const RestaurantsRefreshRequested();
}

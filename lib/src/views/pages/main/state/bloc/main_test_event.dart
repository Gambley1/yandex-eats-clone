part of 'main_test_bloc.dart';

abstract class MainTestEvent {
  const MainTestEvent();
}

class MainTestStarted extends MainTestEvent {
  const MainTestStarted();
}

class _MainTestLatLngChanged extends MainTestEvent {
  const _MainTestLatLngChanged(
    this.lat,
    this.lng,
  );

  final double lat;
  final double lng;
}

class MainTestRestaurantsAndTagsFetched extends MainTestEvent {
  const MainTestRestaurantsAndTagsFetched();
}

class MainTestFilterRestaurantsTagChanged extends MainTestEvent {
  const MainTestFilterRestaurantsTagChanged(this.tag);

  final Tag tag;
}

class _MainTestFilterRestaurantsTagAdded extends MainTestEvent {
  const _MainTestFilterRestaurantsTagAdded(this.tag);

  final Tag tag;
}

class _MainTestFilterRestaurantsTagRemoved extends MainTestEvent {
  const _MainTestFilterRestaurantsTagRemoved(this.tag);

  final Tag tag;
}

class MainTestTagsFiltersClear extends MainTestEvent {
  const MainTestTagsFiltersClear();
}

class MainTestRefreshed extends MainTestEvent {
  const MainTestRefreshed();
}

import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/restaurants.dart';

class FilteredRestaurantsView extends StatelessWidget {
  const FilteredRestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = context
        .select((RestaurantsBloc bloc) => bloc.state.filteredRestaurants);

    return RestaurantsListView(restaurants: filteredRestaurants);
  }
}

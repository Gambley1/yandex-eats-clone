import 'dart:math' show Random;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/home/bloc/main_bloc.dart';
import 'package:papa_burger/src/home/bloc/search_bloc.dart';
import 'package:papa_burger/src/home/bloc/search_result.dart';
import 'package:papa_burger/src/menu/menu.dart';
import 'package:papa_burger/src/restaurants/restaurants.dart';
import 'package:papa_burger/src/search/widgets/search_bar.dart';
import 'package:papa_burger/src/services/network/api/api.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final Random random = Random(11);

  late SearchBloc _searchBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc(api: SearchApi());
  }

  @override
  void dispose() {
    _searchBloc.dispose();
    super.dispose();
  }

  Padding _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      child: Row(
        children: [
          AppIcon(
            type: IconType.button,
            onPressed: context.pop,
            icon: Icons.adaptive.arrow_back_sharp,
          ),
          Expanded(
            child: AppSearchBar(
              onChanged: _searchBloc.search.add,
              labelText: quickSearchLabel,
              controller: _searchController,
              withNavigation: false,
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildPopularRestaurants(BuildContext context) {
    final restaurants = MainBloc().popularRestaurants;
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          final deliveryTime = restaurant.deliveryTime;
          final deliverByWalk = deliveryTime < 8;
          final deliveryTime$ = deliverByWalk ? 15 : deliveryTime;
          return ListTile(
            onTap: () => context.pushNamed(
              AppRoutes.menu.name,
              extra: MenuProps(restaurant: restaurant),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md - AppSpacing.xs,
              horizontal: AppSpacing.md,
            ),
            leading: AppCachedImage(
              width: 60,
              imageType: CacheImageType.sm,
              imageUrl: restaurant.imageUrl,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'Menu${restaurant.name}',
                  child: Text(
                    restaurant.name,
                    style: context.bodyLarge
                        ?.copyWith(fontWeight: AppFontWeight.bold),
                  ),
                ),
                Text(
                  '${deliveryTime$} - ${deliveryTime$ + 10} min',
                  style: context.bodyMedium?.apply(color: AppColors.grey),
                ),
              ],
            ),
          );
        },
        itemCount: restaurants.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      releaseFocus: true,
      body: Column(
        children: [
          _appBar(context),
          StreamBuilder<SearchResult?>(
            stream: _searchBloc.results,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final result = snapshot.data;
                if (result is SearchResultsError) {
                  return Text(
                    'Unable to search for restaurants 😕',
                    textAlign: TextAlign.center,
                    style: context.headlineSmall,
                  );
                } else if (result is SearchResultsLoading) {
                  return const AppCircularProgressIndicator(
                    color: Colors.black,
                  );
                } else if (result is SearchResultsNoResults) {
                  return Column(
                    children: [
                      Text(
                        'Nothing found!',
                        style: context.headlineSmall,
                      ),
                      Text(
                        'Please try again.',
                        style: context.titleLarge?.apply(color: AppColors.grey),
                      ),
                    ],
                  );
                } else if (result is SearchResultsWithResults) {
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final restaurant = result.restaurants[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.md,
                          ),
                          child: RestaurantCard(restaurant: restaurant),
                        );
                      },
                      itemCount: result.restaurants.length,
                    ),
                  );
                } else {
                  return const Text('Unhandled state');
                }
              } else {
                return _buildPopularRestaurants(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

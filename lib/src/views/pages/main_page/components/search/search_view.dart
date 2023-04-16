import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show CacheImageType, CachedImage, CustomCircularIndicator, CustomIcon, CustomScaffold, DisalowIndicator, IconType, InkEffect, KText, MainBloc, MainPageService, NavigatorExtension, RestaurantCard, SearchApi, SearchBar, SearchBloc, SearchResult, SearchResultsError, SearchResultsLoading, SearchResultsNoResults, SearchResultsWithResults, kDefaultHorizontalPadding, logger, quickSearchLabel;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final MainPageService _mainPageService = MainPageService();
  final Random random = Random(11);

  late final SearchBloc _searchBloc;
  late final MainBloc _mainBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc(api: SearchApi());
    _mainBloc = _mainPageService.mainBloc;
  }

  @override
  void dispose() {
    _searchBloc.dispose();
    super.dispose();
  }

  _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      child: Row(
        children: [
          CustomIcon(
            type: IconType.iconButton,
            onPressed: () => context.pop(),
            icon: FontAwesomeIcons.arrowLeft,
            size: 22,
          ),
          Expanded(
            child: SearchBar(
              onChanged: _searchBloc.search.add,
              labelText: quickSearchLabel,
              withNavigation: false,
            ),
          ),
        ],
      ),
    );
  }

  _buildPopularRestaurants(BuildContext context) {
    final restaurants = _mainBloc.allRestaurants;
    logger.w('${restaurants.length}');
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 12,
          );
        },
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return ListTile(
            leading: CachedImage(
              width: 60,
              imageType: CacheImageType.smallImage,
              imageUrl: restaurant.imageUrl,
              inkEffect: InkEffect.noEffect,
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: restaurant.name,
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
                KText(
                  text:
                      '${random.nextInt(20) + 10} - ${random.nextInt(50) + 20} min',
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          );
        },
        itemCount: restaurants.length,
      ).disalowIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      withReleaseFocus: true,
      withSafeArea: true,
      body: Column(
        children: [
          _appBar(context),
          StreamBuilder<SearchResult?>(
            stream: _searchBloc.results,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final result = snapshot.data;
                if (result is SearchResultsError) {
                  return KText(text: result.error.toString());
                } else if (result is SearchResultsLoading) {
                  return const CustomCircularIndicator(color: Colors.black);
                } else if (result is SearchResultsNoResults) {
                  return const KText(
                    text: '  Nothing found \n Please try again!',
                    size: 24,
                  );
                } else if (result is SearchResultsWithResults) {
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final restaurant = result.restaurants[index];
                        final name = restaurant.name;
                        final rating = restaurant.rating;
                        final tags = restaurant.types;
                        final numOfRatings = restaurant.userRatingsTotal ?? 0;
                        final quality = restaurant.quality(rating);
                        final imageUrl = restaurant.imageUrl;
                        final priceLevel = restaurant.priceLevel ?? 0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultHorizontalPadding,
                              vertical: kDefaultHorizontalPadding),
                          child: RestaurantCard(
                            restaurant: restaurant,
                            imageUrl: imageUrl,
                            name: name,
                            priceLevel: priceLevel,
                            tags: tags,
                            rating: rating,
                            quality: quality,
                            numOfRatings: numOfRatings,
                          ),
                        );
                      },
                      itemCount: result.restaurants.length,
                    ).disalowIndicator(),
                  );
                } else {
                  return const KText(text: 'Unhandled state');
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

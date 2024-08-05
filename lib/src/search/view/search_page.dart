import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/menu/menu.dart';
import 'package:yandex_food_delivery_clone/src/search/search.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(
        userRepository: context.read<UserRepository>(),
        restaurantsRepository: context.read<RestaurantsRepository>(),
      )..add(const SearchTermChanged()),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      releaseFocus: true,
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          final restaurants = state.restaurants;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                surfaceTintColor: AppColors.white,
                title: SearchTextField(controller: _controller),
              ),
              if (state.status.isLoading)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xlg),
                      child: Transform.scale(
                        scale: .8,
                        child: const AppCircularProgressIndicator(),
                      ),
                    ),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    return RestaurantListTile(restaurant: restaurant);
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class RestaurantListTile extends StatelessWidget {
  const RestaurantListTile({required this.restaurant, super.key});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.pushNamed(
        AppRoutes.menu.name,
        extra: MenuProps(restaurant: restaurant),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md - AppSpacing.xs,
        horizontal: AppSpacing.md,
      ),
      horizontalTitleGap: AppSpacing.md,
      leading: AspectRatio(
        aspectRatio: 1,
        child: ImageAttachmentThumbnail(
          resizeHeight: 168,
          imageUrl: restaurant.imageUrl,
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
      ),
      title: Text(
        restaurant.name,
      ),
      titleTextStyle:
          context.bodyLarge?.copyWith(fontWeight: AppFontWeight.bold),
      subtitle: Text(
        restaurant.formattedDeliveryTime(),
      ),
      subtitleTextStyle: context.bodyMedium?.apply(color: AppColors.grey),
    );
  }
}

// ignore_for_file: lines_longer_than_80_chars

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/views/pages/main/components/categories/categories_slider.dart';
import 'package:papa_burger/src/views/pages/main/components/header/header_view.dart';
import 'package:papa_burger/src/views/pages/main/components/restaurant/restaurants_list_view.dart';
import 'package:papa_burger/src/views/pages/main/components/search/search_bar.dart';
import 'package:papa_burger/src/views/pages/main/state/bloc/main_test_bloc.dart';
import 'package:papa_burger/src/views/pages/main/state/main_page_state.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

final PageStorageBucket _bucket = PageStorageBucket();

class MainPageBody extends StatelessWidget {
  const MainPageBody({super.key, this.state});

  final MainPageState? state;

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: _bucket,
      child: MainPageBodyUI(
        state: state,
      ),
    );
  }
}

class MainPageBodyUI extends StatefulWidget {
  const MainPageBodyUI({
    super.key,
    this.state,
  });

  final MainPageState? state;

  @override
  State<MainPageBodyUI> createState() => _MainPageBodyUIState();
}

class _MainPageBodyUIState extends State<MainPageBodyUI> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: Colors.black,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      displacement: 30,
      onRefresh: () async =>
          context.read<MainTestBloc>()..add(const MainTestRefreshed()),
      child: BlocConsumer<MainTestBloc, MainTestState>(
        listener: (context, state) {
          final noInternet = state.noInternet;
          final outOfTime = state.outOfTime;
          final clientFailure = state.clientFailure;
          final malformed = state.malformed;
          final message = state.errMessage;

          if (noInternet) {
            context.showUndismissableSnackBar(
              message,
              action: SnackBarAction(
                label: 'REFRESH',
                textColor: Colors.indigo.shade300,
                onPressed: () =>
                    context.read<MainTestBloc>().add(const MainTestRefreshed()),
              ),
            );
          }
          if (clientFailure) {
            context.showSnackBar(message);
          }
          if (malformed) {
            context.showSnackBar(message);
          }
          if (outOfTime) {
            context.showUndismissableSnackBar(
              message,
              action: SnackBarAction(
                label: 'TRY AGAIN',
                textColor: Colors.indigo.shade300,
                onPressed: () =>
                    context.read<MainTestBloc>().add(const MainTestRefreshed()),
              ),
            );
          }
          if (!clientFailure && !malformed && !outOfTime && !noInternet) {
            context.closeSnackBars();
          }
        },
        listenWhen: (p, c) => p.status != c.status,
        builder: (context, state) {
          final tags = state.tags;
          final restaurants = state.restaurants;
          final filteredRestaurants = state.filteredRestaurants;

          final loaded = state.withRestaurantsAndTags;
          final filtered = state.withFilteredRestaurants;
          final empty = state.empty;
          final loading = state.loading;
          final error = state.clientFailure || state.malformed;
          final noInternet = state.noInternet;
          final outOfTime = state.outOfTime;
          return CustomScrollView(
            controller: _scrollController,
            key: const PageStorageKey('main_page_body'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const MainPageHeader(),
              if (loading) const MainPageLoadingView(),
              if (error)
                MainPageErrorView(
                  refresh: () => context
                      .read<MainTestBloc>()
                      .add(const MainTestRefreshed()),
                ),
              if (noInternet) const MainPageNoInternetView(),
              if (outOfTime) const MainPageOutOfTimeView(),
              if (empty) const MainPageEmptyView(),
              if (filtered) ...[
                CategoriesSlider(tags: tags),
                FilteredRestaurantsView(
                  tags: tags,
                  filteredRestaurantsCount: filteredRestaurants.length,
                ),
                FilteredRestaurantsListView(
                  filteredRestaurants: filteredRestaurants,
                ),
              ],
              if (loaded) ...[
                const MainPageSectionHeader(text: 'Restaurants'),
                CategoriesSlider(tags: tags),
                RestaurantsListView(restaurants: restaurants, hasMore: false),
              ],
            ],
          );
        },
      ),
    );
  }
}

class MainPageLoadingView extends StatelessWidget {
  const MainPageLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverPadding(
      padding: EdgeInsets.only(top: 24),
      sliver: SliverFillRemaining(
        hasScrollBody: false,
        child: CustomCircularIndicator(color: Colors.black),
      ),
    );
  }
}

class MainPageEmptyView extends StatelessWidget {
  const MainPageEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 24),
      sliver: SliverFillRemaining(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'We are not here yet :(',
              textAlign: TextAlign.center,
              style: context.titleLarge
                  ?.copyWith(fontWeight: AppFontWeight.semiBold),
            ),
            Text(
              'But we connect dozens of new places every week. '
              "Maybe we'll be here!",
              textAlign: TextAlign.center,
              style: context.bodyMedium
                  ?.apply(color: AppColors.grey.withOpacity(.6)),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPageOutOfTimeView extends StatelessWidget {
  const MainPageOutOfTimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 24),
      sliver: SliverFillRemaining(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'The client ran out of time :(',
              textAlign: TextAlign.center,
              style: context.titleLarge
                  ?.copyWith(fontWeight: AppFontWeight.semiBold),
            ),
            Text(
              'Please try again later and check your internet connection!',
              textAlign: TextAlign.center,
              style: context.bodyMedium
                  ?.apply(color: AppColors.grey.withOpacity(.6)),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPageErrorView extends StatelessWidget {
  const MainPageErrorView({
    required this.refresh,
    super.key,
  });

  final void Function() refresh;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 24),
      sliver: SliverFillRemaining(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Something went wrong!',
              textAlign: TextAlign.center,
              style: context.headlineSmall,
            ),
            ElevatedButton.icon(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  AppColors.indigo,
                ),
              ),
              onPressed: refresh,
              icon: const CustomIcon(
                type: IconType.simpleIcon,
                icon: FontAwesomeIcons.arrowsRotate,
                color: Colors.white,
                size: 14,
              ),
              label: Text(
                'Try again.',
                style: context.bodyMedium?.apply(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPageNoInternetView extends StatelessWidget {
  const MainPageNoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xlg),
              child: ShimmerLoading(
                height: 160,
                radius: kDefaultBorderRadius,
                width: double.infinity,
              ),
            );
          },
          childCount: 5,
        ),
      ),
    );
  }
}

class MainPageHeader extends StatelessWidget {
  const MainPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      excludeHeaderSemantics: true,
      scrolledUnderElevation: 12,
      floating: true,
      collapsedHeight: 133,
      flexibleSpace: Column(
        children: [
          SizedBox(
            height: kDefaultHorizontalPadding,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding,
            ),
            child: HeaderView(),
          ),
          SizedBox(height: AppSpacing.lg),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding),
            child: CustomSearchBar(enabled: false),
          ),
        ],
      ),
    );
  }
}

class MainPageSectionHeader extends StatelessWidget {
  const MainPageSectionHeader({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
        ),
        child: Text(
          text,
          style:
              context.headlineMedium?.copyWith(fontWeight: AppFontWeight.bold),
        ),
      ),
    );
  }
}

class FilteredRestaurantsView extends StatelessWidget {
  const FilteredRestaurantsView({
    required this.filteredRestaurantsCount,
    required this.tags,
    super.key,
  });

  final List<Tag> tags;
  final int filteredRestaurantsCount;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilteredRestaurantsCount(count: filteredRestaurantsCount),
                const ResetFiltersButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResetFiltersButton extends StatelessWidget {
  const ResetFiltersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        context.read<MainTestBloc>().add(const MainTestTagsFiltersClear());
      },
      child: Ink(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding + 10,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          color: Colors.grey.shade300,
        ),
        child: Align(
          child: Text(
            'Reset',
            style: context.bodyLarge,
          ),
        ),
      ),
    );
  }
}

class FilteredRestaurantsCount extends StatelessWidget {
  const FilteredRestaurantsCount({
    required this.count,
    super.key,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Found $count ${count == 1 ? 'restaurant' : 'restaurants'}',
      style: context.titleLarge?.copyWith(fontWeight: AppFontWeight.semiBold),
    );
  }
}

class FilteredRestaurantsListView extends StatelessWidget {
  const FilteredRestaurantsListView({
    required this.filteredRestaurants,
    super.key,
  });

  final List<Restaurant> filteredRestaurants;

  @override
  Widget build(BuildContext context) {
    return RestaurantsListView(
      restaurants: filteredRestaurants,
      hasMore: false,
    );
  }
}

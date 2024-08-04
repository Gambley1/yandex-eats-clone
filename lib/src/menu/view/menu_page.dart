import 'dart:math';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide NumDurationExtensions;
import 'package:shared/shared.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/cart/cart.dart';
import 'package:yandex_food_delivery_clone/src/menu/menu.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({required this.props, super.key});

  final MenuProps props;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MenuBloc(
        restaurantsRepository: context.read<RestaurantsRepository>(),
      )..add(MenuFetchRequested(props.restaurant)),
      child: MenuView(props: props),
    );
  }
}

class MenuView extends StatefulWidget {
  const MenuView({required this.props, super.key});

  final MenuProps props;

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView>
    with SingleTickerProviderStateMixin {
  Restaurant get restaurant => widget.props.restaurant;

  late MenuController _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MenuController();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menus = context.select((MenuBloc bloc) => bloc.state.menus);

    return DefaultTabController(
      length: menus.length,
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _bloc
              ..init(menus)
              ..tabController = DefaultTabController.of(context);
          });
          return AppScaffold(
            bottomNavigationBar: MenuBottomAppBar(restaurant: restaurant),
            onPopInvoked: (didPop) {
              if (!didPop) return;
              context.pop();
            },
            top: false,
            body: CustomScrollView(
              controller: _bloc.scrollController,
              slivers: [
                ListenableBuilder(
                  listenable: Listenable.merge(
                    [
                      _bloc.isScrolledNotifier,
                      _bloc.preferredSizedNotifier,
                      _bloc.colorChangeNotifier,
                    ],
                  ),
                  builder: (context, _) {
                    return SliverAppBar(
                      surfaceTintColor: AppColors.transparent,
                      titleSpacing: AppSpacing.xlg,
                      pinned: true,
                      expandedHeight: 300,
                      forceElevated: true,
                      automaticallyImplyLeading: false,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.md),
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                          ),
                          child: Tappable.faded(
                            onTap: context.pop,
                            child: Icon(
                              _bloc.isScrolledNotifier.value
                                  ? LucideIcons.x
                                  : Icons.adaptive.arrow_back,
                            ),
                          ),
                        ),
                      ),
                      flexibleSpace: AnnotatedRegion<SystemUiOverlayStyle>(
                        value: context.isIOS
                            ? SystemUiOverlayTheme.adaptiveiOSSystemBarTheme(
                                light: !_bloc.colorChangeNotifier.value,
                              )
                            : SystemUiOverlayTheme
                                .adaptiveAndroidTransparentSystemBarTheme(
                                light: !_bloc.colorChangeNotifier.value,
                              ),
                        child: FlexibleSpaceBar(
                          expandedTitleScale: 2.2,
                          centerTitle: false,
                          background: RestaurantImage(
                            imageUrl: restaurant.imageUrl,
                            placeId: restaurant.placeId,
                          ),
                          title: Hero(
                            tag: 'Menu${restaurant.name}',
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: _bloc.preferredSizedNotifier.value,
                              ),
                              child: Text(
                                restaurant.name,
                                maxLines:
                                    _bloc.colorChangeNotifier.value ? 1 : 2,
                                style: context.titleMedium?.copyWith(
                                  fontWeight: AppFontWeight.bold,
                                  color: _bloc.colorChangeNotifier.value
                                      ? AppColors.black
                                      : AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize:
                            Size.fromHeight(_bloc.preferredSizedNotifier.value),
                        child: CircularContainer(
                          height: _bloc.preferredSizedNotifier.value,
                        ),
                      ),
                    );
                  },
                ),
                if (menus.isNotEmpty) ...[
                  ListenableBuilder(
                    listenable: _bloc,
                    builder: (context, _) {
                      if (_bloc.tabs.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      }
                      return SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            dividerColor: AppColors.transparent,
                            isScrollable: true,
                            indicator: BoxDecoration(
                              color: AppColors.brightGrey,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.md + AppSpacing.sm,
                              ),
                            ),
                            indicatorPadding: const EdgeInsets.all(
                              AppSpacing.sm - AppSpacing.xxs,
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            onTap: _bloc.onCategorySelected,
                            unselectedLabelColor: AppColors.background,
                            labelColor: AppColors.background,
                            tabs: _bloc.tabs
                                .map(
                                  (tab) => Tab(text: tab.menuCategory.category),
                                )
                                .toList(),
                          ),
                          isScrolled: _bloc.isScrolledNotifier,
                        ),
                      );
                    },
                  ),
                  ListenableBuilder(
                    listenable: _bloc,
                    builder: (context, child) {
                      return DiscountCard(discounts: _bloc.discounts);
                    },
                  ),
                  for (int i = 0;
                      i < menus.map((e) => e.category).length;
                      i++) ...[
                    MenuSectionHeader(
                      categoryName: menus[i].category,
                      isSectionEmpty: false,
                      categoryHeight: _bloc.categoryHeight,
                    ),
                    MenuItemCard(
                      menu: menus[i],
                    ),
                  ],
                ] else
                  const SliverFillRemaining(
                    child: AppCircularProgressIndicator(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RestaurantImage extends StatelessWidget {
  const RestaurantImage({
    required this.placeId,
    required this.imageUrl,
    super.key,
  });

  final String placeId;
  final String imageUrl;

  Color _getRandomColor() {
    final colorList = [
      Colors.brown.withOpacity(.9),
      Colors.black.withOpacity(.9),
      Colors.cyan.withOpacity(.8),
      Colors.green.withOpacity(.8),
      Colors.indigo.withOpacity(.9),
    ];

    final placeId = this.placeId.replaceAll(RegExp(r'[^\d]'), '');
    final index = int.tryParse(placeId) ?? 1;
    final random = Random(index);
    return colorList[random.nextInt(colorList.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageAttachmentThumbnail.network(imageUrl: imageUrl),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.transparent,
                  _getRandomColor(),
                ],
                stops: const [0.1, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MenuBottomAppBar extends StatelessWidget {
  const MenuBottomAppBar({required this.restaurant, super.key});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final cartEmpty = state.isCartEmpty;
        final isFromSameRestaurant =
            state.restaurant?.placeId == restaurant.placeId;

        if (cartEmpty || !isFromSameRestaurant) {
          return const SizedBox.shrink();
        }

        return const FadeAnimation(
          intervalEnd: 0.2,
          child: AppBottomBar(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.xlg),
              topRight: Radius.circular(AppSpacing.xlg),
            ),
            children: [
              DeliveryInfoBox(),
              SizedBox(height: AppSpacing.md),
              OrderInfoButton(),
            ],
          ),
        );
      },
    );
  }
}

class DeliveryInfoBox extends StatelessWidget {
  const DeliveryInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.select((CartBloc bloc) => bloc.state);
    final defaultDeliveryFee =
        context.select((CartBloc bloc) => bloc.state.formattedDeliveryFee);

    return Tappable(
      onTap: () {},
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              left: 0,
              child: AppIcon(
                icon: LucideIcons.carTaxiFront,
                iconSize: AppSize.md,
              ),
            ),
            if (cart.isDeliveryFree)
              DiscountPrice(
                defaultPrice: defaultDeliveryFee,
                discountPrice: 0.currencyFormat(decimalDigits: 0),
                forDeliveryFee: true,
                hasDiscount: false,
              )
            else
              Column(
                children: [
                  Text(
                    'Delivery ${cart.formattedOrderDeliveryFee}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'To Free delivery ${cart.sumLeftToFreeDelivery}',
                    textAlign: TextAlign.center,
                    style: context.bodyMedium?.apply(color: AppColors.green),
                  ),
                ],
              ),
            const Positioned(
              right: 0,
              child: AppIcon(icon: Icons.arrow_forward_ios_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderInfoButton extends StatelessWidget {
  const OrderInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.select((CartBloc bloc) => bloc.state);
    final restaurant = context.select((CartBloc bloc) => bloc.state.restaurant);

    return Tappable.faded(
      backgroundColor: AppColors.deepBlue,
      borderRadius: AppSpacing.sm,
      onTap: () => context.pushNamed(AppRoutes.cart.name),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                child: LimitedBox(
                  maxWidth: 120,
                  child: Text(
                    restaurant?.formattedDeliveryTime() ?? '',
                    textAlign: TextAlign.center,
                    style: context.bodyMedium?.apply(color: AppColors.white),
                  ),
                ),
              ),
              Text(
                'Order',
                style: context.bodyLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: AppFontWeight.medium,
                ),
              ),
              Positioned(
                right: 0,
                child: Text(
                  cart.formattedTotalDelivery(),
                  style: context.bodyMedium?.apply(color: AppColors.brightGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  const _SliverAppBarDelegate(this._tabBar, {required this.isScrolled});

  final TabBar _tabBar;
  final ValueNotifier<bool> isScrolled;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ValueListenableBuilder(
      valueListenable: isScrolled,
      builder: (context, isScrolled, _) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              if (isScrolled)
                BoxShadow(
                  color: AppColors.brightGrey.withOpacity(.4),
                  spreadRadius: 2,
                  blurRadius: 2,
                ),
            ],
          ),
          child: _tabBar,
        );
      },
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    required this.height,
    super.key,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 2.ms,
      height: height,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.lg * 2),
          topRight: Radius.circular(AppSpacing.lg * 2),
        ),
      ),
    );
  }
}

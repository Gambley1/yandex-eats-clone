import 'dart:async' show StreamSubscription;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/cart/bloc/cart_bloc.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/home/home.dart';
import 'package:papa_burger/src/menu/widgets/discount_card.dart';
import 'package:papa_burger/src/menu/widgets/menu_item_card.dart';
import 'package:papa_burger/src/menu/widgets/menu_section_header.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared/shared.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({required this.restaurant, required this.fromCart, super.key});

  final Restaurant restaurant;
  final bool fromCart;

  @override
  Widget build(BuildContext context) {
    return MenuView(restaurant: restaurant, fromCart: fromCart);
  }
}

class MenuView extends StatefulWidget {
  const MenuView({
    required this.restaurant,
    super.key,
    this.fromCart = false,
  });

  final Restaurant restaurant;
  final bool fromCart;

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView>
    with SingleTickerProviderStateMixin {
  late final _bloc = MenuBloc(restaurant: widget.restaurant);

  late final _menuModel = MenuModel(restaurant: widget.restaurant);
  late List<int> _discounts;
  late List<Menu> _menus;
  late TabController _tabController;
  bool _hasMenu = false;

  late List<String> _menusCategoriesName;

  late StreamSubscription<List<Menu>> _menusSubscription;

  @override
  void initState() {
    super.initState();
    _bloc.init();
    _menusSubscription = _bloc.getMenus.listen(
      _menuListener,
      onError: _onError,
      cancelOnError: true,
    );
  }

  void _onError(Object error) {
    logE(error);
    setState(() {
      _hasMenu = false;
      _menus = [];
      _discounts = [];
    });
  }

  void _menuListener(List<Menu> menu) {
    setState(() {
      _menus = menu;
      _discounts = _bloc.menuModel.getAvailableDiscounts(menu);
      _menusCategoriesName = menu.map((menu) => menu.category).toList();
      _tabController = TabController(length: menu.length, vsync: this);
      _bloc.tabController = _tabController;
      _hasMenu = menu.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    _menusSubscription.cancel();
    super.dispose();
  }

  ValueListenableBuilder<Cart> _buildBottomAppBar(BuildContext context) {
    GestureDetector buildDeliveryInfoBox(
      BuildContext context,
      Cart cart,
    ) =>
        GestureDetector(
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
                    size: 20,
                  ),
                ),
                if (cart.isDeliveryFree)
                  DiscountPrice(
                    defaultPrice: cart.deliveryFeeToString,
                    discountPrice: '0',
                    forDeliveryFee: true,
                    hasDiscount: false,
                  )
                else
                  Column(
                    children: [
                      Text(
                        'Delivery ${cart.deliveryFeeToString}',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'To Free delivery ${cart.deliveryFeeToString}',
                        textAlign: TextAlign.center,
                        style:
                            context.bodyMedium?.apply(color: AppColors.green),
                      ),
                    ],
                  ),
                const Positioned(
                  right: 0,
                  child: AppIcon(
                    icon: Icons.arrow_forward_ios_rounded,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        );

    InkWell buildOrderInfoBtn(BuildContext context, Cart cart) => InkWell(
          splashColor: Colors.grey.withOpacity(.1),
          borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
          onTap: () => context.pushNamed(AppRoutes.cart.name),
          child: Ink(
            width: double.infinity,
            height: 55,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
              color: AppColors.indigo,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  child: LimitedBox(
                    maxWidth: 120,
                    child: Text(
                      '30 - 40 min',
                      textAlign: TextAlign.center,
                      style: context.bodyMedium
                          ?.apply(color: AppColors.white.withOpacity(.7)),
                    ),
                  ),
                ),
                Text(
                  'Order',
                  style: context.bodyLarge
                      ?.copyWith(fontWeight: AppFontWeight.bold),
                ),
                Positioned(
                  right: 0,
                  child: Text(
                    cart.totalDelivery(),
                    style: context.bodyMedium
                        ?.apply(color: AppColors.white.withOpacity(.7)),
                  ),
                ),
              ],
            ),
          ),
        );

    return ValueListenableBuilder<Cart>(
      valueListenable: CartBloc(),
      builder: (context, cart, _) {
        final cartEmptyAndPlaceIdsNotEqual = cart.isCartEmpty ||
            cart.restaurantPlaceId != widget.restaurant.placeId;

        if (cartEmptyAndPlaceIdsNotEqual) {
          return const BottomAppBar(
            elevation: 0,
          );
        }
        return FadeAnimation(
          intervalEnd: 0.2,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.md + AppSpacing.sm + 6),
              topRight: Radius.circular(AppSpacing.md + AppSpacing.sm + 6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomAppBar(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md - AppSpacing.xxs,
                  ),
                  child: Column(
                    children: [
                      buildDeliveryInfoBox(context, cart),
                      const SizedBox(
                        height: 12,
                      ),
                      buildOrderInfoBtn(context, cart),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottomNavigationBar: _buildBottomAppBar(context),
      onPopInvoked: (didPop) {
        if (!didPop) return;
        if (widget.fromCart) {
          HomeConfig().goBranch(0);
        } else {
          context.pop();
        }
      },
      top: false,
      body: CustomScrollView(
        controller: _bloc.scrollController,
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            leading: Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.only(left: AppSpacing.md),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ValueListenableBuilder(
                valueListenable: _bloc.isScrolledNotifier,
                builder: (context, isScrolled, _) {
                  return AppIcon(
                    size: 24,
                    icon: isScrolled
                        ? LucideIcons.circleX
                        : LucideIcons.arrowLeft,
                    type: IconType.button,
                    onPressed: () {
                      widget.fromCart == true
                          ? HomeConfig().goBranch(0)
                          : context.pop();
                    },
                  );
                },
              ),
            ),
            pinned: true,
            expandedHeight: 300,
            flexibleSpace: ValueListenableBuilder(
              valueListenable: _bloc.isScrolledNotifier,
              builder: (context, isScrolled, child) {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: isScrolled
                      ? SystemUiOverlayTheme.restaurantViewSystemBarTheme
                      : SystemUiOverlayTheme.restaurantHeaderSystemBarTheme,
                  child: FlexibleSpaceBar(
                    expandedTitleScale: 2.2,
                    titlePadding: isScrolled
                        ? const EdgeInsets.only(left: 68, bottom: 16)
                        : const EdgeInsets.only(
                            left: AppSpacing.md,
                            bottom: 120,
                          ),
                    background: AppCachedImage(
                      placeIdToParse: widget.restaurant.placeId,
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      restaurantName: widget.restaurant.name,
                      imageType: CacheImageType.lg,
                      imageUrl: widget.restaurant.imageUrl,
                    ),
                    title: Hero(
                      tag: 'Menu${widget.restaurant.name}',
                      child: Text(
                        widget.restaurant.name,
                        maxLines: isScrolled ? 1 : 2,
                        style: context.bodyLarge?.apply(
                          color: isScrolled ? AppColors.black : AppColors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: ValueListenableBuilder<bool>(
                valueListenable: _bloc.isScrolledNotifier,
                builder: (context, isScrolled, child) {
                  return AnimatedContainer(
                    height: isScrolled ? 0 : 32.0,
                    duration: const Duration(milliseconds: 150),
                    child: CircularContainer(isScrolled: isScrolled),
                  );
                },
              ),
            ),
          ),
          if (_hasMenu && _bloc.tabs.value.isNotEmpty) ...[
            ValueListenableBuilder(
              valueListenable: _bloc.tabs,
              builder: (context, tabs, _) {
                return SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicator: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.md + AppSpacing.sm,
                        ),
                      ),
                      indicatorPadding: const EdgeInsets.all(6),
                      indicatorSize: TabBarIndicatorSize.tab,
                      onTap: _bloc.onCategorySelected,
                      unselectedLabelColor: Colors.black54,
                      labelColor: Colors.black,
                      tabs: tabs
                          .map((tab) => Tab(text: tab.menuCategory.category))
                          .toList(),
                    ),
                    _bloc.isScrolledNotifier,
                  ),
                );
              },
            ),
            DiscountCard(discounts: _discounts),
            for (int i = 0; i < _menusCategoriesName.length; i++) ...[
              MenuSectionHeader(
                categoryName: _menus[i].category,
                isSectionEmpty: false,
                categoryHeight: _bloc.categoryHeight,
              ),
              MenuItemCard(
                menuModel: _menuModel,
                menu: _menus[i],
              ),
            ],
          ] else
            const SliverFillRemaining(
              child: AppCircularProgressIndicator(color: Colors.black),
            ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this._isScrolledNotifier);

  final TabBar _tabBar;
  final ValueNotifier<bool> _isScrolledNotifier;

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
    return ValueListenableBuilder<bool>(
      valueListenable: _isScrolledNotifier,
      builder: (context, isScrolled, _) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: isScrolled
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
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
    required this.isScrolled,
    super.key,
  });

  final bool isScrolled;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
    );
  }
}

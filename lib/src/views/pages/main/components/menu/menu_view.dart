import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/views/pages/cart/state/cart_bloc.dart';
import 'package:papa_burger/src/views/pages/main/components/menu/components/discount_card.dart';
import 'package:papa_burger/src/views/pages/main/components/menu/components/menu_item_card.dart';
import 'package:papa_burger/src/views/pages/main/components/menu/components/menu_section_header.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

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
      _discounts = _bloc.menuModel.getDiscounts(menu);
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
                  child: CustomIcon(
                    icon: FontAwesomeIcons.taxi,
                    size: 20,
                    type: IconType.simpleIcon,
                  ),
                ),
                if (cart.freeDelivery)
                  DiscountPrice(
                    defaultPrice: cart.deliveryFeeString,
                    discountPrice: '0',
                    forDeliveryFee: true,
                    hasDiscount: false,
                  )
                else
                  Column(
                    children: [
                      KText(
                        text: 'Delivery ${cart.deliveryFeeString}',
                        textAlign: TextAlign.center,
                      ),
                      KText(
                        text: 'To Free delivery ${cart.toFreeDeliveryString}',
                        color: Colors.green,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                const Positioned(
                  right: 0,
                  child: CustomIcon(
                    icon: Icons.arrow_forward_ios_rounded,
                    size: 18,
                    type: IconType.simpleIcon,
                  ),
                ),
              ],
            ),
          ),
        );

    InkWell buildOrderInfoBtn(BuildContext context, Cart cart) => InkWell(
          splashColor: Colors.grey.withOpacity(.1),
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          onTap: () => context.navigateToCart(),
          child: Ink(
            width: double.infinity,
            height: 55,
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding + 4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              color: kPrimaryBackgroundColor,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  child: LimitedBox(
                    maxWidth: 120,
                    child: KText(
                      text: '30 - 40 min',
                      textAlign: TextAlign.center,
                      color: Colors.white.withOpacity(.7),
                    ),
                  ),
                ),
                const KText(
                  text: 'Order',
                  size: 19,
                  fontWeight: FontWeight.bold,
                ),
                Positioned(
                  right: 0,
                  child: KText(
                    text: cart.totalSum(),
                    color: Colors.white.withOpacity(.7),
                  ),
                ),
              ],
            ),
          ),
        );

    return ValueListenableBuilder<Cart>(
      valueListenable: CartBloc(),
      builder: (context, cart, _) {
        final cartEmptyAndPlaceIdsNotEqual = cart.cartEmpty ||
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
              topLeft: Radius.circular(kDefaultBorderRadius + 6),
              topRight: Radius.circular(kDefaultBorderRadius + 6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomAppBar(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultHorizontalPadding + 6,
                    vertical: kDefaultHorizontalPadding - 2,
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
          context.navigateToMainPage();
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
              margin: const EdgeInsets.only(left: kDefaultHorizontalPadding),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ValueListenableBuilder(
                valueListenable: _bloc.isScrolledNotifier,
                builder: (context, isScrolled, _) {
                  return CustomIcon(
                    size: 24,
                    icon: isScrolled
                        ? FontAwesomeIcons.xmark
                        : FontAwesomeIcons.arrowLeft,
                    type: IconType.iconButton,
                    onPressed: () {
                      widget.fromCart == true
                          ? context.navigateToMainPage()
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
                      ? SystemUiOverlayTheme.restaurantViewThemeData
                      : SystemUiOverlayTheme.restaurantHeaderThemeData,
                  child: FlexibleSpaceBar(
                    expandedTitleScale: 2.2,
                    titlePadding: isScrolled
                        ? const EdgeInsets.only(left: 68, bottom: 16)
                        : const EdgeInsets.only(
                            left: kDefaultHorizontalPadding,
                            bottom: 120,
                          ),
                    background: CachedImage(
                      placeIdToParse: widget.restaurant.placeId,
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      restaurantName: widget.restaurant.name,
                      imageType: CacheImageType.bigImage,
                      imageUrl: widget.restaurant.imageUrl,
                    ),
                    title: Hero(
                      tag: 'Menu${widget.restaurant.name}',
                      child: KText(
                        text: widget.restaurant.name,
                        maxLines: isScrolled ? 1 : 2,
                        size: 18,
                        color: isScrolled ? Colors.black : Colors.white,
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
                        borderRadius:
                            BorderRadius.circular(kDefaultBorderRadius),
                      ),
                      indicatorPadding: const EdgeInsets.all(6),
                      indicatorSize: TabBarIndicatorSize.tab,
                      onTap: _bloc.onCategorySelected,
                      unselectedLabelColor: Colors.black54,
                      labelStyle: defaultTextStyle(),
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
              child: CustomCircularIndicator(color: Colors.black),
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

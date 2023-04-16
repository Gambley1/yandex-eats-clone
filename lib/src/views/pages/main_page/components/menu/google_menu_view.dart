import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CacheImageType,
        CachedImage,
        Cart,
        CartBlocTest,
        CustomIcon,
        CustomScaffold,
        DisalowIndicator,
        DiscountCard,
        DiscountPrice,
        FadeAnimation,
        GoogleMenuModel,
        GoogleRestaurant,
        IconType,
        InkEffect,
        KText,
        MenuBloc,
        MenuSectionHeader,
        MyThemeData,
        NavigatorExtension,
        defaultTextStyle,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding,
        kPrimaryBackgroundColor;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

import 'components/google_menu_item_card.dart';

class GoogleMenuView extends StatefulWidget {
  final GoogleRestaurant restaurant;
  final bool fromCart;

  const GoogleMenuView({
    Key? key,
    required this.restaurant,
    this.fromCart = false,
  }) : super(key: key);

  @override
  State<GoogleMenuView> createState() => _GoogleMenuViewState();
}

class _GoogleMenuViewState extends State<GoogleMenuView>
    with SingleTickerProviderStateMixin {
  final cartBlocTest = CartBlocTest();
  late final _bloc = MenuBloc(restaurant: widget.restaurant);

  late final googleMenuModel = GoogleMenuModel(restaurant: widget.restaurant);
  late final discounts = googleMenuModel.getDiscounts();
  late final menus = googleMenuModel.getMenusWithPromotions();

  late final menusCategoriesName = menus.map((menu) => menu.category).toList();

  final _isScrolledNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _bloc.init(this);

    _bloc.scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    _isScrolledNotifier.value = _bloc.scrollController.offset > 230;
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  // _buildSliverAppBar(BuildContext context) => SliverAppBar(
  //       actionsIconTheme: const IconThemeData(
  //         color: Colors.black,
  //       ),
  //       iconTheme: const IconThemeData(
  //         color: Colors.black,
  //       ),
  //       leading: Container(
  //         height: 50,
  //         width: 50,
  //         margin: const EdgeInsets.only(left: kDefaultHorizontalPadding),
  //         alignment: Alignment.center,
  //         decoration: const BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: Colors.white,
  //         ),
  //         child: CustomIcon(
  //           size: 24,
  //           icon: FontAwesomeIcons.arrowLeft,
  //           type: IconType.iconButton,
  //           onPressed: () {
  //             widget.fromCart == true
  //                 ? context.navigateToMainPage()
  //                 : context.pop();
  //           },
  //         ),
  //       ),
  //       bottom: PreferredSize(
  //         preferredSize: const Size.fromHeight(0),
  //         child: _buildCircularContainer(),
  //       ),
  //       scrolledUnderElevation: 12,
  //       expandedHeight: 320,
  //       backgroundColor: Colors.transparent,
  //       flexibleSpace: AnnotatedRegion<SystemUiOverlayStyle>(
  //         value: MyThemeData.restaurantHeaderThemeData,
  //         child: CachedImage(
  //           placeIdToParse: widget.restaurant.placeId,
  //           height: MediaQuery.of(context).size.height,
  //           width: double.infinity,
  //           heroTag: widget.restaurant.name,
  //           restaurantName: widget.restaurant.name,
  //           inkEffect: InkEffect.noEffect,
  //           imageType: CacheImageType.bigImage,
  //           imageUrl: widget.restaurant.imageUrl,
  //         ),
  //       ),
  //     );

  _buildBottomAppBar(BuildContext context, CartBlocTest cartBlocTest) {
    buildDeliveryInfoBox(
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
                cart.freeDelivery
                    ? DiscountPrice(
                        defaultPrice: cart.deliveryFeeString,
                        discountPrice: '0',
                        forDeliveryFee: true,
                        hasDiscount: false,
                      )
                    : Column(
                        children: [
                          KText(
                            text: 'Delivery ${cart.deliveryFeeString}',
                            textAlign: TextAlign.center,
                          ),
                          KText(
                            text:
                                'To Free delivery ${cart.toFreeDeliveryString}',
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

    buildOrderInfoBtn(BuildContext context, Cart cart) => InkWell(
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
                  color: Colors.black,
                ),
                Positioned(
                  right: 0,
                  child: KText(
                    text: cart.totalSumm(),
                    color: Colors.white.withOpacity(.7),
                  ),
                ),
              ],
            ),
          ),
        );

    return ValueListenableBuilder<Cart>(
      valueListenable: cartBlocTest,
      builder: (context, cart, _) {
        final cartEmptyAndPlaceIdsNotEqual = cart.cartEmpty ||
            cart.restaurantPlaceId != widget.restaurant.placeId;

        if (cartEmptyAndPlaceIdsNotEqual) return const BottomAppBar();
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

  _buildUi(BuildContext context) {
    // return DefaultTabController(
    //   length: 3,
    //   child: CustomScaffold(
    //     withSafeArea: true,
    //     bottomNavigationBar: _buildBottomAppBar(context, cartBlocTest),
    //     onWillPop: () {
    //       if (widget.fromCart) {
    //         context.navigateToMainPage();
    //       } else {
    //         context.pop();
    //       }
    //       return Future.value(true);
    //     },
    //     top: false,
    //     body: CustomScrollView(
    //       controller: _scrollController,
    //       key: const PageStorageKey(menuRestaurantsKey),
    //       slivers: [
    //         _buildSliverAppBar(context),
    //         SliverToBoxAdapter(
    //           child: _buildCircularContainer(),
    //         ),
    //         DiscountCard(discounts: discounts),
    //         for (var i = 0; i < menusCategoriesName.length; i++,) ...[
    //           MenuSectionHeader(
    //             categorieName: googleMenuModel.restaurant.menu[i].category,
    //             isSectionEmpty:
    //                 googleMenuModel.restaurant.menu[i].items.isEmpty,
    //           ),
    //           GoogleMenuItemCard(
    //             googleMenuModel: googleMenuModel,
    //             menu: googleMenuModel.restaurant.menu[i],
    //           ),
    //         ],
    //       ],
    //     ).disalowIndicator(),
    //   ),
    // );
    return CustomScaffold(
      withSafeArea: true,
      bottomNavigationBar: _buildBottomAppBar(context, cartBlocTest),
      onWillPop: () {
        if (widget.fromCart) {
          context.navigateToMainPage();
        } else {
          context.pop();
        }
        return Future.value(true);
      },
      top: false,
      body: AnimatedBuilder(
        animation: _bloc,
        builder: (_, __) {
          return CustomScrollView(
            controller: _bloc.scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                leading: Container(
                  height: 50,
                  width: 50,
                  margin:
                      const EdgeInsets.only(left: kDefaultHorizontalPadding),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: CustomIcon(
                    size: 24,
                    icon: FontAwesomeIcons.arrowLeft,
                    type: IconType.iconButton,
                    onPressed: () {
                      widget.fromCart == true
                          ? context.navigateToMainPage()
                          : context.pop();
                    },
                  ),
                ),
                pinned: true,
                floating: false,
                snap: false,
                expandedHeight: 300,
                backgroundColor: Colors.white,
                flexibleSpace: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: MyThemeData.restaurantHeaderThemeData,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isScrolledNotifier,
                    builder: (context, isScrolled, _) {
                      return FlexibleSpaceBar(
                        expandedTitleScale: 2.2,
                        titlePadding: isScrolled
                            ? const EdgeInsets.only(left: 68, bottom: 16)
                            : const EdgeInsets.only(
                                left: kDefaultHorizontalPadding, bottom: 120),
                        background: CachedImage(
                          placeIdToParse: widget.restaurant.placeId,
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                          // heroTag: widget.restaurant.name,
                          restaurantName: widget.restaurant.name,
                          inkEffect: InkEffect.noEffect,
                          imageType: CacheImageType.bigImage,
                          imageUrl: widget.restaurant.imageUrl,
                        ),
                        title: Hero(
                          tag: widget.restaurant.name,
                          child: KText(
                            text: widget.restaurant.name,
                            maxLines: isScrolled ? 1 : 2,
                            size: 18,
                            color: isScrolled ? Colors.black : Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0.0),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isScrolledNotifier,
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
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _bloc.tabController,
                    isScrollable: true,
                    indicator: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                    ),
                    indicatorPadding: const EdgeInsets.all(6),
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: _bloc.onCategorySelected,
                    unselectedLabelColor: Colors.black54,
                    labelStyle: defaultTextStyle(),
                    labelColor: Colors.black,
                    tabs: _bloc.tabs
                        .map((tab) => Tab(text: tab.menuCategory.category))
                        .toList(),
                  ),
                  _isScrolledNotifier,
                ),
              ),
              DiscountCard(discounts: discounts),
              for (int i = 0; i < menusCategoriesName.length; i++) ...[
                MenuSectionHeader(
                  categoryName: menus[i].category,
                  isSectionEmpty: false,
                  categoryHeight: _bloc.categoryHeight,
                ),
                GoogleMenuItemCard(
                  googleMenuModel: googleMenuModel,
                  menu: menus[i],
                ),
              ]
            ],
          ).disalowIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.restaurantViewThemeData,
      child: Builder(
        builder: (context) => _buildUi(context),
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
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isScrolledNotifier,
      builder: (context, isScrolled, _) {
        return Container(
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
    return false;
  }
}

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    super.key,
    required this.isScrolled,
  });

  final bool isScrolled;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // height: isScrolled ? 0 : 32.0,
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

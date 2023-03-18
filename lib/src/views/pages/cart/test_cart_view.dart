import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show HapticFeedback, SystemUiOverlayStyle, SystemChrome;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons, FaIcon;
import 'package:page_transition/page_transition.dart'
    show PageTransition, PageTransitionType;
import 'package:papa_burger/src/restaurant.dart'
    show
        CacheImageType,
        CachedImage,
        Cart,
        CartBloc,
        CartListView,
        CartService,
        CartState,
        CustomButtonInShowDialog,
        CustomCircularIndicator,
        CustomIcon,
        DiscountPrice,
        ExpandedElevatedButton,
        FadeAnimation,
        GoogleRestaurant,
        IconType,
        InkEffect,
        Item,
        KText,
        MainPageService,
        NavigationBloc,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding,
        kPrimaryBackgroundColor,
        kPrimaryColor,
        logger;
import 'package:papa_burger/src/views/pages/main_page/components/menu/google_menu_view.dart';
import 'package:papa_burger/src/views/pages/main_page/test_main_page.dart';

class TestCartView extends StatefulWidget {
  const TestCartView({
    Key? key,
  }) : super(key: key);

  @override
  State<TestCartView> createState() => _TestCartViewState();
}

class _TestCartViewState extends State<TestCartView> {
  final CartService _cartService = CartService();

  late final NavigationBloc _navigationBloc;
  late final CartBloc _cartBloc;
  late GoogleRestaurant _restaurant;

  final Set<Item> _items = <Item>{};

  String _placeId = '';
  List<Item> _moreItemsToAdd = [];
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _navigationBloc = NavigationBloc();
    _cartBloc = _cartService.cartBloc;
    _subscribeToCart();
  }

  @override
  void dispose() {
    _cartBloc.dispose();
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _removeItems() async {
    setState(() {
      _subscription.cancel();
      _cartBloc.removeAllItemsFromCartAndRestaurantPlaceId();
      _subscription = _cartBloc.globalStreamTest.listen((state) {
        final cartItems = state.cart.cartItems;
        _items.removeAll(cartItems);
        // _cartBloc.cartItems.removeAll(cartItems);
        _moreItemsToAdd = [];
      });
    });
  }

  void _removeFromCart(Item item) {
    setState(() {
      _subscription.cancel();
      _cartBloc.removeItemFromCartItem(item);
      // _cartBloc.cartItems.remove(item);
      _items.remove(item);
      _updateMoreItems();
      _subscription = _cartBloc.globalStreamTest.listen((event) {});
    });
  }

  void _addToCart(Item item) {
    setState(() {
      _subscription.cancel();
      _cartBloc.addItemToCart(item);
      // _cartBloc.cartItems.add(item);
      _items.add(item);
      _updateMoreItems();
      _subscription = _cartBloc.globalStreamTest.listen((event) {});
    });
  }

  void _updateMoreItems() {
    _moreItemsToAdd = const Cart()
        .moreItemsToAddWithGoogleRestaurant(_restaurant, _items)
        .where((menuItem) => !_items.contains(menuItem))
        .toList();
  }

  void _subscribeToCart() {
    setState(() {
      _subscription = _cartBloc.globalStreamTest.listen((state) {
        final cartItems = state.cart.cartItems;
        _placeId = _cartBloc.placeId;
        _restaurant = _cartBloc.getRestaurantByPlaceId(
          _placeId,
          MainPageService().mainBloc.restaurantsPage$['restaurants'],
        );
        logger.i(cartItems);
        _items.addAll(cartItems);
        // _cartBloc.cartItems.addAll(cartItems);
        _updateMoreItems();
      });
    });
  }

  _buildAppBar(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding - 12,
        vertical: kDefaultHorizontalPadding,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            CustomIcon(
              icon: FontAwesomeIcons.arrowLeft,
              type: IconType.iconButton,
              onPressed: () {
                if (_placeId.isEmpty) {
                  setState(() {
                    _navigationBloc.navigation(0);
                  });
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                      child: const TestMainPage(),
                      type: PageTransitionType.fade,
                    ),
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    PageTransition(
                      child: GoogleMenuView(
                        restaurant: _restaurant,
                        imageUrl: '',
                        fromCart: true,
                      ),
                      type: PageTransitionType.fade,
                    ),
                  );
                }
              },
            ),
            const KText(
              text: 'Your cart',
              size: 26,
            ),
            const Spacer(),
            StreamBuilder<CartState>(
              stream: _cartBloc.globalStreamTest,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (_items.isEmpty) return Container();
                  if (_items.isNotEmpty && _cartBloc.placeId.isEmpty) {
                    return Container();
                  }
                  return CustomIcon(
                    type: IconType.iconButton,
                    onPressed: () {
                      _showCustomDialogToDeleteAllitems(context);
                    },
                    icon: FontAwesomeIcons.trash,
                    size: 21,
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  _showCustomDialogToDeleteAllitems(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const KText(
            text: 'Clear the Busket?',
            size: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius + 8),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding,
              vertical: kDefaultHorizontalPadding),
          actionsPadding: const EdgeInsets.fromLTRB(kDefaultHorizontalPadding,
              0, kDefaultHorizontalPadding, kDefaultHorizontalPadding),
          actions: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: const TestMainPage(),
                          type: PageTransitionType.fade,
                        ),
                        (route) => false,
                      );
                    },
                    child: CustomButtonInShowDialog(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      padding: const EdgeInsets.all(kDefaultHorizontalPadding),
                      colorDecoration: Colors.grey.shade200,
                      size: 18,
                      text: 'Cancel',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pop();
                      HapticFeedback.heavyImpact();
                      _removeItems().then((value) {
                        Navigator.pop(context);
                        Future.delayed(const Duration(seconds: 1)).then(
                          (value) => mounted
                              ? Navigator.pushAndRemoveUntil(
                                  context,
                                  PageTransition(
                                    child: GoogleMenuView(
                                      imageUrl: '',
                                      restaurant: _restaurant,
                                      fromCart: true,
                                    ),
                                    type: PageTransitionType.fade,
                                  ),
                                  (route) => false,
                                )
                              : null,
                        );
                      });
                    },
                    child: CustomButtonInShowDialog(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      padding: const EdgeInsets.all(kDefaultHorizontalPadding),
                      colorDecoration: kPrimaryColor,
                      size: 18,
                      text: 'Clear',
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _addMoreItems(BuildContext context, AsyncSnapshot snapshot) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: kDefaultHorizontalPadding),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 140,
          mainAxisSpacing: 12,
          crossAxisSpacing: 8,
          mainAxisExtent: 280,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = _moreItemsToAdd[index];
            final price = item.priceString;
            final name = item.name;
            final imageUrl = item.imageUrl;
            final priceTotal = const Cart().discountPriceWithGoogleRestaurant(
                index: index, restaurant: _restaurant, items: _items);
            // final quantity = const Cart().itemQuantity(_moreItemsToAdd);
            final discountPrice = '$priceTotal\$';

            final hasDiscount = item.discount != 0;

            final inCart = _items.contains(item);

            return Ink(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(22),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CachedImage(
                        inkEffect: InkEffect.noEffect,
                        imageUrl: imageUrl,
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: double.infinity,
                        imageType: CacheImageType.smallImage,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          hasDiscount
                              ? DiscountPrice(
                                  defaultPrice: price,
                                  discountPrice: discountPrice,
                                )
                              : KText(
                                  text: price,
                                  size: 22,
                                  maxLines: 1,
                                ),
                          KText(
                            text: name,
                            maxLines: 3,
                            size: 18,
                          ),
                          const KText(
                            size: 16,
                            text: '1g',
                            maxLines: 1,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      const Spacer(),
                      snapshot.connectionState == ConnectionState.waiting
                          ? ExpandedElevatedButton.inProgress(
                              backgroundColor: Colors.white,
                              label: '',
                              textColor: Colors.black,
                              radius: 22,
                            )
                          : GestureDetector(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                inCart
                                    ? _items.length <= 1
                                        ? _removeItems()
                                        : _removeFromCart(item)
                                    : _addToCart(item);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 35,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      kDefaultBorderRadius),
                                  color: Colors.white,
                                ),
                                child: inCart
                                    ? const CustomIcon(
                                        icon: FontAwesomeIcons.minus,
                                        type: IconType.simpleIcon,
                                        size: 16,
                                      )
                                    : const CustomIcon(
                                        icon: FontAwesomeIcons.plus,
                                        type: IconType.simpleIcon,
                                        size: 16,
                                      ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: _moreItemsToAdd.length,
        ),
      ),
    );
  }

  _buildLoading() => const SliverPadding(
        padding: EdgeInsets.only(top: 250),
        sliver: SliverToBoxAdapter(
          child: CustomCircularIndicator(color: Colors.black),
        ),
      );

  _buildEmptyCart(BuildContext context) {
    void navigateToMainPage() {
      setState(() {
        _navigationBloc.navigation(0);
      });
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: const TestMainPage(),
          type: PageTransitionType.fade,
        ),
        (route) => false,
      );
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 240),
        child: Column(
          children: [
            const KText(
              text: 'Your cart is empty',
              size: 28,
              fontWeight: FontWeight.bold,
            ),
            OutlinedButton.icon(
              icon: const FaIcon(
                FontAwesomeIcons.cartShopping,
                color: Colors.black54,
              ),
              onPressed: navigateToMainPage,
              label: const KText(
                text: 'Explore',
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTextWantToAddMore() => const SliverPadding(
        padding: EdgeInsets.fromLTRB(12, 6, 12, 0),
        sliver: SliverToBoxAdapter(
          child: KText(
            text: 'Want to add more?',
            size: 24,
          ),
        ),
      );

  _buildTotal(AsyncSnapshot<CartState> snapshot) {
    final loading = snapshot.connectionState == ConnectionState.waiting;
    final isActive = loading ? false : true;

    final total = snapshot.data!.cart.totalWithDeliveryFee();

    final deliveryFeeString = snapshot.data!.cart.deliveryFeeString;
    final greaterThanMinPrice = snapshot.data!.cart.greaterThanMinimumPrice;
    return Opacity(
      opacity: isActive ? 1 : 0.5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 110,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KText(
                    text: "${total.toStringAsFixed(1)}\$",
                    size: 24,
                  ),
                  greaterThanMinPrice
                      ? DiscountPrice(
                          color: Colors.green,
                          defaultPrice: deliveryFeeString,
                          discountPrice: 'Free',
                          size: 28,
                          subSize: 16,
                        )
                      : KText(
                          text: '$deliveryFeeString Delivery fee',
                          maxLines: 1,
                          size: 18,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w600,
                        ),
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                onTap: () {
                  !isActive ? null : _showBottomSheet(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                    color: kPrimaryBackgroundColor,
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: KText(
                      text: 'Make an Order',
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context) async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.black,
        statusBarBrightness: Brightness.dark,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kDefaultBorderRadius),
                  topRight: Radius.circular(kDefaultBorderRadius)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: const [
                KText(text: 'This is a show'),
              ],
            ),
          );
        },
      );
    }
  }

  _buildErrorCart() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 200),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            const KText(
              text: 'Unimplemented error occured',
              size: 24,
              fontWeight: FontWeight.w600,
            ),
            const KText(
              text: 'place id in cart is 0 and cart is not empty.',
              size: 20,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 48,
            ),
            TextButton(
              onPressed: () {
                _removeItems();
              },
              child: const KText(
                text: '> Try to clear your cart <',
                size: 20,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCartListView(BuildContext context) {
    decrementQuanitity(List<Item> items, Item item) {
      items.length <= 1 ? _removeItems() : _removeFromCart(item);
    }

    return StreamBuilder<CartState>(
      stream: _cartBloc.globalStreamTest,
      builder: (context, snapshot) {
        final cartEmpty = _items.isEmpty;
        final noData = !snapshot.hasData;
        if (noData) {
          return _buildLoading();
        }
        if (cartEmpty) {
          return _buildEmptyCart(context);
        }
        if (!cartEmpty && _cartBloc.placeId.isEmpty) {
          return _buildErrorCart();
        }
        return CartListView(
          items: _items,
          decrementQuanity: decrementQuanitity,
        );
      },
    );
  }

  _buildWantAddMoreText(BuildContext context) {
    return StreamBuilder<CartState>(
      stream: _cartBloc.globalStreamTest,
      builder: (context, snapshot) {
        return _moreItemsToAdd.isEmpty
            ? _buildEmpty()
            : _items.isEmpty && _cartBloc.placeId.isNotEmpty
                ? _buildEmpty()
                : _buildTextWantToAddMore();
      },
    );
  }

  _buildWantAddMoreItems(BuildContext context) {
    return StreamBuilder<CartState>(
      stream: _cartBloc.globalStreamTest,
      builder: (context, snapshot) {
        return _moreItemsToAdd.isEmpty
            ? _buildEmpty()
            : _items.isEmpty && _cartBloc.placeId.isNotEmpty
                ? _buildEmpty()
                : _addMoreItems(context, snapshot);
      },
    );
  }

  _buildCheckoutBottomBar(BuildContext context) {
    return FadeAnimation(
      intervalStart: 0.2,
      child: StreamBuilder<CartState>(
        stream: _cartBloc.globalStreamTest,
        builder: (context, snapshot) {
          return _items.isEmpty
              ? const BottomAppBar()
              : _cartBloc.placeId.isEmpty
                  ? const BottomAppBar()
                  : BottomAppBar(child: _buildTotal(snapshot));
        },
      ),
    );
  }

  _buildEmpty() => SliverToBoxAdapter(
        child: Container(),
      );

  _buildUi(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_placeId.isEmpty) {
          setState(() {
            _navigationBloc.navigation(0);
          });
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              child: const TestMainPage(),
              type: PageTransitionType.fade,
            ),
            (route) => false,
          );
        } else {
          Navigator.of(context).pushReplacement(
            PageTransition(
              child: GoogleMenuView(
                restaurant: _restaurant,
                imageUrl: '',
                fromCart: true,
              ),
              type: PageTransitionType.fade,
            ),
          );
        }
        return Future.value(true);
      },
      child: Scaffold(
        bottomNavigationBar: _buildCheckoutBottomBar(context),
        body: SafeArea(
          child: FadeAnimation(
            intervalEnd: 0.2,
            child: CustomScrollView(
              scrollBehavior: const ScrollBehavior(
                  androidOverscrollIndicator:
                      AndroidOverscrollIndicator.stretch),
              key: const PageStorageKey<String>(
                'cart_view_key',
              ),
              slivers: [
                _buildAppBar(context),
                _buildCartListView(context),
                _buildWantAddMoreText(context),
                _buildWantAddMoreItems(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return _buildUi(
          context,
        );
      },
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papa_burger/src/restaurant.dart';

class CartView extends StatefulWidget {
  const CartView({
    Key? key,
  }) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartService _cartService = CartService();
  final NavigationBloc _navigationBloc = NavigationBloc();

  late final CartBloc _cartBloc;
  Restaurant restaurant = const Restaurant.empty();

  late final Set<Item> items = <Item>{};

  int id = 0;
  List<Item> moreItemsToAdd = [];
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _cartBloc = _cartService.cartBloc;
    _subscribeToCart();
  }

  @override
  void dispose() {
    // _cartBloc.dispose();
    _subscription.cancel();
    super.dispose();
  }

  void _removeItems() {
    setState(() {
      _subscription.cancel();
      _cartBloc.removeAllItemsFromCartAndRestaurantId();
      _subscription = _cartBloc.globalStream.listen((state) {
        final cartItems = state.cart.cartItems;
        items.removeAll(cartItems);
        _cartBloc.cartItems.removeAll(cartItems);
        moreItemsToAdd = [];
      });
    });
  }

  void _removeFromCart(Item item) {
    setState(() {
      _subscription.cancel();
      _cartBloc.removeItemFromCartItem(item);
      _cartBloc.cartItems.remove(item);
      items.remove(item);
      _updateMoreItems();
      _subscription = _cartBloc.globalStream.listen((event) {});
    });
  }

  void _addToCart(Item item) {
    setState(() {
      _subscription.cancel();
      _cartBloc.addItemToCart(item);
      _cartBloc.cartItems.add(item);
      items.add(item);
      _updateMoreItems();
      _subscription = _cartBloc.globalStream.listen((event) {});
    });
  }

  void _updateMoreItems() {
    moreItemsToAdd = const Cart()
        .moreItemsToAdd(restaurant, items)
        .where((menuItem) => !items.contains(menuItem))
        .toList();
    logger.i('moreItemsToAdd is $moreItemsToAdd');
  }

  void _subscribeToCart() {
    setState(() {
      _subscription = _cartBloc.globalStream.listen((state) {
        final cartItems = state.cart.cartItems;
        id = _cartBloc.id;
        restaurant = _cartBloc.getRestaurantById(id);
        items.addAll(cartItems);
        _cartBloc.cartItems.addAll(cartItems);
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
                _subscription.cancel();
                if (id == 0) {
                  setState(() {
                    _subscription.cancel();
                    _navigationBloc.navigation(0);
                  });
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    _subscription.cancel();
                  });
                  Navigator.of(context).pushReplacement(
                    PageTransition(
                      child: MenuView(
                        restaurant: restaurant,
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
              stream: _cartBloc.globalStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (items.isEmpty) return Container();
                  if (items.isNotEmpty && _cartBloc.id == 0) return Container();
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
                      Navigator.pop(context);
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
                      HapticFeedback.heavyImpact();
                      Navigator.pop(context);
                      _removeItems();
                    },
                    child: CustomButtonInShowDialog(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      padding: const EdgeInsets.all(kDefaultHorizontalPadding),
                      colorDecoration: primaryColor,
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
            final item = moreItemsToAdd[index];
            final price = item.priceString;
            final name = item.name;
            final imageUrl = item.imageUrl;
            final priceTotal = const Cart().discountPrice(
                index: index, restaurant: restaurant, items: items);
            final quantity = const Cart().itemQuantity(moreItemsToAdd);
            final discountPrice = '$priceTotal\$';

            final hasDiscount = item.discount != 0;

            final inCart = _cartBloc.inCart(item);

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
                                    ? items.length <= 1
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
          childCount: moreItemsToAdd.length,
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
      Navigator.of(context).pop();
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

  _buildTotal() {
    final total = _cartBloc.state.cart.totalWithDeliveryFee;

    final deliveryFeeString = _cartBloc.state.cart.deliveryFeeString;
    final greaterThanMinPrice = _cartBloc.state.cart.greaterThanMinimumPrice;
    return Padding(
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
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            kDefaultBorderRadius,
                          ),
                          topRight: Radius.circular(
                            kDefaultBorderRadius,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [],
                      ),
                    );
                  },
                );
              },
              child: Ink(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                  color: primaryColor,
                ),
                child: const Align(
                  alignment: Alignment.center,
                  child: KText(
                    text: 'Make an Order',
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
              text: 'id in cart is 0 and cart is not empty.',
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
      stream: _cartBloc.globalStream,
      builder: (context, snapshot) {
        final cartEmpty = items.isEmpty;
        final noData = !snapshot.hasData;
        if (noData) {
          return _buildLoading();
        }
        if (cartEmpty) {
          return _buildEmptyCart(context);
        }
        if (!cartEmpty && _cartBloc.id == 0) {
          return _buildErrorCart();
        }
        return CartListView(
          items: items,
          decrementQuanity: decrementQuanitity,
        );
      },
    );
  }

  _buildWantAddMoreText(BuildContext context) {
    return StreamBuilder<CartState>(
      stream: _cartBloc.globalStream,
      builder: (context, snapshot) {
        return moreItemsToAdd.isEmpty
            ? _buildEmpty()
            : items.isEmpty && _cartBloc.id != 0
                ? _buildEmpty()
                : _buildTextWantToAddMore();
      },
    );
  }

  _buildWantAddMoreItems(BuildContext context) {
    return StreamBuilder<CartState>(
      stream: _cartBloc.globalStream,
      builder: (context, snapshot) {
        return moreItemsToAdd.isEmpty
            ? _buildEmpty()
            : items.isEmpty && _cartBloc.id != 0
                ? _buildEmpty()
                : _addMoreItems(context, snapshot);
      },
    );
  }

  _buildCheckoutBottomBar(BuildContext context) {
    return FadeAnimation(
      intervalStart: 0.2,
      child: StreamBuilder<CartState>(
        stream: _cartBloc.globalStream,
        builder: (context, snapshot) {
          return _cartBloc.cartEmpty
              ? const BottomAppBar()
              : _cartBloc.id == 0
                  ? const BottomAppBar()
                  : BottomAppBar(child: _buildTotal());
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
        if (id == 0) {
          setState(() {
            _navigationBloc.navigation(0);
          });
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushReplacement(
            PageTransition(
              child: MenuView(
                restaurant: restaurant,
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.globalThemeData,
      child: Builder(
        builder: (context) {
          return _buildUi(
            context,
          );
        },
      ),
    );
  }
}

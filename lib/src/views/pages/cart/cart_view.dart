// ignore_for_file: deprecated_member_use

import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show HapticFeedback, SystemUiOverlayStyle, SystemChrome;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons, FaIcon;
import 'package:page_transition/page_transition.dart'
    show PageTransition, PageTransitionType;
import 'package:papa_burger/src/config/utils/my_theme_data.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CacheImageType,
        CachedImage,
        Cart,
        CartBloc,
        CartItemsListView,
        CartService,
        CartState,
        CustomButtonInShowDialog,
        CustomCircularIndicator,
        CustomIcon,
        DiscountPrice,
        ExpandedElevatedButton,
        FadeAnimation,
        IconType,
        InkEffect,
        Item,
        KText,
        MenuView,
        NavigatorExtension,
        Restaurant,
        currency,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding,
        kPrimaryBackgroundColor,
        kPrimaryColor,
        logger,
        wait;

class CartView extends StatefulWidget {
  const CartView({
    Key? key,
  }) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartService _cartService = CartService();

  late final CartBloc _cartBloc;
  late Restaurant _restaurant;

  final Set<Item> _items = <Item>{};

  int _id = 0;
  List<Item> _moreItemsToAdd = [];
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
      _subscription = _cartBloc.globalStream.listen((event) {});
    });
  }

  void _addToCart(Item item) {
    setState(() {
      _subscription.cancel();
      _cartBloc.addItemToCart(item);
      // _cartBloc.cartItems.add(item);
      _items.add(item);
      _updateMoreItems();
      _subscription = _cartBloc.globalStream.listen((event) {});
    });
  }

  void _updateMoreItems() {
    _moreItemsToAdd = const Cart()
        .moreItemsToAdd(_restaurant, _items)
        .where((menuItem) => !_items.contains(menuItem))
        .toList();
  }

  void _subscribeToCart() {
    setState(() {
      _subscription = _cartBloc.globalStream.listen((state) {
        final cartItems = state.cart.cartItems;
        _id = _cartBloc.id;
        _restaurant = _cartBloc.getRestaurantById(_id);
        logger.i(cartItems);
        _items.addAll(cartItems);
        // _cartBloc.cartItems.addAll(cartItems);
        _updateMoreItems();
      });
    });
  }

  _buildAppBar(BuildContext context) {
    logger.w('Build App bar');
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
                if (_id == 0) {
                  context.pop();
                } else {
                  Navigator.of(context).pushReplacement(
                    PageTransition(
                      child: MenuView(
                        restaurant: _restaurant,
                        imageUrl: '',
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
                  if (_items.isEmpty) return Container();
                  if (_items.isNotEmpty && _cartBloc.id == 0) {
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
            final priceTotal = const Cart().discountPrice(
                index: index, restaurant: _restaurant, items: _items);
            // final quantity = const Cart().itemQuantity(_moreItemsToAdd);
            final discountPrice = '$priceTotal $currency';

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
                          DiscountPrice(
                            defaultPrice: price,
                            size: 22,
                            hasDiscount: hasDiscount,
                            discountPrice: discountPrice,
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
              onPressed: () => context.pop(),
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
                    text: "${total.toStringAsFixed(1)} $currency",
                    size: 24,
                  ),
                  DiscountPrice(
                    color: Colors.green,
                    defaultPrice: deliveryFeeString,
                    hasDiscount: greaterThanMinPrice,
                    discountPrice: 'Free',
                    size: 28,
                    subSize: 16,
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

    wait(1, sec: true);

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
    logger.w('Build Cart List View');

    return StreamBuilder<CartState>(
      stream: _cartBloc.globalStream,
      builder: (context, snapshot) {
        final cartEmpty = _items.isEmpty;
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
        return CartItemsListView(
          items: _items,
          decreaseQuantity: (context, item) {},
          increaseQuantity: (item) {},
          allowIncrease: (Item item) {
            return true;
          },
        );
      },
    );
  }

  _buildWantAddMoreText(BuildContext context) {
    return StreamBuilder<CartState>(
      stream: _cartBloc.globalStream,
      builder: (context, snapshot) {
        return _moreItemsToAdd.isEmpty
            ? _buildEmpty()
            : _items.isEmpty && _cartBloc.id != 0
                ? _buildEmpty()
                : _buildTextWantToAddMore();
      },
    );
  }

  _buildWantAddMoreItems(BuildContext context) {
    logger.w("Build Want Add More Items");
    return StreamBuilder<CartState>(
      stream: _cartBloc.globalStream,
      builder: (context, snapshot) {
        return _moreItemsToAdd.isEmpty
            ? _buildEmpty()
            : _items.isEmpty && _cartBloc.id != 0
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
          return _items.isEmpty
              ? const BottomAppBar()
              : _cartBloc.id == 0
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
        if (_id == 0) {
          context.pop();
        } else {
          Navigator.of(context).pushReplacement(
            PageTransition(
              child: MenuView(
                restaurant: _restaurant,
                imageUrl: '',
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
                androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
              ),
              key: const PageStorageKey('cart_view_key'),
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
    logger.w('Build Cart View');
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.cartViewThemeData,
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

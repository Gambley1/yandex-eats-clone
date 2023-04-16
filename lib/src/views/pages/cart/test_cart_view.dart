// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/restaurant.dart'
    show
        Cart,
        CartBlocTest,
        CartItemsListView,
        CartService,
        CustomIcon,
        CustomScaffold,
        GoogleRestaurant,
        IconType,
        Item,
        KText,
        MyThemeData,
        NavigatorExtension,
        logger,
        showCustomDialog;
import 'package:papa_burger/src/views/pages/cart/components/cart_bottom_app_bar.dart';

import 'components/checkout_modal_bottom_sheet.dart';

class TestCartView extends StatelessWidget{
  TestCartView({super.key});

  final CartService _cartService = CartService();
  late final CartBlocTest _cartBlocTest = _cartService.cartBlocTest;

  _buildAppBar(BuildContext context, GoogleRestaurant restaurant, Cart cart) {
    return SliverAppBar(
      title: const KText(
        text: 'Cart',
        size: 26,
        fontWeight: FontWeight.bold,
      ),
      leading: CustomIcon(
        icon: FontAwesomeIcons.arrowLeft,
        type: IconType.iconButton,
        onPressed: () => cart.restaurantPlaceId.isEmpty
            ? context.navigateToMainPage()
            : context.navigateToMenu(context, restaurant, fromCart: true),
      ),
      actions: cart.cartEmpty
          ? null
          : [
              CustomIcon(
                icon: FontAwesomeIcons.trash,
                size: 20,
                onPressed: () => _showDialogToClearCart(context, restaurant),
                type: IconType.iconButton,
              ),
            ],
      scrolledUnderElevation: 2,
      expandedHeight: 80,
      excludeHeaderSemantics: true,
      backgroundColor: Colors.white,
      pinned: true,
    );
  }

  _showDialogToClearCart(BuildContext context, GoogleRestaurant restaurant) {
    return showCustomDialog(
      context,
      onTap: () {
        context.pop(withHaptickFeedback: true);
        _cartBlocTest.removeAllItems().then((_) {
          _cartBlocTest.removePlaceIdInCacheAndCart();
          context.navigateToMenu(context, restaurant, fromCart: true);
        });
        return Future.value(true);
      },
      alertText: 'Clear the Busket?',
      actionText: 'Clear',
    );
  }

  _buildCartItemsListView(
      BuildContext context, GoogleRestaurant restaurant, Cart cart) {
    decreaseQuantity(BuildContext context, Item item) {
      _cartBlocTest.decreaseQuantity(context, item, restaurant: restaurant);
    }

    increaseQuantity(Item item) {
      _cartBlocTest.increaseQuantity(item);
    }

    buildWithCartItems(
      Set<Item> items,
      Function(BuildContext context, Item item) decrementQuantity,
      Function(Item item) increaseQuantity,
      Map<Item, int> itemsTest,
    ) {
      return CartItemsListView(
        items: items,
        decreaseQuantity: decreaseQuantity,
        increaseQuantity: increaseQuantity,
        itemsTest: itemsTest,
        allowIncrease: _cartBlocTest.allowIncrease,
      );
    }

    buildEmptyCart(BuildContext context) => SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 240),
            child: Column(
              children: [
                const KText(
                  text: 'Your Cart is Empty',
                  size: 26,
                  fontWeight: FontWeight.bold,
                ),
                OutlinedButton(
                  onPressed: () {
                    context.navigateToMainPage();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CustomIcon(
                        icon: FontAwesomeIcons.cartShopping,
                        type: IconType.simpleIcon,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      KText(
                        text: 'Explore',
                        size: 22,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    if (cart.cartEmpty) return buildEmptyCart(context);
    return buildWithCartItems(
      cart.cartItems,
      decreaseQuantity,
      increaseQuantity,
      cart.itemsTest,
    );
  }

  _showCheckoutModalBottomSheet(BuildContext context) => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return CheckoutModalBottomSheet();
        },
      );

  _buildUi(BuildContext context) {
    logger.w('Build UI');
    final restaurant =
        _cartBlocTest.getRestaurant(_cartBlocTest.value.restaurantPlaceId);

    return CustomScaffold(
      resizeToAvoidBottomInset: false,
      withSafeArea: true,
      bottomNavigationBar: CartBottomAppBar(
        info: '30-40 min',
        title: 'Right, next',
        onTap: () => _showCheckoutModalBottomSheet(context),
      ),
      onWillPop: () {
        if (_cartBlocTest.value.restaurantPlaceId.isEmpty) {
          context.navigateToMainPage();
        } else {
          context.navigateToMenu(context, restaurant, fromCart: true);
        }
        return Future.value(true);
      },
      body: ValueListenableBuilder<Cart>(
        valueListenable: _cartBlocTest,
        builder: (context, cart, _) {
          return CustomScrollView(
            scrollBehavior: const ScrollBehavior(
              androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
            ),
            slivers: [
              _buildAppBar(context, restaurant, cart),
              _buildCartItemsListView(context, restaurant, cart),
            ],
          );
        },
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
          return _buildUi(context);
        },
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/extensions/show_bottom_modal_sheet_extension.dart';
import 'package:papa_burger/src/config/utils/app_constants.dart';
import 'package:papa_burger/src/models/payment/credit_card.dart';
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
        LocationService,
        MyThemeData,
        NavigatorExtension,
        logger,
        showCustomDialog;
import 'package:papa_burger/src/views/pages/cart/components/cart_bottom_app_bar.dart';
import 'package:papa_burger/src/views/pages/cart/components/choose_payment_modal_bottom_sheet.dart';
import 'package:papa_burger/src/views/pages/cart/state/selected_card_notifier.dart';

class TestCartView extends StatelessWidget {
  TestCartView({super.key});

  final CartService _cartService = CartService();
  late final CartBlocTest _cartBlocTest = _cartService.cartBlocTest;

  SliverAppBar _buildAppBar(
    BuildContext context,
    GoogleRestaurant restaurant,
    Cart cart,
  ) {
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

  Future<dynamic> _showDialogToClearCart(
    BuildContext context,
    GoogleRestaurant restaurant,
  ) {
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

  Widget _buildCartItemsListView(
    BuildContext context,
    GoogleRestaurant restaurant,
    Cart cart,
  ) {
    void decreaseQuantity(BuildContext context, Item item) {
      _cartBlocTest.decreaseQuantity(context, item, restaurant: restaurant);
    }

    void increaseQuantity(Item item) {
      _cartBlocTest.increaseQuantity(item);
    }

    CartItemsListView buildWithCartItems(
      void Function(BuildContext context, Item item) decrementQuantity,
      void Function(Item item) increaseQuantity,
      Map<Item, int> itemsTest,
    ) {
      return CartItemsListView(
        decreaseQuantity: decreaseQuantity,
        increaseQuantity: increaseQuantity,
        cartItems: itemsTest,
        allowIncrease: _cartBlocTest.allowIncrease,
      );
    }

    SliverToBoxAdapter buildEmptyCart(BuildContext context) =>
        SliverToBoxAdapter(
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
      decreaseQuantity,
      increaseQuantity,
      cart.cartItems,
    );
  }

  Future<void> _showCheckoutModalBottomSheet(BuildContext context) {
    final locationService = LocationService();
    final cardNotifier = SelectedCardNotifier();

    late final locationNotifier = locationService.locationNotifier;

    SliverToBoxAdapter buildRow(
      BuildContext context,
      String title,
      String subtitle,
      IconData? icon,
      void Function()? onTap,
    ) {
      return SliverToBoxAdapter(
        child: ListTile(
          onTap: onTap,
          horizontalTitleGap: 0,
          contentPadding: const EdgeInsets.only(
            top: 12,
            left: 12,
            right: 12,
          ),
          leading: icon == null
              ? null
              : CustomIcon(
                  icon: icon,
                  size: 20,
                  type: IconType.simpleIcon,
                ),
          title: LimitedBox(
            maxWidth: 260,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(maxLines: 1, text: title),
                KText(
                  maxLines: 1,
                  text: subtitle,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(height: 12),
                const Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          trailing: const CustomIcon(
            icon: Icons.arrow_forward_ios_outlined,
            type: IconType.simpleIcon,
            size: 14,
          ),
        ),
      );
    }

    SliverToBoxAdapter buildRowWithInfo(
      BuildContext context, {
      bool forAddressInfo = true,
    }) {
      SliverToBoxAdapter addressInfo() => buildRow(
            context,
            'street ${locationNotifier.value}',
            'Leave an order comment please',
            FontAwesomeIcons.house,
            () => context.navigateToGoolgeMapView(),
          );

      SliverToBoxAdapter deliveryTimeInfo() => buildRow(
            context,
            'Delivery 30-40 minutes',
            'But it might even be faster',
            FontAwesomeIcons.clock,
            () => context.navigateToMainPage(),
          );

      if (forAddressInfo) return addressInfo();
      return deliveryTimeInfo();
    }

    Future<void> showChoosePaymentModalBottomSheet(BuildContext context) =>
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          ),
          builder: (context) {
            return ChoosePaymentModalBottomSheet();
          },
        );

    return context.showCustomModalBottomSheet(
      initialChildSize: 0.5,
      children: [
        buildRowWithInfo(context),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 12,
          ),
        ),
        buildRowWithInfo(context, forAddressInfo: false),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 6,
          ),
        ),
        ValueListenableBuilder<CreditCard>(
          valueListenable: cardNotifier,
          builder: (context, selectedCard, _) {
            final noSeletction = selectedCard == const CreditCard.empty();
            return SliverToBoxAdapter(
              child: ListTile(
                onTap: () => showChoosePaymentModalBottomSheet(context),
                title: KText(
                  text: noSeletction
                      ? 'Choose payment method'
                      : 'VISA •• ${selectedCard.number.characters.getRange(15, 19)}',
                  color: noSeletction ? Colors.red : Colors.black,
                ),
                trailing: const CustomIcon(
                  icon: Icons.arrow_forward_ios_sharp,
                  type: IconType.simpleIcon,
                  size: 14,
                ),
              ),
            );
          },
        ),
      ],
      isScrollControlled: true,
      scrollableSheet: true,
      bottomAppBar: CartBottomAppBar(
        info: 'Total',
        title: 'Pay',
        onTap: () => cardNotifier.value == const CreditCard.empty()
            ? showChoosePaymentModalBottomSheet(context)
            : () {},
      ),
    );
  }

  CustomScaffold _buildUi(BuildContext context) {
    logger.w('Build UI');
    final restaurant =
        _cartBlocTest.getRestaurant(_cartBlocTest.value.restaurantPlaceId);

    return CustomScaffold(
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
        builder: _buildUi,
      ),
    );
  }
}

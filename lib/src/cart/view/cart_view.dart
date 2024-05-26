import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/cart/bloc/cart_bloc.dart';
import 'package:papa_burger/src/cart/bloc/selected_card_notifier.dart';
import 'package:papa_burger/src/cart/widgets/cart_bottom_app_bar.dart';
import 'package:papa_burger/src/cart/widgets/cart_items_list_view.dart';
import 'package:papa_burger/src/cart/widgets/choose_payment_modal_bottom_sheet.dart';
import 'package:papa_burger/src/cart/widgets/progress_bar_modal_bottom_sheet.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/home/home.dart';
import 'package:papa_burger/src/home/services/services.dart';
import 'package:papa_burger/src/menu/menu.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared/shared.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  Restaurant _restaurant = const Restaurant.empty();

  @override
  void initState() {
    super.initState();
    CartBloc()
        .getRestaurant(CartBloc().value.restaurantPlaceId)
        .then((restaurant) {
      setState(() => _restaurant = restaurant);
    });
  }

  Widget _buildCartItemsListView(
    BuildContext context,
    Restaurant restaurant,
    Cart cart,
  ) {
    void decreaseQuantity(BuildContext context, Item item) {
      CartBloc().decreaseItemQuantity(context, item, restaurant: restaurant);
    }

    void increaseQuantity(Item item) {
      CartBloc().increaseItemQuantity(item);
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
        allowIncrease: CartBloc().canIncreaseItemQuantity,
      );
    }

    Widget buildEmptyCart(BuildContext context) => SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your cart is empty',
                style: context.headlineSmall,
              ),
              ShadButton.outline(
                onPressed: context.pop,
                text: const Text('Explore'),
                icon: const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.sm),
                  child: Icon(LucideIcons.shoppingCart),
                ),
              ),
            ],
          ),
        );

    if (cart.isCartEmpty) return buildEmptyCart(context);
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
            top: AppSpacing.md,
            left: AppSpacing.md,
            right: AppSpacing.md,
          ),
          leading: icon == null
              ? null
              : AppIcon(
                  icon: icon,
                  size: 20,
                ),
          title: LimitedBox(
            maxWidth: 260,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1),
                Text(
                  subtitle,
                  maxLines: 1,
                  style: context.bodyMedium
                      ?.apply(color: AppColors.grey.withOpacity(.5)),
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          trailing: const AppIcon(
            icon: Icons.arrow_forward_ios_outlined,
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
            'Leave an order comment please 🙏',
            LucideIcons.home,
            () => context.pushNamed(AppRoutes.googleMap.name),
          );

      SliverToBoxAdapter deliveryTimeInfo() => buildRow(
            context,
            'Delivery 15-30 minutes',
            'But it might even be faster',
            LucideIcons.clock,
            () => HomeConfig().goBranch(0),
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
            borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
          ),
          builder: (context) {
            return ChoosePaymentModalBottomSheet();
          },
        );

    Future<void> showOrderProgressModalBottomSheet(BuildContext context) =>
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
          ),
          builder: (context) {
            return const OrderProgressBarModalBottomSheet();
          },
        );

    return context.showCustomModalBottomSheet(
      initialChildSize: 0.5,
      children: [
        buildRowWithInfo(context),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppSpacing.md,
          ),
        ),
        buildRowWithInfo(context, forAddressInfo: false),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppSpacing.sm,
          ),
        ),
        ValueListenableBuilder<CreditCard>(
          valueListenable: cardNotifier,
          builder: (context, selectedCard, _) {
            final noSelection = selectedCard == const CreditCard.empty();
            return SliverToBoxAdapter(
              child: ListTile(
                onTap: () => showChoosePaymentModalBottomSheet(context),
                title: Text(
                  noSelection
                      ? 'Choose credit card'
                      : 'VISA •• '
                          '${selectedCard.number.characters.getRange(15, 19)}',
                  style: context.bodyMedium
                      ?.apply(color: noSelection ? Colors.red : Colors.black),
                ),
                trailing: const AppIcon(
                  icon: Icons.arrow_forward_ios_sharp,
                  size: 14,
                ),
              ),
            );
          },
        ),
      ],
      isScrollControlled: true,
      scrollableSheet: true,
      bottomAppBar: ValueListenableBuilder(
        valueListenable: cardNotifier,
        builder: (context, selectedCard, _) {
          return CartBottomAppBar(
            info: 'Total',
            title: 'Pay',
            onTap: selectedCard == const CreditCard.empty()
                ? () => showChoosePaymentModalBottomSheet(context)
                : () {
                    showOrderProgressModalBottomSheet(context);
                  },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottomNavigationBar: CartBottomAppBar(
        info: '30-40 min',
        title: 'Right, next',
        onTap: () => _showCheckoutModalBottomSheet(context),
      ),
      onPopInvoked: (didPop) {
        if (!didPop) return;
        if (CartBloc().value.restaurantPlaceId.isEmpty) {
          HomeConfig().goBranch(0);
        } else {
          context.pushNamed(
            AppRoutes.menu.name,
            extra: MenuProps(
              restaurant: _restaurant,
              fromCart: true,
            ),
          );
        }
      },
      body: ValueListenableBuilder<Cart>(
        valueListenable: CartBloc(),
        builder: (context, cart, _) {
          return CustomScrollView(
            slivers: [
              CartAppBar(cart: cart, restaurant: _restaurant),
              _buildCartItemsListView(context, _restaurant, cart),
            ],
          );
        },
      ),
    );
  }
}

class CartAppBar extends StatelessWidget {
  const CartAppBar({
    required this.cart,
    required this.restaurant,
    super.key,
  });

  final Restaurant restaurant;
  final Cart cart;

  Future<void> _showClearCartDialog({
    required BuildContext context,
    required Restaurant restaurant,
  }) =>
      context.showCustomDialog(
        onTap: () {
          context.pop();
          CartBloc().removeAllItems().then((_) {
            CartBloc().resetRestaurantPlaceId();
            context.pushNamed(
              AppRoutes.menu.name,
              extra: MenuProps(
                restaurant: restaurant,
                fromCart: true,
              ),
            );
          });
        },
        alertText: 'Clear the cart?',
        actionText: 'Clear',
      );

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        'Cart',
        style: context.headlineMedium?.copyWith(fontWeight: AppFontWeight.bold),
      ),
      leading: AppIcon(
        icon: Icons.adaptive.arrow_back_sharp,
        type: IconType.button,
        onPressed: cart.restaurantPlaceId.isEmpty
            ? () {
                context.pop();
              }
            : () => context.pushNamed(
                  AppRoutes.menu.name,
                  extra: MenuProps(
                    restaurant: restaurant,
                    fromCart: true,
                  ),
                ),
      ),
      actions: cart.isCartEmpty
          ? null
          : [
              AppIcon(
                icon: LucideIcons.trash,
                size: 20,
                onPressed: () => _showClearCartDialog(
                  context: context,
                  restaurant: restaurant,
                ),
                type: IconType.button,
              ),
            ],
      scrolledUnderElevation: 2,
      expandedHeight: 80,
      excludeHeaderSemantics: true,
      backgroundColor: Colors.white,
      pinned: true,
    );
  }
}

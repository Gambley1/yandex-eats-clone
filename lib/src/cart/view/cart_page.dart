import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/cart/cart.dart';
import 'package:yandex_food_delivery_clone/src/menu/menu.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Future<void> _showCheckoutModalBottomSheet(BuildContext context) {
    return context.showScrollableModal(
      initialChildSize: .45,
      minChildSize: .2,
      snapSizes: [.45],
      maxChildSize: .45,
      pageBuilder: (scrollController, _) => CheckoutModalView(
        scrollController: scrollController,
      ),
    );
  }

  Future<void> _showRestaurantClosedDialog(BuildContext context) =>
      context.showInfoDialog(
        title: 'Restaurant closed',
        content: "You can't order when restaurant is closed.",
      );

  @override
  Widget build(BuildContext context) {
    final restaurant = context.select((CartBloc bloc) => bloc.state.restaurant);
    final isCartEmpty =
        context.select((CartBloc bloc) => bloc.state.isCartEmpty);
    final isOpened = context
        .select((CartBloc bloc) => bloc.state.restaurant?.openNow ?? false);

    return AppScaffold(
      bottomNavigationBar: CartBottomBar(
        info: restaurant?.formattedDeliveryTime() ?? '15 - 20 min',
        title: 'Next',
        onPressed: () => isOpened
            ? _showCheckoutModalBottomSheet(context)
            : _showRestaurantClosedDialog(context),
      ),
      onPopInvoked: (didPop) {
        if (!didPop || restaurant == null) return;
        return context.goNamed(
          AppRoutes.menu.name,
          extra: MenuProps(restaurant: restaurant),
        );
      },
      body: CustomScrollView(
        slivers: [
          const CartAppBar(),
          if (isCartEmpty) const CartEmptyView() else const CartItemsListView(),
        ],
      ),
    );
  }
}

class CartEmptyView extends StatelessWidget {
  const CartEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your cart is empty',
            style: context.titleLarge,
          ),
          ShadButton.outline(
            onPressed: context.pop,
            icon: const Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm),
              child: Icon(LucideIcons.shoppingCart),
            ),
            child: const Text('Explore'),
          ),
        ],
      ),
    );
  }
}

class CartAppBar extends StatelessWidget {
  const CartAppBar({super.key});

  Future<void> _showClearCartDialog({required BuildContext context}) =>
      context.confirmAction(
        title: 'Clear cart',
        content: 'Are you sure to clear the cart?',
        yesText: 'Yes, clear',
        noText: 'No, keep it',
        fn: () {
          context.pop();
          context.read<CartBloc>().add(
            CartClearRequested(
              goToCart: (restaurant) {
                if (restaurant == null) {
                  return context.goNamed(AppRoutes.restaurants.name);
                }
                context.goNamed(
                  AppRoutes.menu.name,
                  extra: MenuProps(restaurant: restaurant),
                );
              },
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final restaurant = context.select((CartBloc bloc) => bloc.state.restaurant);
    final isCartEmpty =
        context.select((CartBloc bloc) => bloc.state.isCartEmpty);

    return SliverAppBar(
      title: Text(
        'Cart',
        style: context.headlineSmall,
      ),
      leading: AppIcon.button(
        icon: Icons.adaptive.arrow_back_sharp,
        onTap: restaurant == null
            ? () => context.pop()
            : () {
                context.goNamed(
                  AppRoutes.menu.name,
                  extra: MenuProps(
                    restaurant: restaurant,
                  ),
                );
              },
      ),
      actions: isCartEmpty
          ? null
          : [
              AppIcon.button(
                icon: LucideIcons.trash,
                onTap: () => _showClearCartDialog(context: context),
              ),
            ],
      scrolledUnderElevation: 2,
      expandedHeight: 80,
      excludeHeaderSemantics: true,
      pinned: true,
    );
  }
}

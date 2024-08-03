import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared/shared.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/cart/cart.dart';
import 'package:yandex_food_delivery_clone/src/menu/menu.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Future<void> _showCheckoutModalBottomSheet(BuildContext context) {
    return context.showScrollableModal(
      initialChildSize: 0.5,
      minChildSize: .3,
      pageBuilder: (scrollController, _) => CheckoutModalBottomView(
        scrollController: scrollController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = context.select((CartBloc bloc) => bloc.state.restaurant);
    final isCartEmpty =
        context.select((CartBloc bloc) => bloc.state.isCartEmpty);

    return AppScaffold(
      bottomNavigationBar: CartBottomAppBar(
        info: restaurant?.formattedDeliveryTime() ?? '15 - 20 min',
        title: 'Right, next',
        onPressed: () => _showCheckoutModalBottomSheet(context),
      ),
      onPopInvoked: (didPop) {
        if (!didPop) return;
        if (restaurant == null) return context.pop();
        return context.pushReplacementNamed(
          AppRoutes.menu.name,
          extra: MenuProps(
            restaurant: restaurant,
            fromCart: true,
          ),
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
  }
}

class CartAppBar extends StatelessWidget {
  const CartAppBar({super.key});

  Future<void> _showClearCartDialog({required BuildContext context}) =>
      context.confirmAction(
        title: 'Are you sure to clear the cart?',
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
                  extra: MenuProps(
                    restaurant: restaurant,
                    fromCart: true,
                  ),
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
      surfaceTintColor: AppColors.white,
      title: Text(
        'Cart',
        style: context.headlineSmall?.copyWith(fontWeight: AppFontWeight.bold),
      ),
      leading: AppIcon.button(
        icon: Icons.adaptive.arrow_back_sharp,
        onTap: restaurant == null
            ? () => context.pop()
            : () {
                logI('Push replacement');
                context.pushReplacementNamed(
                  AppRoutes.menu.name,
                  extra: MenuProps(
                    restaurant: restaurant,
                    fromCart: true,
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
      backgroundColor: AppColors.white,
      pinned: true,
    );
  }
}

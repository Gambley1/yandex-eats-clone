// ignore_for_file: lines_longer_than_80_chars

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/cart/cart.dart';
import 'package:yandex_food_delivery_clone/src/map/map.dart';
import 'package:yandex_food_delivery_clone/src/payments/payments.dart';

class CheckoutModalBottomView extends StatelessWidget {
  const CheckoutModalBottomView({required this.scrollController, super.key});

  final ScrollController scrollController;

  Future<void> _showChoosePaymentModalBottomSheet(BuildContext context) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return const ChoosePaymentBottomView();
        },
      );

  Future<void> _showOrderProgressModalBottomSheet(BuildContext context) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.white,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
        ),
        builder: (context) {
          return const OrderProgressBottomPage();
        },
      );

  @override
  Widget build(BuildContext context) {
    final address = context.select((LocationBloc bloc) => bloc.state.address);
    final restaurant = context.select((CartBloc bloc) => bloc.state.restaurant);
    final selectedCard =
        context.select((SelectedCardCubit cubit) => cubit.state.selectedCard);

    return AppScaffold(
      bottomNavigationBar: CartBottomAppBar(
        info: 'Total',
        title: 'Pay',
        onPressed: selectedCard.isEmpty
            ? () => _showChoosePaymentModalBottomSheet(context)
            : () {
                _showOrderProgressModalBottomSheet(context);
              },
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckoutInfoTile(
              onTap: () => context.pushNamed(AppRoutes.googleMap.name),
              icon: LucideIcons.house,
              title: 'Street: $address',
              subtitle: 'Leave an order comment please 🙏',
            ),
            const SizedBox(height: AppSpacing.md),
            CheckoutInfoTile(
              onTap: () =>
                  context.pushReplacementNamed(AppRoutes.restaurants.name),
              title:
                  'Delivery ${restaurant?.formattedDeliveryTime() ?? '10 - 20 min'}',
              subtitle: 'But it might even be faster',
              icon: LucideIcons.clock,
            ),
            const SizedBox(height: AppSpacing.sm),
            ListTile(
              onTap: () => _showChoosePaymentModalBottomSheet(context),
              title: Text(
                selectedCard.isEmpty
                    ? 'Choose credit card'
                    : 'VISA •• '
                        '${selectedCard.number.characters.getRange(15, 19)}',
                style: context.bodyMedium?.apply(
                  color: selectedCard.isEmpty ? AppColors.red : AppColors.black,
                ),
              ),
              trailing: const AppIcon(
                icon: Icons.arrow_forward_ios_sharp,
                iconSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutInfoTile extends StatelessWidget {
  const CheckoutInfoTile({
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final VoidCallback onTap;
  final IconData? icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: AppSpacing.md,
      leading: icon == null
          ? null
          : AppIcon(
              icon: icon!,
              iconSize: 20,
            ),
      title: LimitedBox(
        maxWidth: 260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(maxLines: 1, title),
            Text(
              subtitle,
              maxLines: 1,
              style: context.bodyMedium?.apply(color: AppColors.grey),
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
          ],
        ),
      ),
      trailing: AppIcon(
        icon: Icons.adaptive.arrow_forward_sharp,
        iconSize: 14,
      ),
    );
  }
}

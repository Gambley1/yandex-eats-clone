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

class CheckoutModalView extends StatelessWidget {
  const CheckoutModalView({required this.scrollController, super.key});

  final ScrollController scrollController;

  Future<void> _showChoosePaymentModalBottomSheet(BuildContext context) =>
      context.showScrollableModal(
        initialChildSize: .4,
        minChildSize: .2,
        snapSizes: [.4],
        maxChildSize: .4,
        pageBuilder: (scrollController, _) {
          return PaymentsModalView(
            scrollController: scrollController,
          );
        },
      );

  Future<void> _showOrderProgressModalBottomSheet(BuildContext context) =>
      context.showBottomModal(
        isDismissible: false,
        enableDrag: false,
        builder: (context) => const PaymentProcessModalPage(),
      );

  @override
  Widget build(BuildContext context) {
    final address = context.select((LocationBloc bloc) => bloc.state.address);
    final restaurant = context.select((CartBloc bloc) => bloc.state.restaurant);
    final selectedCard =
        context.select((SelectedCardCubit cubit) => cubit.state.selectedCard);

    return AppScaffold(
      bottomNavigationBar: CartBottomBar(
        info: 'Total',
        title: 'Pay',
        onPressed: () => selectedCard.isEmpty
            ? _showChoosePaymentModalBottomSheet(context)
            : _showOrderProgressModalBottomSheet(context),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckoutInfoTile(
              onTap: () => context
                ..pop()
                ..pushNamed(AppRoutes.googleMap.name),
              icon: LucideIcons.house,
              title: '$address',
              padding: const EdgeInsetsDirectional.only(
                start: AppSpacing.lg,
                end: AppSpacing.xlg,
                top: AppSpacing.md,
              ),
              // subtitle: 'Leave an order comment please 🙏',
            ),
            const SizedBox(height: AppSpacing.md),
            CheckoutInfoTile(
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
              ),
              titleTextStyle: context.bodyMedium?.apply(
                color: selectedCard.isEmpty ? AppColors.red : AppColors.black,
              ),
              trailing: AppIcon(
                icon: Icons.adaptive.arrow_forward,
                iconSize: AppSize.xs,
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
    required this.title,
    required this.icon,
    this.subtitle,
    this.onTap,
    this.padding,
    super.key,
  });

  final VoidCallback? onTap;
  final IconData? icon;
  final String title;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: AppSpacing.md,
      contentPadding: padding,
      leading: icon == null
          ? null
          : AppIcon(
              icon: icon!,
              iconSize: AppSize.md,
            ),
      title: LimitedBox(
        maxWidth: 260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(maxLines: 1, title),
            if (subtitle != null) ...[
              Text(
                subtitle!,
                maxLines: 1,
                style: context.bodyMedium?.apply(color: AppColors.grey),
              ),
            ],
            const Divider(),
          ],
        ),
      ),
      trailing: onTap == null
          ? null
          : AppIcon(
              icon: Icons.adaptive.arrow_forward_sharp,
              iconSize: AppSize.xs,
            ),
    );
  }
}

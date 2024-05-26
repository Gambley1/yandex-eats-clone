import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:papa_burger/src/cart/bloc/cart_bloc.dart';
import 'package:shared/shared.dart';

class CartBottomAppBar extends StatelessWidget {
  const CartBottomAppBar({
    required this.info,
    required this.title,
    required this.onTap,
    super.key,
  });

  final String info;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Row buildCartInfo(BuildContext context, Cart cart) => Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cart.totalDelivery(), style: context.headlineMedium),
                Text(info),
              ],
            ),
            const SizedBox(
              width: 46,
            ),
            Expanded(
              child: InkWell(
                borderRadius:
                    BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
                onTap: onTap,
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.xlg,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
                    color: AppColors.indigo,
                  ),
                  child: Align(
                    child: Text(title, style: context.titleLarge),
                  ),
                ),
              ),
            ),
          ],
        );

    return ValueListenableBuilder<Cart>(
      valueListenable: CartBloc(),
      builder: (context, cart, _) {
        if (cart.isCartEmpty) return const SizedBox();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomAppBar(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg + AppSpacing.xxs,
                vertical: AppSpacing.md - AppSpacing.xxs,
              ),
              child: buildCartInfo(context, cart),
            ),
          ],
        );
      },
    );
  }
}

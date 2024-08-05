import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_delivery_clone/src/cart/bloc/cart_bloc.dart';

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    required this.info,
    required this.title,
    required this.onPressed,
    super.key,
  });

  final String info;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.isCartEmpty) return const SizedBox.shrink();
        return AppBottomBar(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.formattedTotalDelivery(),
                        style: context.headlineSmall
                            ?.copyWith(fontWeight: AppFontWeight.medium),
                      ),
                      Text(info),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ShadButton(
                    width: double.infinity,
                    onPressed: onPressed,
                    text: Text(title),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

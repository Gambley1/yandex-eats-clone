import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        Cart,
        CartBlocTest,
        KText,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding,
        kPrimaryBackgroundColor;

class CartBottomAppBar extends StatelessWidget {
  CartBottomAppBar({
    super.key,
    required this.info,
    required this.title,
    required this.onTap,
  });

  final String info, title;
  final Function() onTap;

  final CartBlocTest _cartBlocTest = CartBlocTest();

  @override
  Widget build(BuildContext context) {
    buildCartInfo(BuildContext context, Cart cart) => Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: cart.totalSumm(),
                  size: 28,
                ),
                KText(
                  text: info,
                )
              ],
            ),
            const SizedBox(
              width: 46,
            ),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                onTap: onTap,
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultHorizontalPadding + 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                    color: kPrimaryBackgroundColor,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: KText(
                      text: title,
                      size: 19,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

    return ValueListenableBuilder<Cart>(
      valueListenable: _cartBlocTest,
      builder: (context, cart, _) {
        if (cart.cartEmpty) return const SizedBox();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomAppBar(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultHorizontalPadding + 6,
                vertical: kDefaultHorizontalPadding - 2,
              ),
              child: buildCartInfo(context, cart),
            ),
          ],
        );
      },
    );
  }
}

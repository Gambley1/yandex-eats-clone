import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart' show KText, currency;

class DiscountPrice extends StatelessWidget {
  const DiscountPrice({
    required this.defaultPrice,
    required this.discountPrice,
    required this.hasDiscount,
    super.key,
    this.forDeliveryFee = false,
    this.size = 22,
    this.subSize = 14,
    this.color,
  });

  final double size;
  final double subSize;
  final String defaultPrice;
  final String discountPrice;
  final bool hasDiscount;
  final bool forDeliveryFee;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (hasDiscount) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          KText(
            text: '$discountPrice ',
            color: color ?? Colors.orange.shade800,
            size: size,
            maxLines: 1,
          ),
          LinedText(
            defaultPrice: defaultPrice,
            subSize: subSize,
          ),
        ],
      );
    }
    if (forDeliveryFee) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          KText(
            text: 'Delivery $discountPrice$currency ',
            maxLines: 1,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
          LinedText(defaultPrice: defaultPrice, subSize: subSize),
        ],
      );
    }
    return KText(
      text: defaultPrice,
      size: size,
    );
  }
}

class LinedText extends StatelessWidget {
  const LinedText({
    required this.defaultPrice,
    required this.subSize,
    super.key,
  });

  final String defaultPrice;
  final double subSize;

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: 70,
      child: Column(
        children: [
          const SizedBox(
            height: 3,
          ),
          KText(
            text: defaultPrice,
            decoration: TextDecoration.lineThrough,
            color: Colors.grey,
            size: subSize,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

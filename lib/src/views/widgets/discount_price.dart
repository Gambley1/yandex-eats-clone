import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart';

class DiscountPrice extends StatelessWidget {
  const DiscountPrice({
    super.key,
    required this.defaultPrice,
    required this.discountPrice,
    this.size = 22,
    this.subSize = 14,
    this.color,
  });

  final double size;
  final double subSize;
  final String defaultPrice;
  final String discountPrice;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        KText(
          text: '$discountPrice ',
          color: color ?? Colors.orange.shade800,
          size: size,
          maxLines: 1,
        ),
        Column(
          children: [
            KText(
              text: defaultPrice,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
              size: subSize,
              maxLines: 1,
            ),
            const SizedBox(
              height: 2,
            ),
          ],
        ),
      ],
    );
  }
}

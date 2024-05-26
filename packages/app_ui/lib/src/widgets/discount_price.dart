// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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
          Text(
            '$discountPrice ',
            maxLines: 1,
            style: context.bodyMedium?.copyWith(
              color: color ?? Colors.orange.shade800,
              fontSize: size,
            ),
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
          Text(
            'Delivery $discountPrice',
            maxLines: 1,
            style: context.bodyMedium?.copyWith(
              color: AppColors.green,
              fontWeight: AppFontWeight.bold,
            ),
          ),
          LinedText(defaultPrice: defaultPrice, subSize: subSize),
        ],
      );
    }
    return Text(
      defaultPrice,
      style: context.bodyMedium?.copyWith(fontSize: size),
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
          const SizedBox(height: AppSpacing.xs),
          Text(
            defaultPrice,
            maxLines: 1,
            style: context.bodyMedium?.copyWith(
              color: AppColors.grey,
              decoration: TextDecoration.lineThrough,
              fontSize: subSize,
            ),
          ),
        ],
      ),
    );
  }
}

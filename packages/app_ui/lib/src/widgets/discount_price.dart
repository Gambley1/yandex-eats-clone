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
    this.size,
    this.subSize,
    this.color,
    this.defaultPriceStyle,
    this.discountPriceStyle,
  });

  final double? size;
  final double? subSize;
  final String defaultPrice;
  final TextStyle? defaultPriceStyle;
  final String discountPrice;
  final TextStyle? discountPriceStyle;
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
            style: (discountPriceStyle ?? context.bodyMedium)?.copyWith(
              color: color ?? AppColors.orange,
              fontSize: size,
            ),
          ),
          LinedText(
            defaultPrice: defaultPrice,
            defaultPriceStyle: defaultPriceStyle,
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
            'Delivery $discountPrice ',
            maxLines: 1,
            style: (defaultPriceStyle ?? context.bodyMedium)?.copyWith(
              color: AppColors.green,
              fontWeight: AppFontWeight.bold,
            ),
          ),
          LinedText(
            defaultPrice: defaultPrice,
            subSize: subSize,
            defaultPriceStyle: defaultPriceStyle,
          ),
        ],
      );
    }
    return Text(
      defaultPrice,
      style: context.titleLarge
          ?.copyWith(fontWeight: AppFontWeight.medium, fontSize: size),
    );
  }
}

class LinedText extends StatelessWidget {
  const LinedText({
    required this.defaultPrice,
    this.subSize,
    super.key,
    this.defaultPriceStyle,
  });

  final String defaultPrice;
  final TextStyle? defaultPriceStyle;
  final double? subSize;

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
            overflow: TextOverflow.ellipsis,
            style: (defaultPriceStyle ?? context.bodyMedium)?.copyWith(
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

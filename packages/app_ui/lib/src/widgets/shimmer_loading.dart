// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' show Shimmer;

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
    this.height,
    this.radius,
    this.width,
    this.shape,
  });

  final double? height;
  final double? radius;
  final double? width;
  final BoxShape? shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 0),
        shape: shape ?? BoxShape.rectangle,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade100,
        highlightColor: Colors.grey.shade200,
        period: const Duration(seconds: 1),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius ?? 0),
          ),
        ),
      ),
    );
  }
}

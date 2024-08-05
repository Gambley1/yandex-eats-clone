// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

typedef PlaceholderImageBuilder = Widget Function(double width, double height);

class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({
    this.width,
    this.height,
    this.radius,
    this.borderRadius,
    this.baseColor = const Color(0xff2d2f2f),
    this.baseColorLight = const Color(0xFFEFF6FC),
    this.highlightColor = const Color(0xff13151b),
    this.highlightColorLight = const Color(0xFFE6F1FB),
    this.withAdaptiveColors = true,
    this.child,
    super.key,
    this.placeholderImageBuilder,
  });

  const ShimmerPlaceholder.rectangle({
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor = const Color(0xff2d2f2f),
    this.baseColorLight = const Color(0xFFEFF6FC),
    this.highlightColor = const Color(0xff13151b),
    this.highlightColorLight = const Color(0xFFE6F1FB),
    this.withAdaptiveColors = true,
    this.child,
    super.key,
    this.placeholderImageBuilder,
  }) : radius = null;

  const ShimmerPlaceholder.circular({
    required this.radius,
    this.baseColor = const Color(0xff2d2f2f),
    this.baseColorLight = const Color(0xFFEFF6FC),
    this.highlightColor = const Color(0xff13151b),
    this.highlightColorLight = const Color(0xFFE6F1FB),
    this.withAdaptiveColors = true,
    this.child,
    super.key,
    this.placeholderImageBuilder,
  })  : width = null,
        height = null,
        borderRadius = null;

  final bool withAdaptiveColors;
  final Color baseColor;
  final Color? baseColorLight;
  final Color highlightColor;
  final Color? highlightColorLight;
  final double? radius;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final PlaceholderImageBuilder? placeholderImageBuilder;

  @override
  Widget build(BuildContext context) {
    final width = this.width ?? double.infinity;
    final height = this.height ?? double.infinity;

    final baseColor = withAdaptiveColors
        ? context.customReversedAdaptiveColor(
            dark: this.baseColor,
            light: baseColorLight,
          )
        : this.baseColor;
    final highlightColor = withAdaptiveColors
        ? context.customReversedAdaptiveColor(
            dark: this.highlightColor,
            light: highlightColorLight,
          )
        : this.highlightColor;

    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: child ??
            placeholderImageBuilder?.call(width, height) ??
            (radius != null
                ? _DefaultCircularPlaceholder(radius: radius!)
                : _DefaultPlaceholder(width: width, height: height)),
      ),
    );
  }
}

class _DefaultCircularPlaceholder extends StatelessWidget {
  const _DefaultCircularPlaceholder({required this.radius});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: Assets.images.placeholder.provider(),
      radius: radius,
    );
  }
}

class _DefaultPlaceholder extends StatelessWidget {
  const _DefaultPlaceholder({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Assets.images.placeholder.image(
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}

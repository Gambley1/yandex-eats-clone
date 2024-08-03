// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

enum _IndicatorVariant { normal, adaptive }

class AppCircularProgressIndicator extends StatelessWidget {
  const AppCircularProgressIndicator({
    this.color,
    super.key,
    this.strokeWidth = 3,
  }) : _variant = _IndicatorVariant.normal;

  const AppCircularProgressIndicator.adaptive({
    this.color,
    super.key,
    this.strokeWidth = 3,
  }) : _variant = _IndicatorVariant.adaptive;

  final _IndicatorVariant _variant;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _variant == _IndicatorVariant.adaptive
          ? CircularProgressIndicator.adaptive(
              backgroundColor: color,
              strokeWidth: strokeWidth,
            )
          : CircularProgressIndicator(
              color: color,
              strokeWidth: strokeWidth,
            ),
    );
  }
}

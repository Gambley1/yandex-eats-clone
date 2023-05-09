import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart' show Separator, kDefaultSizedboxH, kDefaultSizedboxW;

class SeparatorBuilder extends StatelessWidget {
  final Separator? separatorBuilder;
  final int index;
  final bool vertical, horizontal;
  final double width, height;

  const SeparatorBuilder({
    super.key,
    this.separatorBuilder,
    this.vertical = false,
    this.horizontal = true,
    this.index = 0,
    this.width = kDefaultSizedboxW,
    this.height = kDefaultSizedboxH,
  });

  @override
  Widget build(BuildContext context) {
    if (separatorBuilder != null) {
      return separatorBuilder!(context, index);
    }
    if (horizontal) {
      return SizedBox(
        width: width,
      );
    }
    return SizedBox(
      height: height,
    );
  }
}

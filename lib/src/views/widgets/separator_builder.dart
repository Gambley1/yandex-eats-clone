import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show Separator, kDefaultSizedboxH, kDefaultSizedboxW;

class SeparatorBuilder extends StatelessWidget {
  const SeparatorBuilder({
    super.key,
    this.separatorBuilder,
    this.vertical = false,
    this.horizontal = true,
    this.index = 0,
    this.width = kDefaultSizedboxW,
    this.height = kDefaultSizedboxH,
  });
  final Separator? separatorBuilder;
  final int index;
  final bool vertical;
  final bool horizontal;
  final double width;
  final double height;

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

import 'package:flutter/material.dart'
    show BuildContext, EdgeInsets, Padding, StatelessWidget, Widget;
import 'package:papa_burger/src/restaurant.dart' show KText;

class DotSeparator extends StatelessWidget {
  const DotSeparator({
    super.key,
    required this.padding,
  });

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: const KText(text: '•'),
    );
  }
}

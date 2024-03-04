import 'package:flutter/material.dart'
    show BuildContext, EdgeInsets, Padding, StatelessWidget, Widget;
import 'package:papa_burger/src/views/widgets/k_text.dart';

class DotSeparator extends StatelessWidget {
  const DotSeparator({
    required this.padding,
    super.key,
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

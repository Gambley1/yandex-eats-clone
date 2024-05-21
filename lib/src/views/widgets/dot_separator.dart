import 'package:flutter/material.dart';

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
      child: const Text('•'),
    );
  }
}

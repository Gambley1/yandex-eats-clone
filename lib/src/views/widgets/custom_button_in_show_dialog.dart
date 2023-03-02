import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart';

class CustomButtonInShowDialog extends StatelessWidget {
  const CustomButtonInShowDialog({
    Key? key,
    required this.padding,
    required this.borderRadius,
    required this.text,
    required this.size,
    required this.colorDecoration,
  }) : super(key: key);

  final BorderRadiusGeometry borderRadius;
  final String text;
  final double size;
  final Color colorDecoration;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: padding,
      decoration: BoxDecoration(
        color: colorDecoration,
        borderRadius: borderRadius,
      ),
      child: LimitedBox(
        child: Center(
          child: KText(
            text: text,
            size: size,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

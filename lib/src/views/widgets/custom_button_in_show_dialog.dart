import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CustomButtonInShowDialog extends StatelessWidget {
  const CustomButtonInShowDialog({
    required this.padding,
    required this.borderRadius,
    required this.text,
    required this.colorDecoration,
    super.key,
  });

  final BorderRadiusGeometry borderRadius;
  final String text;
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
        child: Center(child: Text(text, style: context.bodyLarge)),
      ),
    );
  }
}

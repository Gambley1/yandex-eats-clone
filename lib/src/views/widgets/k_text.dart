import 'package:flutter/material.dart';
import 'package:papa_burger/src/config/utils/app_constants.dart';

class KText extends StatelessWidget {
  const KText({
    required this.text,
    super.key,
    this.letterSpacing,
    this.color = Colors.black,
    this.size = 16,
    this.textOverflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.w500,
    this.maxLines = 2,
    this.decoration = TextDecoration.none,
  });

  final int maxLines;
  final double size;
  final double? letterSpacing;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final TextOverflow textOverflow;
  final TextDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      style: defaultTextStyle(
        color: color,
        decoration: decoration,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        size: size,
      ),
      overflow: textOverflow,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

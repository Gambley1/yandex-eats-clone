import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KText extends StatelessWidget {
  const KText({
    Key? key,
    required this.text,
    this.letterSpacing,
    this.color = Colors.black,
    this.size = 16,
    this.textOverflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.justify,
    this.fontWeight = FontWeight.w500,
    this.maxLines = 2,
    this.decoration = TextDecoration.none,
  }) : super(key: key);

  final int maxLines;
  final double? size, letterSpacing;
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
      style: GoogleFonts.getFont(
        'Quicksand',
        textStyle: TextStyle(
          decoration: decoration,
          color: color,
          fontWeight: fontWeight,
          fontSize: size,
          letterSpacing: letterSpacing,
        ),
      ),
      overflow: textOverflow,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

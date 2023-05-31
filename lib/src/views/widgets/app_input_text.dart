// ignore_for_file: avoid_multiple_declarations_per_line, inference_failure_on_untyped_parameter, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:papa_burger/src/restaurant.dart'
    show defaultTextStyle, kDefaultHorizontalPadding;

class AppInputText extends StatelessWidget {
  const AppInputText({
    super.key,
    this.hintText,
    this.textController,
    this.errorText,
    this.onTap,
    this.focusNode,
    this.onChanged,
    this.textInputAction,
    this.obscureText,
    this.autoCorrect,
    this.enabled,
    this.suffixIcon,
    this.prefixIcon,
    this.borderRadius,
    this.focusedBorder,
    this.enabledBorder,
    this.disabledBorder,
    this.contentPaddingTop,
    this.textInputType,
    this.inputFormatters,
    this.validator,
    this.floatingLabelBehaviour,
    this.labelText,
    this.autofocus,
    this.border,
    this.contentPadding,
    this.fontSize,
    this.initialValue,
    this.decoration,
  });

  factory AppInputText.withoutBorder({
    Key? key,
    String? hintText,
    String? labelText,
    String? errorText,
    String? initialValue,
    TextEditingController? textController,
    VoidCallback? onTap,
    FocusNode? focusNode,
    void Function(String)? onChanged,
    TextInputAction? textInputAction,
    bool? obscureText,
    bool? autoCorrect,
    bool? enabled,
    bool? autofocus,
    Widget? suffixIcon,
    Icon? prefixIcon,
    double? fontSize,
    TextInputType? textInputType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    FloatingLabelBehavior? floatingLabelBehaviour,
  }) =>
      AppInputText(
        key: key,
        contentPadding: const EdgeInsets.only(top: 12),
        textController: textController,
        initialValue: initialValue,
        focusNode: focusNode,
        textInputType: textInputType,
        inputFormatters: inputFormatters,
        onTap: onTap,
        onChanged: onChanged,
        autoCorrect: autoCorrect ?? true,
        textInputAction: textInputAction,
        obscureText: obscureText ?? false,
        validator: validator,
        autofocus: autofocus ?? false,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: floatingLabelBehaviour,
          floatingLabelStyle: GoogleFonts.getFont(
            'Quicksand',
            textStyle: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
          labelText: labelText,
          hintText: hintText,
          errorText: errorText,
          errorMaxLines: 2,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          iconColor: Colors.grey,
          suffixIconColor: Colors.grey,
          prefixIconColor: Colors.grey,
          enabled: enabled ?? true,
          labelStyle: GoogleFonts.getFont(
            'Quicksand',
            textStyle: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w400,
              fontSize: fontSize ?? 18,
            ),
          ),
          hintStyle: GoogleFonts.getFont(
            'Quicksand',
            textStyle: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
          errorStyle: const TextStyle(fontSize: 14),
          contentPadding: const EdgeInsets.only(
            top: kDefaultHorizontalPadding,
          ),
        ),
      );

  final String? hintText, labelText, errorText, initialValue;
  final TextEditingController? textController;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final bool? obscureText, autoCorrect, enabled, autofocus;
  final Widget? suffixIcon;
  final Icon? prefixIcon;
  final double? borderRadius, contentPaddingTop, fontSize;
  final InputBorder? focusedBorder, enabledBorder, disabledBorder, border;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final FloatingLabelBehavior? floatingLabelBehaviour;
  final EdgeInsetsGeometry? contentPadding;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      initialValue: initialValue,
      focusNode: focusNode,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      onTap: onTap,
      onChanged: onChanged,
      autocorrect: autoCorrect ?? true,
      textInputAction: textInputAction,
      obscureText: obscureText ?? false,
      validator: validator,
      cursorColor: Colors.blue,
      autofocus: autofocus ?? false,
      decoration: decoration ??
          InputDecoration(
            alignLabelWithHint: true,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            floatingLabelBehavior: floatingLabelBehaviour,
            floatingLabelStyle: defaultTextStyle(
              size: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
            labelText: labelText,
            hintText: hintText,
            errorText: errorText,
            enabledBorder: enabledBorder,
            disabledBorder: disabledBorder,
            focusedBorder: focusedBorder,
            errorMaxLines: 2,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            iconColor: Colors.grey,
            suffixIconColor: Colors.grey,
            prefixIconColor: Colors.grey,
            enabled: enabled ?? true,
            labelStyle: defaultTextStyle(
              size: fontSize ?? 18,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
            hintStyle: defaultTextStyle(
              size: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
            border: border,
            errorStyle: const TextStyle(fontSize: 14),
            contentPadding: contentPadding ??
                EdgeInsets.only(
                  right: 16,
                  left: 16,
                  top: contentPaddingTop ?? 13,
                ),
          ),
    );
  }
}

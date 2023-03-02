// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart';

class AppInputText extends StatefulWidget {
  const AppInputText({
    Key? key,
    required this.labelText,
    this.textController,
    this.errorText,
    this.onTap,
    this.focusNode,
    this.onChanged,
    this.textInputAction,
    this.isTextShown,
    this.autoCorrect,
    this.enabled,
    this.suffixIcon,
    this.prefixIcon,
    this.borderRadius,
    this.focusedBorder,
    this.enabledBorder,
    this.disabledBorder,
    this.contentPaddingTop,
  }) : super(key: key);

  final String labelText;
  final TextEditingController? textController;
  final String? errorText;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final bool? isTextShown;
  final bool? autoCorrect;
  final bool? enabled;
  final Widget? suffixIcon;
  final Icon? prefixIcon;
  final double? borderRadius;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final double? contentPaddingTop;

  @override
  State<AppInputText> createState() => _AppInputTextState();
}

class _AppInputTextState extends State<AppInputText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      focusNode: widget.focusNode,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      autocorrect: widget.autoCorrect ?? true,
      textInputAction: widget.textInputAction,
      obscureText: widget.isTextShown ?? false,
      decoration: InputDecoration(
        enabledBorder: widget.enabledBorder,
        disabledBorder: widget.disabledBorder,
        focusedBorder: widget.focusedBorder,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        enabled: widget.enabled ?? true,
        hintText: widget.labelText,
        errorText: widget.errorText,
        hintStyle: AppFont.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 6),
        ),
        contentPadding: EdgeInsets.only(
          right: AppDimen.w16,
          left: AppDimen.w16,
          top: widget.contentPaddingTop ?? AppDimen.h14,
        ),
      ),
    );
  }
}

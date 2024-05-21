import 'package:flutter/material.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/views/widgets/k_text.dart';

class CustomModalBottomSheet extends StatelessWidget {
  const CustomModalBottomSheet({
    required this.content,
    super.key,
    this.title,
    this.withAdditionalPadding = true,
  });

  final bool withAdditionalPadding;
  final String? title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LimitedBox(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        child: Ink(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(kDefaultBorderRadius),
              topRight: Radius.circular(kDefaultBorderRadius),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title == null)
                  Container()
                else
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: withAdditionalPadding
                          ? kDefaultHorizontalPadding + 12
                          : kDefaultHorizontalPadding + 12,
                      vertical: kDefaultHorizontalPadding + 8,
                    ),
                    child: KText(
                      text: title!,
                      size: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                content,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        DisalowIndicator,
        KText,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding;

class CustomModalBottomSheet extends StatelessWidget {
  const CustomModalBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.withAdditionalPadding = true,
  });

  final bool withAdditionalPadding;
  final String title;
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: withAdditionalPadding
                        ? kDefaultHorizontalPadding + 12
                        : kDefaultHorizontalPadding + 12,
                    vertical: kDefaultHorizontalPadding + 8,
                  ),
                  child: KText(
                    text: title,
                    size: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content,
              ],
            ),
          ).disalowIndicator(),
        ),
      ),
    );
  }
}

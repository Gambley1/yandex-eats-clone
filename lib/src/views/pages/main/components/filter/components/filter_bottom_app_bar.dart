import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        KText,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding,
        kDefaultVerticalPadding,
        kPrimaryBackgroundColor;

class FilterBottomAppBar extends StatelessWidget {
  const FilterBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding,
              vertical: kDefaultVerticalPadding - 4,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              onTap: () {},
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  vertical: kDefaultHorizontalPadding + 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                  color: kPrimaryBackgroundColor,
                ),
                child: const Align(
                  child: KText(
                    text: 'Apply',
                    size: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

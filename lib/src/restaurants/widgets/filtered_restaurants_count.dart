// ignore_for_file: lines_longer_than_80_chars

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class FilteredRestaurantsCount extends StatelessWidget {
  const FilteredRestaurantsCount({
    required this.count,
    super.key,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Found $count ${count == 1 ? 'restaurant' : 'restaurants'}',
      style: context.titleLarge?.copyWith(fontWeight: AppFontWeight.semiBold),
    );
  }
}

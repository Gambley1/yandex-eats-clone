import 'package:flutter/material.dart';
import 'package:papa_burger/src/error/error.dart';

class RestaurantsErrorView extends StatelessWidget {
  const RestaurantsErrorView({
    required this.onTryAgain,
    super.key,
  });

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(child: ErrorView(onTryAgain: onTryAgain));
  }
}

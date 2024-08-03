import 'package:flutter/material.dart';
import 'package:yandex_food_delivery_clone/src/error/error.dart';

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

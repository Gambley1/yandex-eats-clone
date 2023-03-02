// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart';

class RestaurantView extends StatelessWidget {
  const RestaurantView({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      top: false,
      child: Scaffold(
        body: Center(
          child: KText(
            text: 'Restaurant View',
            size: 24,
          ),
        ),
      ),
    );
  }
}

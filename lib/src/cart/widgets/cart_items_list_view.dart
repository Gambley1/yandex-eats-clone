import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/cart/cart.dart';

class CartItemsListView extends StatelessWidget {
  const CartItemsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderDeliveryFee =
        context.select((CartBloc bloc) => bloc.state.orderDeliveryFee);
    final cartItems = context.select((CartBloc bloc) => bloc.state.items);

    return SliverList.list(
      children: [
        ...ListTile.divideTiles(
          context: context,
          tiles: [
            ...cartItems.map((item) {
              return CartItemCard(key: ValueKey(item.id), item: item);
            }),
            ListTile(
              title: const Text('Delivered by Yandex'),
              trailing: Text(
                orderDeliveryFee.currencyFormat(),
              ),
              leadingAndTrailingTextStyle: context.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}

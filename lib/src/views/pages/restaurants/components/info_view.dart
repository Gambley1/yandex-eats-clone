import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:papa_burger/src/restaurant.dart'
    show Cart, CartBlocTest, CartService, CustomIcon, CustomScaffold, IconType, Item, NavigatorExtension;

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartService cartService = CartService();
    late final CartBlocTest cartBlocTest = cartService.cartBlocTest;

    const item = Item(
      name: 'Coca Cola',
      description: 'Very good drink',
      discount: 10,
      imageUrl: '',
      price: 5,
    );

    contains(Cart cart) => cart.cartItems.contains(item);

    return CustomScaffold(
      withSafeArea: true,
      body: ValueListenableBuilder<Cart>(
        valueListenable: cartBlocTest,
        builder: (context, cart, child) {
          return Row(
            children: [
              CustomIcon(
                icon: FontAwesomeIcons.backward,
                type: IconType.iconButton,
                onPressed: () => context.pop(),
              ),
              CustomIcon(
                icon: contains(cart)
                    ? FontAwesomeIcons.minus
                    : FontAwesomeIcons.plus,
                type: IconType.iconButton,
                onPressed: () {
                  // testNotifier.addItem(item);
                  // testNotifier2.updateName('Updated Name');
                  contains(cart)
                      ? cartBlocTest.removeItemFromCart(item)
                      : cartBlocTest.addItemToCart(item, placeId: '');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

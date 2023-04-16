import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/restaurant.dart'
    show
        Cart,
        CartBlocTest,
        CustomIcon,
        CustomScaffold,
        IconType,
        KText,
        logger;

class RestaurantView extends StatelessWidget {
  const RestaurantView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.w('Build Restaurant View');
    final CartBlocTest cartBlocTest = CartBlocTest();

    return CustomScaffold(
      withReleaseFocus: true,
      withSafeArea: true,
      body: Center(
        child: ValueListenableBuilder<Cart>(
          valueListenable: cartBlocTest,
          builder: (context, cart, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KText(text: cart.restaurantPlaceId),
                  ],
                ),
                cart.cartEmpty
                    ? Row(
                        children: [
                          const KText(text: 'Cart is Empty'),
                          CustomIcon(
                            icon: FontAwesomeIcons.minus,
                            type: IconType.iconButton,
                            onPressed: () {
                              cartBlocTest.removePlaceIdInCacheAndCart();
                            },
                          ),
                        ],
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final item = cart.cartItems.toList()[index];
                            return ListTile(
                              title: KText(text: item.name),
                              subtitle: KText(
                                text: item.description,
                                color: Colors.grey,
                                size: 16,
                              ),
                              trailing: CustomIcon(
                                icon: FontAwesomeIcons.xmark,
                                type: IconType.iconButton,
                                onPressed: () =>
                                    cartBlocTest.removeItemFromCart(item),
                              ),
                            );
                          },
                          itemCount: cart.cartItems.length,
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/views/pages/cart/state/cart_bloc.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';
import 'package:shared/shared.dart';

class MenuItemCard extends StatefulWidget {
  const MenuItemCard({
    required this.menuModel,
    required this.menu,
    super.key,
  });

  final MenuModel menuModel;
  final Menu menu;

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  late final restaurantPlaceId = widget.menuModel.restaurant.placeId;
  late final menuModel = widget.menuModel;
  late final menu = widget.menu;

  Future<void> _showDialogToClearCart(
    Item menuItem,
    String placeId,
  ) {
    return showCustomDialog(
      context,
      onTap: () {
        context.pop(withHapticFeedback: true);
        CartBloc().addItemToCartAfterCallingClearCart(
          menuItem,
          placeId,
        );
      },
      alertText: 'Need to clear a cart for a new order',
      actionText: 'Clear',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Cart>(
      valueListenable: CartBloc(),
      builder: (context, cart, snapshot) {
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
              mainAxisExtent: 330,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final menuItem = menu.items[index];

                final name = menuItem.name;
                final description = menuItem.description;
                final price = menuModel.priceString(menuItem);
                final discountPrice = Menu.priceWithDiscountToString(menuItem);
                final hasDiscount = menuModel.hasDiscount(menuItem);
                final quantity = cart.quantity(menuItem);

                final placeIdsEqual =
                    cart.restaurantPlaceId == restaurantPlaceId ||
                        cart.restaurantPlaceId.isEmpty;
                final inCart = cart.items.contains(menuItem) && placeIdsEqual;

                Future<void> actionWithItem() async {
                  if (!placeIdsEqual) {
                    await HapticFeedback.heavyImpact();
                    await _showDialogToClearCart(
                      menuItem,
                      restaurantPlaceId,
                    );
                  }
                  if (!inCart && placeIdsEqual) {
                    await Future.wait([
                      HapticFeedback.heavyImpact(),
                      CartBloc().addItemToCart(
                        menuItem,
                        placeId: restaurantPlaceId,
                      ),
                    ]);
                  }
                }

                return Ink(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => context.showBottomModalSheetWithItemDetails(
                      menuItem,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedImage(
                            imageUrl: menuItem.imageUrl,
                            height: MediaQuery.of(context).size.height * 0.17,
                            width: double.infinity,
                            imageType: CacheImageType.smallImage,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DiscountPrice(
                                defaultPrice: price,
                                hasDiscount: hasDiscount,
                                discountPrice: discountPrice,
                              ),
                              Text(name, style: context.titleLarge),
                              Text(
                                description,
                                style: context.bodyMedium?.apply(
                                  color: AppColors.grey.withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: actionWithItem,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: kDefaultHorizontalPadding - 6,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  kDefaultBorderRadius + 6,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(0, 5),
                                    color: Color.fromARGB(255, 219, 219, 219),
                                    blurRadius: 5,
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: inCart
                                  ? Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned(
                                          left: 0,
                                          child: CustomIcon(
                                            icon: FontAwesomeIcons.minus,
                                            type: IconType.iconButton,
                                            size: 18,
                                            onPressed: () {
                                              HapticFeedback.heavyImpact();
                                              CartBloc().decreaseQuantity(
                                                context,
                                                menuItem,
                                                forMenu: true,
                                              );
                                            },
                                          ),
                                        ),
                                        Text(
                                          quantity.toString(),
                                          style: context.bodyLarge,
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: Opacity(
                                            opacity: CartBloc()
                                                    .allowIncrease(menuItem)
                                                ? 1
                                                : 0.5,
                                            child: CustomIcon(
                                              icon: FontAwesomeIcons.plus,
                                              type: IconType.iconButton,
                                              size: 18,
                                              onPressed: () {
                                                HapticFeedback.heavyImpact();
                                                CartBloc()
                                                    .increaseQuantity(menuItem);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const CustomIcon(
                                          icon: FontAwesomeIcons.plus,
                                          type: IconType.simpleIcon,
                                          size: 18,
                                        ),
                                        Text(
                                          '  Add',
                                          style: context.bodyLarge,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: menu.items.length,
            ),
          ),
        );
      },
    );
  }
}

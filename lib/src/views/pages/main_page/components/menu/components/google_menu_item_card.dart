import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/extensions/show_bottom_modal_sheet_extension.dart';
import 'package:papa_burger/src/models/google_menu_model.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CacheImageType,
        CachedImage,
        Cart,
        CartBlocTest,
        CartService,
        CustomIcon,
        DiscountPrice,
        IconType,
        InkEffect,
        Item,
        KText,
        Menu,
        NavigatorExtension,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding,
        logger;
import 'package:papa_burger/src/views/widgets/show_custom_dialog.dart';

class GoogleMenuItemCard extends StatefulWidget {
  const GoogleMenuItemCard({
    required this.googleMenuModel,
    required this.menu,
    super.key,
  });

  final GoogleMenuModel googleMenuModel;
  final Menu menu;

  @override
  State<GoogleMenuItemCard> createState() => _GoogleMenuItemCardState();
}

class _GoogleMenuItemCardState extends State<GoogleMenuItemCard> {
  final CartService _cartService = CartService();

  late final CartBlocTest _cartBlocTest;
  late final restaurantPlaceId = widget.googleMenuModel.restaurant.placeId;
  late final googleMenuModel = widget.googleMenuModel;
  late final menu = widget.menu;

  @override
  void initState() {
    super.initState();
    _cartBlocTest = _cartService.cartBlocTest;
  }

  Future<dynamic> _showDialogToClearCart(
    Item menuItem,
    String placeId,
  ) {
    return showCustomDialog(
      context,
      onTap: () {
        context.pop(withHaptickFeedback: true);
        _cartBlocTest.addItemToCartAfterCallingClearCart(
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
    logger.i('Google Menu Item Card builds');
    return ValueListenableBuilder<Cart>(
      valueListenable: _cartBlocTest,
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
                final price = googleMenuModel.priceString(menuItem);
                final discountPrice = Menu.discountPriceString(menuItem);
                final hasDiscount = googleMenuModel.hasDiscount(menuItem);
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
                    await HapticFeedback.heavyImpact();
                    await _cartBlocTest.addItemToCart(
                      menuItem,
                      placeId: restaurantPlaceId,
                    );
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
                            inkEffect: InkEffect.noEffect,
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
                              KText(
                                text: name,
                                size: 20,
                              ),
                              KText(
                                text: description,
                                color: Colors.grey.shade600,
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
                                              _cartBlocTest.decreaseQuantity(
                                                context,
                                                menuItem,
                                                forMenu: true,
                                              );
                                            },
                                          ),
                                        ),
                                        KText(
                                          text: quantity.toString(),
                                          size: 18,
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: Opacity(
                                            opacity: _cartBlocTest
                                                    .allowIncrease(menuItem)
                                                ? 1
                                                : 0.5,
                                            child: CustomIcon(
                                              icon: FontAwesomeIcons.plus,
                                              type: IconType.iconButton,
                                              size: 18,
                                              onPressed: () {
                                                HapticFeedback.heavyImpact();
                                                _cartBlocTest
                                                    .increaseQuantity(menuItem);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomIcon(
                                          icon: FontAwesomeIcons.plus,
                                          type: IconType.simpleIcon,
                                          size: 18,
                                        ),
                                        KText(
                                          text: '  Add',
                                          size: 18,
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

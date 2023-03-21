import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemUiOverlayStyle, HapticFeedback;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/restaurant.dart'
    show
        CartService,
        Menu,
        MenuModel,
        CartBloc,
        Item,
        logger,
        MyThemeData,
        KText,
        CustomButtonInShowDialog,
        kPrimaryColor,
        CartState,
        CachedImage,
        InkEffect,
        CacheImageType,
        DiscountPrice,
        ExpandedElevatedButton,
        kDefaultBorderRadius,
        CustomIcon,
        IconType;

class MenuItemCard extends StatefulWidget {
  const MenuItemCard({
    super.key,
    required this.menuModel,
    required this.menu,
    required this.i,
  });

  final MenuModel menuModel;
  final Menu menu;
  final int i;

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  final CartService _cartService = CartService();

  late final CartBloc _cartBloc;

  late StreamSubscription _subscription;
  final Set<Item> _cartItems = <Item>{};

  @override
  void initState() {
    super.initState();
    _cartBloc = _cartService.cartBloc;
    _subscribeToMenu();
  }

  @override
  void dispose() {
    // _cartBloc.dispose();
    _subscription.cancel();
    super.dispose();
  }

  void _addToCart(Item item) {
    setState(() {
      _subscription.cancel();
      _cartBloc.addItemToCart(item);
      _cartItems.add(item);
      // _cartBloc.cartItems.add(item);
      _subscription = _cartBloc.globalStream.listen((event) {});
    });
  }

  void _addWithId(Item item, int id) {
    _addToCart(item);
    setState(() {
      _cartBloc.addRestaurantIdToCart(id);
    });
  }

  void _addWithoutId(Item item) {
    _addToCart(item);
  }

  void _removeFromCart(Item item) {
    setState(() {
      _subscription.cancel();
      _cartBloc.removeItemFromCartItem(item);
      _cartItems.remove(item);
      // _cartBloc.cartItems.remove(item);
      _subscription = _cartBloc.globalStream.listen((event) {});
    });
  }

  void _removeItems() {
    setState(() {
      _subscription.cancel();
      _cartBloc.removeAllItemsFromCartAndRestaurantId();
      _subscription = _cartBloc.globalStream.listen((state) {
        final cartItems = state.cart.cartItems;

        _cartItems.removeAll(cartItems);

        // _cartBloc.cartItems.removeAll(cartItems);
      });
    });
  }

  void _removeAllItemsThenAddItemWithIdToCart(Item item, int id) async {
    _removeItems();
    await Future.delayed(const Duration(milliseconds: 500));
    _addWithId(item, id);
  }

  void _subscribeToMenu() {
    setState(() {
      _subscription = _cartBloc.globalStream.listen((state) {
        logger.i(state.cart.cartItems);
        _cartItems.addAll(state.cart.cartItems);
      });
    });
  }

  _showCustomToClearItemsFromCart(
      BuildContext context, Item menuItems, int id) {
    return showDialog(
      context: context,
      builder: (context) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: MyThemeData.cartViewThemeData,
          child: AlertDialog(
            content: const KText(
              text: 'Need to clear a cart for a new order',
              size: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        HapticFeedback.heavyImpact();
                      },
                      child: CustomButtonInShowDialog(
                        borderRadius: BorderRadius.circular(18),
                        padding: const EdgeInsets.all(10),
                        colorDecoration: Colors.grey.shade200,
                        size: 18,
                        text: 'Cancel',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        HapticFeedback.heavyImpact();
                        _removeAllItemsThenAddItemWithIdToCart(menuItems, id);
                      },
                      child: CustomButtonInShowDialog(
                        borderRadius: BorderRadius.circular(18),
                        padding: const EdgeInsets.all(10),
                        colorDecoration: kPrimaryColor,
                        size: 18,
                        text: 'Clear',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurantId = widget.menuModel.restaurant.id;
    final menuModel = widget.menuModel;
    final menu = widget.menu;

    return StreamBuilder<CartState>(
      stream: _cartBloc.globalStream,
      builder: (context, snapshot) {
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 18, 12, 36),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
              childAspectRatio: 0.55,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final menuItems = menu.items[index];

                final name = menuItems.name;
                final price = menuItems.priceString;
                final description = menuItems.description;

                final hasDiscount = menuItems.discount != 0;
                final priceTotal =
                    menuModel.priceOfItem(i: widget.i, index: index);
                final discountPrice = '$priceTotal\$';

                final idEqual = _cartBloc.idEqual(restaurantId);
                final idEqualToRemove = _cartBloc.idEqualToRemove(restaurantId);
                final inCart = _cartItems.contains(menuItems) && idEqual;
                final cartEmpty = _cartItems.isEmpty;
                final toAddWithId = !inCart && cartEmpty;
                final toAddWitoutId = !inCart && !cartEmpty;

                return Ink(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedImage(
                            inkEffect: InkEffect.noEffect,
                            imageUrl: menuItems.imageUrl,
                            height: MediaQuery.of(context).size.height * 0.17,
                            width: double.infinity,
                            imageType: CacheImageType.smallImage,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              hasDiscount
                                  ? DiscountPrice(
                                      defaultPrice: price,
                                      discountPrice: discountPrice)
                                  : KText(
                                      text: price,
                                      size: 22,
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
                          snapshot.connectionState == ConnectionState.waiting
                              ? ExpandedElevatedButton.inProgress(
                                  backgroundColor: Colors.white,
                                  label: '',
                                  textColor: Colors.white,
                                  radius: 22,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    HapticFeedback.heavyImpact();
                                    idEqualToRemove
                                        ? toAddWithId
                                            ? _addWithId(
                                                menuItems, restaurantId)
                                            : toAddWitoutId
                                                ? _addWithoutId(menuItems)
                                                : _cartItems.length <= 1
                                                    ? _removeItems()
                                                    : _removeFromCart(menuItems)
                                        : _showCustomToClearItemsFromCart(
                                            context, menuItems, restaurantId);
                                    logger.w('LENGTH IS ${_cartItems.length}');
                                    logger.w(
                                        'IS ID EQUAL TO REMOVE $idEqualToRemove');
                                    logger.w('ID IN CART ${_cartBloc.id}');
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 35,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          kDefaultBorderRadius),
                                      color: Colors.white,
                                    ),
                                    child: inCart
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              CustomIcon(
                                                icon: FontAwesomeIcons.minus,
                                                type: IconType.simpleIcon,
                                                size: 18,
                                              ),
                                              KText(
                                                text: '  Remove',
                                                size: 18,
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/extensions/show_bottom_modal_sheet_extension.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CacheImageType,
        CachedImage,
        CustomIcon,
        DiscountPrice,
        IconType,
        InkEffect,
        Item,
        KText,
        Menu,
        currency,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding,
        kDefaultVerticalPadding;

class CartItemsListView extends StatefulWidget {
  const CartItemsListView({
    required this.decreaseQuantity,
    required this.increaseQuantity,
    required this.allowIncrease,
    super.key,
    this.cartItems = const <Item, int>{},
  });

  final Map<Item, int> cartItems;
  final void Function(BuildContext context, Item item) decreaseQuantity;
  final void Function(Item item) increaseQuantity;
  final bool Function(Item item) allowIncrease;

  @override
  State<CartItemsListView> createState() => _CartItemsListViewState();
}

class _CartItemsListViewState extends State<CartItemsListView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _opacityAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  SizedBox _buildItemDetails(
    double width,
    String name, {
    required String price,
    required String discountPrice,
    required bool hasDiscount,
  }) =>
      SizedBox(
        width: width * 0.36,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KText(
              text: name,
            ),
            DiscountPrice(
              defaultPrice: price,
              discountPrice: discountPrice,
              hasDiscount: hasDiscount,
              size: 19,
              subSize: 16,
            ),
          ],
        ),
      );

  Expanded _buildQuantityController(int? quantity, Item item) => Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(kDefaultBorderRadius - 6),
          ),
          height: 37,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                child: CustomIcon(
                  icon: FontAwesomeIcons.minus,
                  type: IconType.iconButton,
                  size: 18,
                  onPressed: () => widget.decreaseQuantity(context, item),
                ),
              ),
              KText(
                text: quantity.toString(),
                size: 18,
              ),
              Positioned(
                right: 0,
                child: Opacity(
                  opacity: widget.allowIncrease(item) ? 1 : 0.5,
                  child: CustomIcon(
                    icon: FontAwesomeIcons.plus,
                    type: IconType.iconButton,
                    size: 18,
                    onPressed: () => widget.increaseQuantity(item),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return SliverList(
          delegate: SliverChildListDelegate(
            ListTile.divideTiles(
              context: context,
              tiles: widget.cartItems.keys.map((item) {
                final imageUrl = item.imageUrl;
                final name = item.name;
                final quantity = widget.cartItems[item]!;
                final price = item.price * quantity;
                final discountPrice = Menu.itemPrice(item) * quantity;
                final hasDiscount = item.discount != 0;

                return ListTile(
                  onTap: () => context.showBottomModalSheetWithItemDetails(
                    item,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: kDefaultHorizontalPadding,
                    vertical: kDefaultVerticalPadding - 4,
                  ),
                  title: Row(
                    children: [
                      CachedImage(
                        inkEffect: InkEffect.noEffect,
                        imageType: CacheImageType.smallImage,
                        height: 80,
                        width: 80,
                        radius: kDefaultBorderRadius + 8,
                        imageUrl: imageUrl,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      _buildItemDetails(
                        width,
                        name,
                        price: '${price.toStringAsFixed(2)}$currency',
                        discountPrice:
                            '${discountPrice.toStringAsFixed(2)}$currency',
                        hasDiscount: hasDiscount,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      _buildQuantityController(quantity, item),
                    ],
                  ),
                  // isThreeLine: true,
                  // leading: CachedImage(
                  //   inkEffect: InkEffect.noEffect,
                  //   imageType: CacheImageType.smallImage,
                  //   height: 80,
                  //   width: 80,
                  //   radius: kDefaultBorderRadius + 8,
                  //   imageUrl: imageUrl,
                  // ),
                );
              }),
            ).toList(),
          ),
          // delegate: SliverChildBuilderDelegate(
          //   (context, index) {
          //     final items$ = widget.items.toList();
          //     final item = items$[index];
          //     final price = item.priceString;
          //     final imageUrl = item.imageUrl;
          //     final name = item.name;
          //     quantity() => widget.itemsTest[item];

          //     final hasDiscount = item.discount != 0;
          //     final discountPrice = const Menu().discountPriceString(item);

          //     return Column(
          //         children: ListTile.divideTiles(
          //       context: context,
          //       tiles: [
          //         ListTile(
          //           onTap: () {},
          //           contentPadding: const EdgeInsets.symmetric(
          //               horizontal: kDefaultHorizontalPadding,
          //               vertical: kDefaultVerticalPadding - 4),
          //           title: Row(
          //             children: [
          //               CachedImage(
          //                 inkEffect: InkEffect.noEffect,
          //                 imageType: CacheImageType.smallImage,
          //                 height: 80,
          //                 width: 80,
          //                 radius: kDefaultBorderRadius + 8,
          //                 imageUrl: imageUrl,
          //               ),
          //               const SizedBox(
          //                 width: 12,
          //               ),
          //               _buildItemDetails(
          //                 width,
          //                 name,
          //                 price: price,
          //                 discountPrice: discountPrice,
          //                 hasDiscount: hasDiscount,
          //               ),
          //               _buildQuantityController(quantity(), item),
          //             ],
          //           ),
          //           // isThreeLine: true,
          //           // leading: CachedImage(
          //           //   inkEffect: InkEffect.noEffect,
          //           //   imageType: CacheImageType.smallImage,
          //           //   height: 80,
          //           //   width: 80,
          //           //   radius: kDefaultBorderRadius + 8,
          //           //   imageUrl: imageUrl,
          //           // ),
          //         ),
          //       ],
          //     ).toList());

          //     // return InkWell(
          //     //   onTap: () {},
          //     //   child: Container(
          //     //     width: double.infinity,
          //     //     margin: const EdgeInsets.symmetric(
          //     //         horizontal: kDefaultHorizontalPadding,
          //     //         vertical: kDefaultHorizontalPadding - 6),
          //     //     child: Column(
          //     //       children: [
          //     //         Row(
          //     //           children: [
          //     //             CachedImage(
          //     //               inkEffect: InkEffect.noEffect,
          //     //               imageType: CacheImageType.smallImage,
          //     //               height: 80,
          //     //               width: 80,
          //     //               radius: kDefaultBorderRadius + 8,
          //     //               imageUrl: imageUrl,
          //     //             ),
          //     //             const SizedBox(
          //     //               width: 12,
          //     //             ),
          //     //             _buildItemDetails(
          //     //               width,
          //     //               name,
          //     //               price: price,
          //     //               discountPrice: discountPrice,
          //     //               hasDiscount: hasDiscount,
          //     //             ),
          //     //             _buildQuantityController(quantity(), item),
          //     //           ],
          //     //         ),
          //     //         const SizedBox(
          //     //           height: 12,
          //     //         ),
          //     //         const Divider(
          //     //           color: Colors.grey,
          //     //           height: 2,
          //     //         ),
          //     //       ],
          //     //     ),
          //     //   ),
          //     // );
          //   },
          //   childCount: widget.items.length,
          // ),
        );
      },
    );
  }
}

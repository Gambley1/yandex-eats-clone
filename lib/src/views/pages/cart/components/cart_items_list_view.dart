import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CacheImageType,
        CachedImage,
        CustomIcon,
        CustomScaffold,
        DiscountPrice,
        IconType,
        InkEffect,
        Item,
        KText,
        Menu,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding,
        kDefaultVerticalPadding;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

class CartItemsListView extends StatefulWidget {
  const CartItemsListView({
    super.key,
    required this.items,
    this.itemsTest = const <Item, int>{},
    required this.decreaseQuantity,
    required this.increaseQuantity,
    required this.allowIncrease,
  });

  final Set<Item> items;
  final Map<Item, int> itemsTest;
  final Function(BuildContext context, Item item) decreaseQuantity;
  final Function(Item item) increaseQuantity;
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
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _showBottomModalSheetWithItemsDetails(BuildContext context, Item item) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kDefaultBorderRadius),
                topRight: Radius.circular(kDefaultBorderRadius),
              ),
            ),
            child: CustomScaffold(
              backroundColor: Colors.transparent,
              body: ListView(
                children: [
                  CachedImage(
                    height: 300,
                    width: double.infinity,
                    imageUrl: item.imageUrl,
                    imageType: CacheImageType.smallImage,
                    inkEffect: InkEffect.noEffect,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultHorizontalPadding + 6,
                      vertical: kDefaultVerticalPadding,
                    ),
                    child: Column(
                      children: [
                        KText(
                          text: item.description,
                          size: 18,
                          color: Colors.black.withOpacity(.7),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  _buildItemDetails(
    double width,
    String name, {
    required String price,
    required String discountPrice,
    required bool hasDiscount,
  }) =>
      SizedBox(
        width: width * 0.35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KText(
              text: name,
              maxLines: 2,
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

  _buildQuantityController(int? quantity, Item item) => Expanded(
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
          delegate: SliverChildListDelegate(ListTile.divideTiles(
              context: context,
              tiles: widget.items.map((item) {
                final price = item.priceString;
                final imageUrl = item.imageUrl;
                final name = item.name;
                quantity() => widget.itemsTest[item];

                final hasDiscount = item.discount != 0;
                final discountPrice = const Menu().discountPriceString(item);
                return ListTile(
                  onTap: () =>
                      _showBottomModalSheetWithItemsDetails(context, item),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: kDefaultHorizontalPadding,
                      vertical: kDefaultVerticalPadding - 4),
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
                        price: price,
                        discountPrice: discountPrice,
                        hasDiscount: hasDiscount,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      _buildQuantityController(quantity(), item),
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
              })).toList()),
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

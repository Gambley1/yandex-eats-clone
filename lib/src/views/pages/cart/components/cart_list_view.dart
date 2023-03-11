import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        Item,
        Cart,
        kDefaultHorizontalPadding,
        kDefaultBorderRadius,
        CachedImage,
        CacheImageType,
        InkEffect,
        KText,
        DiscountPrice;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

class CartListView extends StatefulWidget {
  const CartListView({
    super.key,
    required this.items,
    required this.decrementQuanity,
  });

  final Set<Item> items;
  final Function decrementQuanity;

  @override
  State<CartListView> createState() => _CartListViewState();
}

class _CartListViewState extends State<CartListView>
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final items$ = widget.items.toList();
              final item = items$[index];
              final price = item.priceString;
              final imageUrl = item.imageUrl;
              final name = item.name;
              final quantities = const Cart().itemQuantity(items$);
              final quantity = quantities.values.elementAt(index);

              final hasDiscount = item.discount != 0;
              final priceTotal =
                  const Cart().priceOfCartItems(index: index, items: items$);
              final discountPrice = '$priceTotal\$';

              return Opacity(
                opacity: _opacityAnimation.value,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: kDefaultHorizontalPadding,
                        vertical: kDefaultHorizontalPadding - 6),
                    child: Row(
                      children: [
                        CachedImage(
                          inkEffect: InkEffect.noEffect,
                          imageType: CacheImageType.smallImage,
                          height: 100,
                          width: 100,
                          imageUrl: imageUrl,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: name,
                                maxLines: 2,
                                size: 20,
                              ),
                              hasDiscount
                                  ? DiscountPrice(
                                      defaultPrice: price,
                                      discountPrice: discountPrice,
                                    )
                                  : KText(
                                      text: price,
                                      size: 22,
                                    ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.circular(kDefaultBorderRadius),
                          ),
                          width: 100,
                          height: 40,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: MaterialButton(
                                  onPressed: () {},
                                  child: const Icon(
                                    FontAwesomeIcons.plus,
                                    size: 16,
                                  ),
                                ),
                              ),
                              KText(
                                text: quantity.toString(),
                                size: 18,
                              ),
                              Expanded(
                                child: MaterialButton(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                          kDefaultBorderRadius - 4),
                                      bottomRight: Radius.circular(
                                          kDefaultBorderRadius - 4),
                                    ),
                                  ),
                                  onPressed: () {
                                    widget.decrementQuanity(items$, item);
                                  },
                                  child: const Icon(
                                    FontAwesomeIcons.minus,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            childCount: widget.items.length,
          ),
        );
      },
    );
  }
}

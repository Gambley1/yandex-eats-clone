import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/cart/cart.dart';
import 'package:yandex_food_delivery_clone/src/menu/menu.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    required this.item,
    super.key,
  });

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    bool canIncreaseItemQuantity(MenuItem item) {
      return context.select(
        (CartBloc bloc) => bloc.state.canIncreaseItemQuantity(item),
      );
    }

    final quantity =
        context.select((CartBloc bloc) => bloc.state.quantity(item));
    final imageUrl = item.imageUrl;

    return ListTile(
      onTap: () => context.showScrollableModal(
        minChildSize: .6,
        maxChildSize: .85,
        initialChildSize: .85,
        snapSizes: [.85],
        pageBuilder: (scrollController, _) => MenuItemPreview(
          item: item,
          scrollController: scrollController,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md - AppSpacing.xs,
      ),
      leading: AspectRatio(
        aspectRatio: 1,
        child: ImageAttachmentThumbnail.network(
          borderRadius: BorderRadius.circular(AppSpacing.xlg),
          imageUrl: imageUrl,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: ItemDetails(item: item)),
          const SizedBox(width: AppSpacing.xxlg),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sm - AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: AppColors.brightGrey,
                borderRadius: BorderRadius.circular(
                  AppSpacing.md - AppSpacing.xxs,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    child: AppIcon.button(
                      icon: LucideIcons.minus,
                      onTap: () => context.read<CartBloc>().add(
                            CartItemDecreaseQuantityRequested(
                              item: item,
                            ),
                          ),
                    ),
                  ),
                  Text(
                    quantity.toString(),
                    style: context.bodyLarge,
                  ),
                  Positioned(
                    right: 0,
                    child: AppIcon.button(
                      icon: LucideIcons.plus,
                      onTap: !canIncreaseItemQuantity(item)
                          ? null
                          : () => context.read<CartBloc>().add(
                                CartItemIncreaseQuantityRequested(
                                  item: item,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemDetails extends StatelessWidget {
  const ItemDetails({
    required this.item,
    super.key,
  });

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final cartState = context.select((CartBloc bloc) => bloc.state);
    final quantity = cartState.quantity(item);
    final defaultPrice = item.formattedPriceWithQuantity(quantity);
    final discountPrice = item.formattedPriceWithDiscount(quantity);
    final hasDiscount = item.hasDiscount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        DiscountPrice(
          defaultPrice: defaultPrice,
          discountPrice: discountPrice,
          hasDiscount: hasDiscount,
          size: 19,
          subSize: 16,
        ),
      ],
    );
  }
}

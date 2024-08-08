import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/cart/cart.dart';
import 'package:yandex_food_delivery_clone/src/menu/menu.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    required this.item,
    required this.restaurantPlaceId,
    required this.isOpened,
    super.key,
  });

  final MenuItem item;
  final String restaurantPlaceId;
  final bool isOpened;

  Future<void> _showClearCartDialog({
    required BuildContext context,
    required MenuItem menuItem,
    required String placeId,
  }) {
    return context.confirmAction(
      fn: () async {
        void addItem() => context.read<CartBloc>()
          ..add(const CartClearRequested())
          ..add(
            CartAddItemRequested(
              item: menuItem,
              restaurantPlaceId: placeId,
            ),
          );
        await HapticFeedback.lightImpact();
        addItem();
      },
      title: 'Clear cart',
      content: 'Before adding new item you should clear you cart.',
      yesText: 'Yes, clear',
      noText: 'No, keep it',
    );
  }

  Future<void> _showRestaurantClosedDialog({
    required BuildContext context,
  }) =>
      context.showInfoDialog(
        title: 'Restaurant closed',
        content: "You can't add items from closed restaurant.",
      );

  Future<void> _onAddItemTap({
    required BuildContext context,
    required MenuItem item,
    required bool isFromSameRestaurant,
  }) async {
    if (!isOpened) return _showRestaurantClosedDialog(context: context);
    void addItem() => context.read<CartBloc>().add(
          CartAddItemRequested(
            item: item,
            restaurantPlaceId: restaurantPlaceId,
          ),
        );

    Future<void> showDialog() => _showClearCartDialog(
          context: context,
          menuItem: item,
          placeId: restaurantPlaceId,
        );

    await HapticFeedback.lightImpact();
    if (!isFromSameRestaurant) return showDialog();

    addItem();
  }

  @override
  Widget build(BuildContext context) {
    final isFromSameRestaurant = context.select(
      (CartBloc bloc) =>
          bloc.state.restaurant?.placeId == restaurantPlaceId ||
          bloc.state.restaurant == null,
    );
    final isInCart = context.select(
      (CartBloc bloc) => bloc.state.isInCart(item) && isFromSameRestaurant,
    );

    return Tappable.faded(
      borderRadius: AppSpacing.xlg,
      backgroundColor: context.customReversedAdaptiveColor(
        dark: AppColors.background,
        light: AppColors.brightGrey,
      ),
      onTap: () => context.showScrollableModal(
        minChildSize: .6,
        maxChildSize: .85,
        initialChildSize: .85,
        snapSizes: [.85],
        pageBuilder: (scrollController, _) => MenuItemPreview(
          item: item,
          restaurantPlaceId: restaurantPlaceId,
          scrollController: scrollController,
          isOpened: isOpened,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: ImageAttachmentThumbnail(
                imageUrl: item.imageUrl,
                borderRadius: BorderRadius.circular(AppSpacing.lg),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DiscountPrice(
                  defaultPrice: item.formattedPrice,
                  defaultPriceStyle: context.titleMedium,
                  discountPriceStyle: context.titleLarge,
                  hasDiscount: item.hasDiscount,
                  discountPrice: item.formattedPriceWithDiscount(),
                ),
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodyLarge,
                ),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodyMedium?.apply(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isInCart)
              MenuItemQuantity(item: item)
            else
              AddItemButton(
                onAddItemTap: () => _onAddItemTap(
                  context: context,
                  item: item,
                  isFromSameRestaurant: isFromSameRestaurant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MenuItemQuantity extends StatelessWidget {
  const MenuItemQuantity({required this.item, super.key});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final canIncreaseItemQuantity = context
        .select((CartBloc bloc) => bloc.state.canIncreaseItemQuantity(item));
    final quantity =
        context.select((CartBloc bloc) => bloc.state.quantity(item));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.customReversedAdaptiveColor(
          dark: AppColors.emphasizeDarkGrey,
          light: AppColors.white,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: AppSpacing.md,
            child: AppIcon.button(
              withPadding: false,
              onTap: () {
                context.read<CartBloc>().add(
                      CartItemDecreaseQuantityRequested(
                        item: item,
                      ),
                    );
              },
              icon: LucideIcons.minus,
            ),
          ),
          Text(
            quantity.toString(),
            style: context.bodyLarge,
          ),
          Positioned(
            right: AppSpacing.md,
            child: Opacity(
              opacity: !canIncreaseItemQuantity ? .4 : 1,
              child: AppIcon.button(
                onTap: !canIncreaseItemQuantity
                    ? null
                    : () {
                        context.read<CartBloc>().add(
                              CartItemIncreaseQuantityRequested(
                                item: item,
                              ),
                            );
                      },
                icon: LucideIcons.plus,
                withPadding: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddItemButton extends StatelessWidget {
  const AddItemButton({required this.onAddItemTap, super.key});

  final VoidCallback onAddItemTap;

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      fadeStrength: FadeStrength.lg,
      onTap: onAddItemTap,
      backgroundColor: context.customReversedAdaptiveColor(
        dark: AppColors.emphasizeDarkGrey,
        light: AppColors.white,
      ),
      borderRadius: AppSpacing.lg,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppIcon(icon: LucideIcons.plus),
            const SizedBox(width: AppSpacing.md),
            Text(
              'Add',
              style: context.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

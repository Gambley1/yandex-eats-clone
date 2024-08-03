import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/cart/cart.dart';

class MenuItemPreview extends StatelessWidget {
  const MenuItemPreview({
    required this.item,
    required this.scrollController,
    this.restaurantPlaceId,
    super.key,
  });

  final MenuItem item;
  final String? restaurantPlaceId;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ListView(
        controller: scrollController,
        children: [
          ImageAttachmentThumbnail(
            height: 300,
            imageUrl: item.imageUrl,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: IncreaseDecreaseQuantityBottomAppBar(
          item: item,
          restaurantPlaceId: restaurantPlaceId,
        ),
      ),
    );
  }
}

class IncreaseDecreaseQuantityBottomAppBar extends StatefulWidget {
  const IncreaseDecreaseQuantityBottomAppBar({
    required this.item,
    required this.restaurantPlaceId,
    super.key,
  });

  final MenuItem item;
  final String? restaurantPlaceId;

  @override
  State<IncreaseDecreaseQuantityBottomAppBar> createState() =>
      _IncreaseDecreaseQuantityBottomAppBarState();
}

class _IncreaseDecreaseQuantityBottomAppBarState
    extends State<IncreaseDecreaseQuantityBottomAppBar> {
  late ValueNotifier<int> _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = ValueNotifier(1);
  }

  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasItem =
        context.select((CartBloc bloc) => bloc.state.isInCart(widget.item));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(widget.item.name, style: context.titleLarge),
                  const Spacer(),
                  Text(widget.item.formattedPrice, style: context.titleLarge),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              ValueListenableBuilder<int>(
                valueListenable: _quantity,
                builder: (context, quantity, _) {
                  return Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppSpacing.sm),
                          border: Border.all(
                            color: AppColors.grey.withOpacity(.6),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            AppIcon.button(
                              icon: LucideIcons.minus,
                              iconSize: 16,
                              onTap: quantity == 1
                                  ? null
                                  : () {
                                      _quantity.value = _quantity.value - 1;
                                    },
                            ),
                            Text(quantity.toString()),
                            AnimatedOpacity(
                              duration: 150.ms,
                              opacity: quantity >= 100 ? .4 : 1,
                              child: AppIcon.button(
                                icon: LucideIcons.plus,
                                iconSize: 16,
                                onTap: quantity >= 100
                                    ? null
                                    : () => _quantity.value++,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Tappable.faded(
                          borderRadius: AppSpacing.sm,
                          backgroundColor: AppColors.deepBlue,
                          onTap: () {
                            if (!hasItem && widget.restaurantPlaceId != null) {
                              context.read<CartBloc>().add(
                                    CartAddItemRequested(
                                      item: widget.item,
                                      amount: _quantity.value,
                                      restaurantPlaceId:
                                          widget.restaurantPlaceId!,
                                    ),
                                  );
                            } else {
                              context.read<CartBloc>().add(
                                    CartItemIncreaseQuantityRequested(
                                      item: widget.item,
                                      amount: _quantity.value,
                                    ),
                                  );
                            }
                            context.pop();
                          },
                          child: Align(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              child: Text(
                                'Add',
                                style: context.bodyLarge?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: AppFontWeight.medium,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

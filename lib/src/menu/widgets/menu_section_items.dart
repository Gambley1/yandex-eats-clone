import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/cart/cart.dart';
import 'package:yandex_food_delivery_clone/src/menu/menu.dart';

class MenuSectionItems extends StatelessWidget {
  const MenuSectionItems({
    required this.menu,
    required this.isOpened,
    super.key,
  });

  final Menu menu;
  final bool isOpened;

  @override
  Widget build(BuildContext context) {
    final restaurantPlaceId =
        context.select((MenuBloc bloc) => bloc.state.restaurant.placeId);

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          sliver: SliverGrid.builder(
            itemCount: menu.items.length,
            itemBuilder: (context, index) {
              final item = menu.items[index];

              return MenuItemCard(
                key: ValueKey(item.id),
                item: item,
                restaurantPlaceId: restaurantPlaceId,
                isOpened: isOpened,
              );
            },
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisExtent: 330,
            ),
          ),
        );
      },
    );
  }
}

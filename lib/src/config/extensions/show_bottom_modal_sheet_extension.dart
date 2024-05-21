import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/views/pages/cart/state/cart_bloc.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

extension BottomModalSheetExtension on BuildContext {
  Future<void> showBottomModalSheetWithItemDetails(
    Item item,
  ) {
    return showModalBottomSheet<void>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      ),
      clipBehavior: Clip.hardEdge,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          minChildSize: 0.3,
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          builder: (
            context,
            scrollController,
          ) {
            return AppScaffold(
              body: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: CachedImage(
                      height: 300,
                      width: double.infinity,
                      imageUrl: item.imageUrl,
                      imageType: CacheImageType.smallImage,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(kDefaultBorderRadius),
                        bottomRight: Radius.circular(kDefaultBorderRadius),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultHorizontalPadding + 6,
                      vertical: kDefaultVerticalPadding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Text(
                            item.description,
                            style: context.bodyLarge
                                ?.apply(color: AppColors.black.withOpacity(.7)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: IncreaseDecreaseQuantityBottomAppBar(
                item: item,
                quantity: ValueNotifier<int>(1),
                cartBloc: CartBloc(),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> showCustomModalBottomSheet({
    required bool isScrollControlled,
    required bool scrollableSheet,
    Widget Function(ScrollController)? child,
    List<Widget>? children,
    double initialChildSize = 0.9,
    double minChildSize = 0.2,
    double maxChildSize = 0.9,
    bool expand = false,
    Widget? bottomAppBar,
    bool? showDragHandle,
  }) =>
      showModalBottomSheet(
        context: this,
        showDragHandle: showDragHandle,
        isScrollControlled: isScrollControlled,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
        backgroundColor: Colors.white,
        clipBehavior: Clip.hardEdge,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            expand: expand,
            maxChildSize: maxChildSize,
            builder: (context, scrollController) {
              return AppScaffold(
                body: scrollableSheet
                    ? CustomScrollView(
                        controller: scrollController,
                        slivers: children!,
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: children!,
                      ),
                bottomNavigationBar: bottomAppBar,
              );
            },
          );
        },
      );
}

class IncreaseDecreaseQuantityBottomAppBar extends StatelessWidget {
  const IncreaseDecreaseQuantityBottomAppBar({
    required this.item,
    required this.quantity,
    required this.cartBloc,
    super.key,
  });

  final Item item;
  final ValueNotifier<int> quantity;
  final CartBloc cartBloc;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: kDefaultVerticalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(item.name, style: context.titleLarge),
                const Spacer(),
                Text(item.priceString, style: context.titleLarge),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ValueListenableBuilder<int>(
              valueListenable: quantity,
              builder: (context, value, _) {
                return SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(kDefaultBorderRadius),
                          border: Border.all(
                            color: Colors.grey.withOpacity(.6),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIcon(
                              icon: FontAwesomeIcons.minus,
                              type: IconType.iconButton,
                              size: 16,
                              onPressed: value == 1
                                  ? null
                                  : () {
                                      quantity.value = quantity.value - 1;
                                    },
                            ),
                            Text(value.toString()),
                            CustomIcon(
                              icon: FontAwesomeIcons.plus,
                              type: IconType.iconButton,
                              size: 16,
                              onPressed: () => quantity.value++,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(kDefaultBorderRadius),
                          child: Material(
                            borderRadius:
                                BorderRadius.circular(kDefaultBorderRadius),
                            child: InkWell(
                              onTap: () {
                                cartBloc.increaseQuantity(item, value);
                                context.pop();
                              },
                              child: Ink(
                                decoration: const BoxDecoration(
                                  color: AppColors.deepBlue,
                                ),
                                child: Align(
                                  child: Text(
                                    'Add',
                                    style: context.titleLarge?.copyWith(
                                      fontWeight: AppFontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

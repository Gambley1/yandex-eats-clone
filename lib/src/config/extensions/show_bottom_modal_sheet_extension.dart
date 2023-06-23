import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:papa_burger/src/config/utils/app_constants.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CacheImageType,
        CachedImage,
        CartBloc,
        CustomIcon,
        CustomScaffold,
        DisalowIndicator,
        IconType,
        Item,
        KText,
        NavigatorExtension,
        kDefaultHorizontalPadding,
        kDefaultVerticalPadding,
        kPrimaryBackgroundColor,
        logger;

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
            return CustomScaffold(
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
                          KText(
                            text: item.description,
                            size: 18,
                            color: Colors.black.withOpacity(.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ).disalowIndicator(),
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
              return CustomScaffold(
                body: scrollableSheet
                    ? CustomScrollView(
                        controller: scrollController,
                        slivers: children!,
                      ).disalowIndicator()
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
    logger.i('Build bottom app bar.');
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
                KText(
                  text: item.name,
                  size: 20,
                ),
                const Spacer(),
                KText(
                  text: item.priceString,
                  size: 20,
                ),
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
                            KText(
                              text: value.toString(),
                            ),
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
                                decoration: BoxDecoration(
                                  color: kPrimaryBackgroundColor,
                                ),
                                child: const Align(
                                  child: KText(
                                    text: 'Add',
                                    size: 22,
                                    fontWeight: FontWeight.bold,
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

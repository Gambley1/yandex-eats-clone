import 'package:flutter/material.dart';
import 'package:papa_burger/src/models/restaurant/restaurants_page.dart';
import 'package:papa_burger/src/restaurant.dart'
    show CustomScaffold, KText, RestaurantApi, kDefaultBorderRadius, logger;

class RestaurantView extends StatelessWidget {
  const RestaurantView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    logger.w('Build Restaurant View');
    // final cartBlocTest = CartBlocTest();

    return CustomScaffold(
      withReleaseFocus: true,
      withSafeArea: true,
      body: Column(
        children: [
          FilledButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                ),
                clipBehavior: Clip.hardEdge,
                builder: (context) {
                  return DraggableScrollableSheet(
                    expand: false,
                    minChildSize: 0.1,
                    initialChildSize: 0.65,
                    maxChildSize: 0.65,
                    builder: (
                      context,
                      scrollController,
                    ) {
                      return const CustomScaffold(
                        body: CustomScrollView(),
                        bottomNavigationBar: BottomAppBar(
                          child: KText(
                            text: 'Hello',
                            size: 24,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: const KText(
              text: 'Open bottom sheet.',
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
      // body: LoaderWidget<RestaurantsPage>(
      //   blocProvider: () => LoaderBloc(
      //     loaderFunction: () => api.getPage,
      //     refresherFunction: () => api.getPage,
      //     refreshFlattenStrategy: FlattenStrategy.concat,
      //     logger: logger.i,
      //   ),
      //   messageHandler: (context, message, bloc) {
      //     message.fold(
      //       onFetchFailure: (error, stackTrace) =>
      //           context.showSnackBar('Error when fetching.'),
      //       onFetchSuccess: (_) {},
      //       onRefreshFailure: (error, stackTrace) =>
      //           context.showSnackBar('Refresh error.'),
      //       onRefreshSuccess: (data) =>
      //           context.showSnackBar('Refrehs success.'),
      //     );
      //   },
      //   builder: (context, state, bloc) {
      //     if (state.error != null) {
      //       return const KText(text: 'Error occured');
      //     }
      //     if (state.isLoading) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     if (state.content == null) {
      //       return const KText(text: 'Empty');
      //     }
      //     return RefreshIndicator(
      //       onRefresh: bloc.refresh,
      //       child: ListView.builder(
      //         itemBuilder: (context, index) {
      //           final restaurant = state.content?.restaurants[index];
      //           final item = restaurant?.name ?? '';

      //           return KText(text: item);
      //         },
      //         itemCount: state.content?.restaurants.length ?? 0,
      //       ),
      //     );
      //   },
      // ),
      // body: Center(
      //   child: ValueListenableBuilder<Cart>(
      //     valueListenable: cartBlocTest,
      //     builder: (context, cart, child) {
      //       return Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               KText(text: cart.restaurantPlaceId),
      //             ],
      //           ),
      //           if (cart.cartEmpty)
      //             Row(
      //               children: [
      //                 const KText(text: 'Cart is Empty'),
      //                 CustomIcon(
      //                   icon: FontAwesomeIcons.minus,
      //                   type: IconType.iconButton,
      //                   onPressed: cartBlocTest.removePlaceIdInCacheAndCart,
      //                 ),
      //               ],
      //             )
      //           else
      //             Expanded(
      //               child: ListView.builder(
      //                 itemBuilder: (context, index) {
      //                   final item = cart.items.toList()[index];
      //                   return ListTile(
      //                     title: KText(text: item.name),
      //                     subtitle: KText(
      //                       text: item.description,
      //                       color: Colors.grey,
      //                     ),
      //                     trailing: CustomIcon(
      //                       icon: FontAwesomeIcons.xmark,
      //                       type: IconType.iconButton,
      //                       onPressed: () =>
      //                           cartBlocTest.removeItemFromCart(item),
      //                     ),
      //                   );
      //                 },
      //                 itemCount: cart.items.length,
      //               ),
      //             ),
      //         ],
      //       );
      //     },
      //   ),
      // ),
    );
  }
}

class FakeApi {
  Stream<RestaurantsPage> get getPage => Stream.fromFuture(
        RestaurantApi()
            .getDBRestaurantsPageFromBackend()
            .timeout(const Duration(seconds: 5)),
      );
}

final api = FakeApi();

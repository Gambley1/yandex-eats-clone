// // ignore_for_file: lines_longer_than_80_chars

// import 'package:fast_immutable_collections/fast_immutable_collections.dart'
//     show FicIterableExtension;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show SystemUiOverlayStyle;
// import 'package:font_awesome_flutter/font_awesome_flutter.dart'
//     show FontAwesomeIcons;
// import 'package:papa_burger/src/restaurant.dart'
//     show
//         CacheImageType,
//         CachedImage,
//         CustomIcon,
//         CustomScaffold,
//         DisalowIndicator,
//         DiscountCard,
//         IconType,
//         InkEffect,
//         MenuItemCard,
//         MenuModel,
//         MenuSectionHeader,
//         MyThemeData,
//         NavigatorExtension,
//         Restaurant,
//         kDefaultHorizontalPadding,
//         menuRestaurantsKey;

// class MenuView extends StatelessWidget {
//   const MenuView({
//     required this.restaurant,
//     required this.imageUrl,
//     super.key,
//   });
//   final Restaurant restaurant;
//   final String imageUrl;

//   Container _buildCircularContainer() => Container(
//         width: double.infinity,
//         height: 25,
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(36),
//             topRight: Radius.circular(36),
//           ),
//           color: Colors.white,
//         ),
//       );

//   SliverAppBar _buildSliverAppBar(BuildContext context) => SliverAppBar(
//         actionsIconTheme: const IconThemeData(
//           color: Colors.black,
//         ),
//         iconTheme: const IconThemeData(
//           color: Colors.black,
//         ),
//         leading: Container(
//           height: 50,
//           width: 50,
//           margin: const EdgeInsets.only(left: kDefaultHorizontalPadding),
//           alignment: Alignment.center,
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.white,
//           ),
//           child: CustomIcon(
//             size: 24,
//             icon: FontAwesomeIcons.arrowLeft,
//             type: IconType.iconButton,
//             onPressed: () {
//               context.pop();
//             },
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(20),
//           child: _buildCircularContainer(),
//         ),
//         expandedHeight: 320,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: AnnotatedRegion<SystemUiOverlayStyle>(
//           value: MyThemeData.restaurantHeaderThemeData,
//           child: CachedImage(
//             inkEffect: InkEffect.noEffect,
//             imageType: CacheImageType.bigImage,
//             imageUrl: imageUrl,
//           ),
//         ),
//       );

//   CustomScaffold _buildUi(BuildContext context) {
//     final menuModel = MenuModel(restaurant: restaurant);
//     final discounts = menuModel.getDiscounts();
//     final menus = menuModel.getMenuWithPromotions();

//     final menusCategoriesName = menus.map((menu) => menu.category).toIList();

//     return CustomScaffold(
//       // bottomNavigationBar: StreamBuilder<CartState>(
//       //   stream: _cartBloc.globalStream,
//       //   builder: (context, snapshot) {
//       //     return _cartBloc.id == widget.restaurant.id
//       //         ? BottomAppBar(
//       //             child: Padding(
//       //               padding: const EdgeInsets.symmetric(
//       //                   horizontal: kDefaultHorizontalPadding,
//       //                   vertical: kDefaultHorizontalPadding - 10),
//       //               child: Row(
//       //                 mainAxisSize: MainAxisSize.min,
//       //                 children: [
//       //                   Column(
//       //                     mainAxisSize: MainAxisSize.min,
//       //                     children: [
//       //                       KText(
//       //                         text:
//       //                             '${snapshot.data!.cart.totalWithDeliveryFee.toStringAsFixed(0)} $currency',
//       //                         size: 24,
//       //                       ),
//       //                     ],
//       //                   ),
//       //                   const SizedBox(
//       //                     width: 12,
//       //                   ),
//       //                   const Spacer(),
//       //                   ElevatedButton(
//       //                     style: ElevatedButton.styleFrom(
//       //                       backgroundColor: Colors.blue.withOpacity(.7),
//       //                     ),
//       //                     onPressed: () {
//       //                       Navigator.of(context).pushReplacement(
//       //                         PageTransition(
//       //                           child: const CartView(),
//       //                           type: PageTransitionType.fade,
//       //                         ),
//       //                       );
//       //                     },
//       //                     child: const KText(
//       //                       text: 'Go to Cart',
//       //                       size: 24,
//       //                     ),
//       //                   ),
//       //                 ],
//       //               ),
//       //             ),
//       //           )
//       //         : const BottomAppBar();
//       //   },
//       // ),
//       body: CustomScrollView(
//         key: const PageStorageKey(menuRestaurantsKey),
//         slivers: [
//           _buildSliverAppBar(context),
//           DiscountCard(discounts: discounts),
//           for (var i = 0; i < menusCategoriesName.length; i++,) ...[
//             MenuSectionHeader(
//               categoryHeight: 110,
//               categoryName: menuModel.restaurant.menu[i].category,
//               isSectionEmpty: menuModel.restaurant.menu[i].items.isEmpty,
//             ),
//             MenuItemCard(
//               menuModel: menuModel,
//               i: i,
//               menu: menuModel.restaurant.menu[i],
//             ),
//           ],
//         ],
//       ).disalowIndicator(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: MyThemeData.restaurantViewThemeData,
//       child: Builder(
//         builder: _buildUi,
//       ),
//     );
//   }
// }

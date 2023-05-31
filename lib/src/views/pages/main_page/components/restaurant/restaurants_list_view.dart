// ignore_for_file: lines_longer_than_80_chars
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart'
//     show FontAwesomeIcons;
// import 'package:page_transition/page_transition.dart'
//     show PageTransition, PageTransitionType;
// import 'package:papa_burger/src/restaurant.dart'
//     show
//         CacheImageType,
//         CachedImage,
//         CustomCircularIndicator,
//         CustomIcon,
//         DisalowIndicator,
//         IconType,
//         InkEffect,
//         KText,
//         MenuView,
//         Restaurant,
//         ShimmerLoading,
//         kDefaultBorderRadius,
//         kDefaultHorizontalPadding,
//         logger;

// class RestaurantsListView extends StatefulWidget {
//   const RestaurantsListView({
//     required this.restaurants,
//     super.key,
//   });

//   final List<Restaurant> restaurants;

//   @override
//   State<RestaurantsListView> createState() => _RestaurantsListViewState();
// }

// class _RestaurantsListViewState extends State<RestaurantsListView> {
//   @override
//   Widget build(BuildContext context) {
//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 12,
//         vertical: 12,
//       ),
//       sliver: widget.restaurants.isEmpty
//           ? SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   return const Padding(
//                     padding: EdgeInsets.only(
//                       bottom: 24,
//                     ),
//                     child: ShimmerLoading(
//                       height: 160,
//                       radius: kDefaultBorderRadius,
//                       width: double.infinity,
//                     ),
//                   );
//                 },
//                 childCount: 5,
//               ),
//             )
//           : SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   logger.w('index $index');
//                   final restaurant = widget.restaurants[index];
//                   // final restaurantsDetails = restaurant.restaurantsDetails;
//                   // final restDetails = restaurantsDetails[index];

//                   final restaurantName = restaurant.name;

//                   // final imageUrl = restaurant.imageUrls[index];
//                   // final String restaurantImageUrl = restaurant.imageUrl;

//                   final restaurantTags = restaurant.tags;
//                   final tags = restaurantTags.map((e) => e.name).toList();

//                   final rating = restaurant.rating;
//                   final numOfRatings = restaurant.numOfRatings;
//                   final quality = restaurant.quality;

//                   if (index < widget.restaurants.length) {
//                     return RestaurantCard(
//                       restaurant: restaurant,
//                       restaurantImageUrl: '',
//                       restaurantName: restaurantName,
//                       rating: rating,
//                       quality: quality,
//                       numOfRatings: numOfRatings,
//                       tags: tags,
//                       imageUrl: '',
//                     );
//                   } else {
//                     return const Padding(
//                       padding: EdgeInsets.symmetric(
//                         vertical: kDefaultHorizontalPadding,
//                         horizontal: kDefaultBorderRadius,
//                       ),
//                       child: CustomCircularIndicator(
//                         color: Colors.black,
//                       ),
//                     );
//                   }
//                 },
//                 childCount: widget.restaurants.length + 1,
//               ),
//             ).disalowIndicator(),
//     );
//   }
// }

// class RestaurantCard extends StatelessWidget {
//   const RestaurantCard({
//     required this.restaurant,
//     required this.restaurantImageUrl,
//     required this.restaurantName,
//     required this.rating,
//     required this.quality,
//     required this.numOfRatings,
//     required this.tags,
//     required this.imageUrl,
//     super.key,
//   });

//   final Restaurant restaurant;
//   final String restaurantImageUrl;
//   final String restaurantName;
//   final double rating;
//   final String quality;
//   final int numOfRatings;
//   final List<String> tags;
//   final String imageUrl;

//   Row _buildRestaurantInfo(
//     double rating,
//     String quality,
//     int numOfRatings,
//     List<String> tags,
//   ) =>
//       Row(
//         children: [
//           _buildRating(rating),
//           _buildQualityAndNumOfRatings(quality, numOfRatings),
//           _buildTags(tags),
//         ],
//       );

//   Row _buildRating(double rating) => Row(
//         children: [
//           const CustomIcon(
//             icon: FontAwesomeIcons.star,
//             size: 16,
//             color: Colors.green,
//             type: IconType.simpleIcon,
//           ),
//           KText(
//             text: ' $rating ',
//           ),
//         ],
//       );

//   KText _buildQualityAndNumOfRatings(
//     String quality,
//     int numOfRatings,
//   ) =>
//       KText(
//         text: restaurant.qualityAndNumOfRatings,
//       );

//   KText _buildTags(List<String> tags) => KText(
//         text: restaurant.tagsToString,
//       );

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: kDefaultHorizontalPadding),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(kDefaultBorderRadius),
//         onTap: () {
//           Navigator.of(context).pushAndRemoveUntil(
//             PageTransition<dynamic>(
//               child: MenuView(
//                 restaurant: restaurant,
//                 imageUrl: imageUrl,
//               ),
//               type: PageTransitionType.fade,
//             ),
//             (route) => true,
//           );
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             InkWell(
//               borderRadius: BorderRadius.circular(kDefaultBorderRadius),
//               onTap: () {
//                 Navigator.of(context).pushAndRemoveUntil(
//                   PageTransition<dynamic>(
//                     child: MenuView(restaurant: restaurant, imageUrl: imageUrl),
//                     type: PageTransitionType.fade,
//                   ),
//                   (route) => true,
//                 );
//               },
//               child: CachedImage(
//                 inkEffect: InkEffect.noEffect,
//                 height: MediaQuery.of(context).size.height * 0.2,
//                 width: double.infinity,
//                 imageType: CacheImageType.smallImageWithNoShimmer,
//                 imageUrl: restaurantImageUrl,
//               ),
//             ),
//             const SizedBox(
//               height: 6,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 KText(
//                   text: restaurantName,
//                   size: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ],
//             ),
//             _buildRestaurantInfo(rating, quality, numOfRatings, tags),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart'
    show PageTransition, PageTransitionType;
import 'package:papa_burger/src/models/google_menu_model.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CacheImageType,
        CachedImage,
        CustomIcon,
        DisalowIndicator,
        DiscountCard,
        GoogleRestaurant,
        IconType,
        InkEffect,
        MenuSectionHeader,
        MyThemeData,
        NavigationBloc,
        TestMainPage,
        kDefaultHorizontalPadding,
        menuRestaurantsKey;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show FicIterableExtension;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

import 'components/google_menu_item_card.dart';

class GoogleMenuView extends StatefulWidget {
  final GoogleRestaurant restaurant;
  final String imageUrl;
  final bool fromCart;

  const GoogleMenuView({
    Key? key,
    required this.restaurant,
    required this.imageUrl,
    this.fromCart = false,
  }) : super(key: key);

  @override
  State<GoogleMenuView> createState() => _GoogleMenuView();
}

class _GoogleMenuView extends State<GoogleMenuView> {
  late final NavigationBloc _navigationBloc;

  @override
  void initState() {
    super.initState();
    _navigationBloc = NavigationBloc();
  }

  _buildCircularContainer() => Container(
        width: double.infinity,
        height: 25,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
          color: Colors.white,
        ),
      );

  _buildSliverAppBar(BuildContext context) => SliverAppBar(
        actionsIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: Container(
          height: 50,
          width: 50,
          margin: const EdgeInsets.only(left: kDefaultHorizontalPadding),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: CustomIcon(
            size: 24,
            icon: FontAwesomeIcons.arrowLeft,
            type: IconType.iconButton,
            onPressed: () {
              setState(() {
                _navigationBloc.navigation(0);
              });
              widget.fromCart == true
                  ? Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        child: const TestMainPage(),
                        type: PageTransitionType.fade,
                      ),
                      (route) => false,
                    )
                  : Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        child: const TestMainPage(),
                        type: PageTransitionType.fade,
                      ),
                      (route) => false,
                    );
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: _buildCircularContainer(),
        ),
        expandedHeight: 320,
        backgroundColor: Colors.transparent,
        flexibleSpace: AnnotatedRegion<SystemUiOverlayStyle>(
          value: MyThemeData.restaurantHeaderThemeData,
          child: CachedImage(
              index: 1,
              inkEffect: InkEffect.noEffect,
              imageType: CacheImageType.bigImage,
              imageUrl: widget.imageUrl),
        ),
      );

  _buildUi(BuildContext context) {
    final menuModel = GoogleMenuModel(restaurant: widget.restaurant);
    final discounts = menuModel.getDiscounts();
    final menus = menuModel.getMenuWithPromotions();

    final menusCategoriesName = menus.map((menu) => menu.category).toIList();

    return Scaffold(
      // bottomNavigationBar: StreamBuilder<CartState>(
      //   stream: _cartBloc.globalStream,
      //   builder: (context, snapshot) {
      //     return _cartBloc.id == widget.restaurant.id
      //         ? BottomAppBar(
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(
      //                   horizontal: kDefaultHorizontalPadding,
      //                   vertical: kDefaultHorizontalPadding - 10),
      //               child: Row(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Column(
      //                     mainAxisSize: MainAxisSize.min,
      //                     children: [
      //                       KText(
      //                         text:
      //                             '${snapshot.data!.cart.totalWithDeliveryFee.toStringAsFixed(0)}\$',
      //                         size: 24,
      //                       ),
      //                     ],
      //                   ),
      //                   const SizedBox(
      //                     width: 12,
      //                   ),
      //                   const Spacer(),
      //                   ElevatedButton(
      //                     style: ElevatedButton.styleFrom(
      //                       backgroundColor: Colors.blue.withOpacity(.7),
      //                     ),
      //                     onPressed: () {
      //                       Navigator.of(context).pushReplacement(
      //                         PageTransition(
      //                           child: const CartView(),
      //                           type: PageTransitionType.fade,
      //                         ),
      //                       );
      //                     },
      //                     child: const KText(
      //                       text: 'Go to Cart',
      //                       size: 24,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           )
      //         : const BottomAppBar();
      //   },
      // ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          key: const PageStorageKey(menuRestaurantsKey),
          slivers: [
            _buildSliverAppBar(context),
            DiscountCard(discounts: discounts),
            for (var i = 0; i < menusCategoriesName.length; i++,) ...[
              MenuSectionHeader(
                categorieName: menuModel.restaurant.menu[i].category,
                isSectionEmpty: menuModel.restaurant.menu[i].items.isEmpty,
              ),
              GoogleMenuItemCard(
                  menuModel: menuModel,
                  i: i,
                  menu: menuModel.restaurant.menu[i]),
            ],
          ],
        ).disalowIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.restaurantViewThemeData,
      child: Builder(
        builder: (context) => _buildUi(context),
      ),
    );
  }
}

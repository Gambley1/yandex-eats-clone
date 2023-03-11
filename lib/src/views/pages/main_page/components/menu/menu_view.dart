import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        NavigationBloc,
        Restaurant,
        kDefaultHorizontalPadding,
        CustomIcon,
        IconType,
        MyThemeData,
        CachedImage,
        InkEffect,
        CacheImageType,
        MenuModel,
        menuRestaurantsKey,
        DiscountCard,
        MenuSectionHeader,
        MenuItemCard,
        DisalowIndicator;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show FicIterableExtension;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

class MenuView extends StatefulWidget {
  final Restaurant restaurant;

  const MenuView({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
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
              Navigator.pop(context);
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
            index: widget.restaurant.id,
            inkEffect: InkEffect.noEffect,
            imageType: CacheImageType.bigImage,
            imageUrl: widget.restaurant.imageUrl,
          ),
        ),
      );

  _buildUi(BuildContext context) {
    final menuModel = MenuModel(restaurant: widget.restaurant);
    final discounts = menuModel.getDiscounts();
    final menus = menuModel.getMenuWithPromotions();

    final menusCategoriesName = menus.map((menu) => menu.categorie).toIList();

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
                categorieName: menuModel.restaurant.menu[i].categorie,
                isSectionEmpty: menuModel.restaurant.menu[i].items.isEmpty,
              ),
              MenuItemCard(
                menuModel: menuModel,
                i: i,
                menu: menuModel.restaurant.menu[i],
              ),
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

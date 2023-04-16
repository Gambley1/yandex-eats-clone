import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:page_transition/page_transition.dart'
    show PageTransition, PageTransitionType;
import 'package:papa_burger/src/restaurant.dart'
    show
        CacheImageType,
        CachedImage,
        GoogleRestaurant,
        InkEffect,
        KText,
        RestaurantService,
        RestaurantsFilteredView,
        Tag,
        categoriesKey,
        kDefaultHorizontalPadding;

class CategoriesSlider extends StatefulWidget {
  const CategoriesSlider({
    super.key,
    required this.restaurants,
  });

  final List<GoogleRestaurant> restaurants;

  @override
  State<CategoriesSlider> createState() => _CategoriesSliderState();
}

class _CategoriesSliderState extends State<CategoriesSlider>
    with SingleTickerProviderStateMixin {
  final RestaurantService _restaurantService = RestaurantService();

  late AnimationController _animationController;

  late List<bool> _isPressedList;
  late List<Tag> tags;
  late List<Animation<double>> _scaleAnimationList;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _animationController.addListener(() {
      setState(() {});
    });
    tags = _restaurantService.listTags;
    int tagsLength = tags.length;
    _isPressedList = List<bool>.generate(tagsLength, (index) => false);
    _scaleAnimationList = List<Animation<double>>.generate(
      tagsLength,
      (_) => Tween<double>(begin: 1.0, end: 0.75).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        key: const PageStorageKey(categoriesKey),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
        ),
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 12,
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final filteredRestaurantsByTag =
              _restaurantService.listRestaurantsByTag(
            categName: tags.map((tag) => tag.name).toList(),
            index: index,
          );
          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    _isPressedList[index] = true;
                  });
                  _scaleAnimationList[index];
                  _animationController.forward();
                },
                onTapUp: (details) {
                  HapticFeedback.heavyImpact();
                  setState(() {
                    _isPressedList[index] = false;
                  });
                  _animationController.reverse();
                  Navigator.of(context).pushAndRemoveUntil(
                    PageTransition(
                      child: RestaurantsFilteredView(
                        filteredRestaurants: filteredRestaurantsByTag,
                      ),
                      type: PageTransitionType.fade,
                    ),
                    (route) => true,
                  );
                },
                onTapCancel: () {
                  setState(() {
                    _isPressedList[index] = false;
                  });
                  _animationController.reverse();
                },
                child: Transform.scale(
                  scale: _isPressedList[index]
                      ? _scaleAnimationList[index].value
                      : 1.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CachedImage(
                        height: 90,
                        width: 80,
                        imageType: CacheImageType.smallImage,
                        imageUrl: tags[index].imageUrl,
                        inkEffect: InkEffect.noEffect,
                      ),
                      KText(
                        text: tags[index].name,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

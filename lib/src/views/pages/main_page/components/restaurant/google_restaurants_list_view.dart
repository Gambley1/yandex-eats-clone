import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/utils/app_strings.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CacheImageType,
        CachedImage,
        CustomCircularIndicator,
        CustomIcon,
        DisalowIndicator,
        GoogleRestaurant,
        IconType,
        KText,
        Message,
        NavigatorExtension,
        ShimmerLoading,
        Tag,
        currency,
        kDefaultBorderRadius,
        kDefaultHorizontalPadding,
        logger;

class GoogleRestaurantsListView extends StatelessWidget {
  const GoogleRestaurantsListView({
    required this.restaurants,
    required this.hasMore,
    super.key,
    this.errorMessage,
  });

  final List<GoogleRestaurant> restaurants;
  final bool hasMore;
  final Message? errorMessage;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      sliver: errorMessage != null
          ? SliverPadding(
              padding: const EdgeInsets.only(top: 120),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    children: [
                      KText(
                        text: errorMessage?.title ?? 'Something went wrong😔',
                        size: 22,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      KText(
                        text: errorMessage?.solution ??
                            'Contact me emilzulufov.commercial@gmail.com to '
                                'notify about error.',
                        size: 20,
                        textAlign: TextAlign.center,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : restaurants.isEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return const Padding(
                        padding: EdgeInsets.only(
                          bottom: 24,
                        ),
                        child: ShimmerLoading(
                          height: 160,
                          radius: kDefaultBorderRadius,
                          width: double.infinity,
                        ),
                      );
                    },
                    childCount: 5,
                  ),
                ).disalowIndicator()
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == restaurants.length) {
                        return const SizedBox(
                          height: 60,
                          child: CustomCircularIndicator(
                            color: Colors.black,
                          ),
                        );
                      }
                      final restaurant = restaurants[index];

                      final name = restaurant.name;
                      final numOfRatings = restaurant.userRatingsTotal ?? 0;
                      final priceLevel = restaurant.priceLevel ?? 0;
                      final rating = restaurant.rating ?? 0;
                      final tags = restaurant.tags;
                      final imageUrl = restaurant.imageUrl;
                      final quality = restaurant.quality(rating as double);
                      final isFavourite = restaurant.isFavourite;

                      final openNow = restaurant.openingHours.openNow;

                      return Opacity(
                        opacity: openNow ? 1 : 0.6,
                        child: RestaurantCard(
                          restaurant: restaurant,
                          imageUrl: imageUrl,
                          name: name,
                          rating: rating,
                          quality: quality,
                          numOfRatings: numOfRatings,
                          priceLevel: priceLevel,
                          tags: tags,
                        ),
                      );
                    },
                    childCount: restaurants.length + (hasMore ? 1 : 0),
                  ),
                ).disalowIndicator(),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    required this.restaurant,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.quality,
    required this.numOfRatings,
    required this.priceLevel,
    required this.tags,
    super.key,
  });

  final GoogleRestaurant restaurant;
  final String imageUrl;
  final String name;
  final double rating;
  final String quality;
  final int numOfRatings;
  final int priceLevel;
  final List<Tag> tags;

  Row _buildRestaurantInfo() => Row(
        children: [
          _buildRatingAndQuality(),
          _buildTags(),
        ],
      );

  KText _buildRating() {
    return rating <= 3
        ? const KText(text: ' Only a few ratings')
        : KText(
            text: ' $rating ',
          );
  }

  StatelessWidget _buildQualityAndNumOfRatings() {
    return rating <= 3
        ? Container()
        : KText(
            text: numOfRatings >= 50
                ? '$quality ($numOfRatings+) '
                : 'Few Ratings ',
            color: numOfRatings >= 30 ? Colors.black : Colors.black54,
          );
  }

  Row _buildRatingAndQuality() {
    return Row(
      children: [
        CustomIcon(
          icon: FontAwesomeIcons.star,
          size: 16,
          color: rating <= 4.4 ? Colors.grey : Colors.green,
          type: IconType.simpleIcon,
        ),
        _buildRating(),
        _buildQualityAndNumOfRatings(),
        RestaurantPriceLevel(priceLevel: priceLevel),
      ],
    );
  }

  KText _buildTags() {
    final tags$ = tags.isNotEmpty
        ? tags.length == 1
            ? [tags.first.name]
            : [tags.first.name, tags.last.name]
        : <Tag>[];
    return KText(
      /// The letter ',' comes from [GoogleRestaurant] from formattedTag
      text: tags$.isEmpty ? '' : restaurant.formattedTag(tags$.cast<String>()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultHorizontalPadding),
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            onTap: () => context.navigateToMenu(context, restaurant),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedImage(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
                  imageType: CacheImageType.smallImageWithNoShimmer,
                  onTap: () => context.navigateToMenu(context, restaurant),
                  imageUrl: imageUrl,
                ),
                const SizedBox(
                  height: 6,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'Menu$name',
                      child: KText(
                        text: name,
                        size: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _buildRestaurantInfo(),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: FavouriteButton(
              restaurant: restaurant,
            ),
          ),
        ],
      ),
    );
  }
}

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({
    required this.restaurant,
    super.key,
  });

  final GoogleRestaurant restaurant;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isTapped = false;
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {
        setState(() {});
      });
    _scaleAnimation = Tween<double>(begin: 1, end: 0.75).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void makeFavourite() {
    setState(() {
      final isFavourite = _isFavourite == true;
      if (isFavourite) {
        logger.i('Makes non favourite.');
        _isFavourite = false;
        widget.restaurant.copyWith(isFavourite: false);
      } else {
        logger.i('Makes favourite.');
        _isFavourite = true;
        widget.restaurant.copyWith(isFavourite: true);
      }
    });
  }

  void onTapDown(TapDownDetails details) {
    setState(() {
      _isTapped = true;
    });
    _animationController.forward();
  }

  void onTapUp(TapUpDetails details) {
    setState(() {
      _isTapped = false;
    });
    _animationController.reverse();
    HapticFeedback.heavyImpact();
    makeFavourite();
  }

  void onTapCancel() {
    setState(() {
      _isTapped = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(
          height: 35,
          width: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withOpacity(.8),
            shape: BoxShape.circle,
          ),
          child: Image(
            width: 22,
            image: AssetImage(
              _isFavourite ? heartFilled : heartNotFilled,
            ),
          ),
        ),
      ),
    );
  }
}

class RestaurantPriceLevel extends StatelessWidget {
  const RestaurantPriceLevel({
    required this.priceLevel,
    super.key,
  });

  final int priceLevel;

  @override
  Widget build(BuildContext context) {
    KText textToAppend(int priceLevel) => KText(
          text: priceLevel == 1
              ? '$currency$currency'
              : priceLevel == 2
                  ? currency
                  : '',
          color: Colors.grey,
        );

    switch (priceLevel) {
      case 0:
        return const KText(
          text: '',
        );
      case 1:
        return Row(
          children: [
            const KText(text: ' $currency'),
            textToAppend(priceLevel),
          ],
        );
      case 2:
        return Row(
          children: [
            const KText(text: ' $currency$currency'),
            textToAppend(priceLevel),
          ],
        );
      case 3:
        return const KText(text: ' $currency$currency$currency');
      default:
        return const KText(text: '');
    }
  }
}

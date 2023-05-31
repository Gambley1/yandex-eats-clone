import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    show CacheManager, Config, HttpFileService, JsonCacheInfoRepository;
import 'package:papa_burger/src/restaurant.dart'
    show
        CustomIcon,
        IconType,
        KText,
        LocationService,
        NavigatorExtension,
        ShimmerLoading,
        headerPhoto,
        kDefaultHorizontalPadding;

class HeaderView extends StatefulWidget {
  const HeaderView({super.key});

  @override
  State<HeaderView> createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView>
    with SingleTickerProviderStateMixin {
  final LocationService _locationService = LocationService();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool isTapped = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 100,
      ),
    )..addListener(() {
        setState(() {});
      });
    _scaleAnimation = Tween<double>(begin: 1, end: 0.75).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  ValueListenableBuilder<String> _buildAdressName(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _locationService.locationNotifier,
      builder: (context, address, child) {
        return KText(
          text: address,
          maxLines: 1,
          textAlign: TextAlign.center,
        );
      },
    );
  }

  Row _buildAdressAndDeliveryText() => const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          KText(
            text: 'Your address and delivery time',
            textAlign: TextAlign.center,
            color: Colors.grey,
            maxLines: 1,
          ),
          CustomIcon(
            icon: Icons.arrow_right_outlined,
            type: IconType.simpleIcon,
            size: 24,
            color: Colors.grey,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: headerPhoto,
          imageBuilder: (context, imageProvider) {
            return GestureDetector(
              onTapDown: (TapDownDetails details) {
                setState(() {
                  isTapped = true;
                });
                _animationController.forward();
              },
              onTapUp: (TapUpDetails detalis) {
                setState(() {
                  isTapped = false;
                });
                _animationController.reverse();
                HapticFeedback.heavyImpact();
                Scaffold.of(context).openDrawer();
              },
              onTapCancel: () {
                setState(() {
                  isTapped = false;
                });
                _animationController.reverse();
              },
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(.2),
                      ),
                    ],
                    border: Border.all(width: 2, color: Colors.white),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
          placeholder: (context, url) => const ShimmerLoading(
            radius: 100,
            width: 50,
            height: 50,
          ),
          errorWidget: (context, url, error) => Container(),
          cacheManager: CacheManager(
            Config(
              'my_custom_cache_key',
              stalePeriod: const Duration(days: 1),
              maxNrOfCacheObjects: 10,
              repo: JsonCacheInfoRepository(databaseName: 'my_custom_cache.db'),
              fileService: HttpFileService(),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding,
            ),
            child: InkWell(
              onTap: () => context.navigateToGoolgeMapView(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAdressAndDeliveryText(),
                  _buildAdressName(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

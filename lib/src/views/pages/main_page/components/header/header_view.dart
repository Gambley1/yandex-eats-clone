import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CustomIcon,
        GoogleMapView,
        IconType,
        KText,
        LocationService,
        LoginCubit,
        ShimmerLoading,
        headerPhoto,
        kDefaultHorizontalPadding,
        logger;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    show CacheManager, Config, JsonCacheInfoRepository, HttpFileService;
import 'package:page_transition/page_transition.dart'
    show PageTransition, PageTransitionType;

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
  late StreamSubscription _addressSubscription;

  bool isTapped = false;
  String _currentAddress = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addressSubscription =
          _locationService.locationBloc.address.listen((address) {
        setState(() {
          _currentAddress = address;
        });
      });
      logger.w('Adding post frame call back in Header View');
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 100,
      ),
    )..addListener(() {
        setState(() {});
      });
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.75).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  _buildAdressName(BuildContext context, AsyncSnapshot<String> snapshot) {
    return snapshot.connectionState == ConnectionState.waiting
        ? const SizedBox(
            width: 100,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.black,
            ),
          )
        : snapshot.hasError
            ? KText(text: snapshot.error.toString())
            : KText(
                text: _currentAddress,
                maxLines: 1,
                textAlign: TextAlign.center,
              );
  }

  _buildAdressAndDeliveryText() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          KText(
            text: 'Your adress and delivery time',
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
  void dispose() {
    _animationController.dispose();
    _locationService.locationBloc.dispose();
    _addressSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _locationService.locationBloc.address,
      initialData: _currentAddress,
      builder: (context, snapshot) {
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
                    HapticFeedback.heavyImpact();
                    setState(() {
                      isTapped = false;
                    });
                    _animationController.reverse();
                    context.read<LoginCubit>().onLogOut();
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          showCloseIcon: true,
                          animation: CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.easeIn),
                          behavior: SnackBarBehavior.floating,
                          clipBehavior: Clip.antiAlias,
                          width: 300,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80)),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.white,
                          content: Center(
                            child: Column(
                              children: const [
                                KText(
                                  text: 'You have signed out!',
                                  size: 20,
                                ),
                                KText(
                                  text: 'Please, restart the app.',
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
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
                        boxShadow: const [
                          BoxShadow(
                            spreadRadius: 0.2,
                            blurRadius: 9,
                            color: Colors.black54,
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
                  stalePeriod: const Duration(days: 7),
                  maxNrOfCacheObjects: 10,
                  repo: JsonCacheInfoRepository(
                      databaseName: 'my_custom_cache.db'),
                  fileService: HttpFileService(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultHorizontalPadding),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      PageTransition(
                        child: const GoogleMapView(),
                        type: PageTransitionType.fade,
                      ),
                      (route) => true,
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildAdressAndDeliveryText(),
                      _buildAdressName(context, snapshot),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

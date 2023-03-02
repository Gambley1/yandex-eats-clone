import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papa_burger/src/restaurant.dart';

class HeaderView extends StatefulWidget {
  const HeaderView({super.key});

  @override
  State<HeaderView> createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late StreamSubscription _subscription;
  String location = '';
  final Prefs storage = Prefs.instance;

  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 100,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.75).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addListener(() {
      setState(() {});
    });
    _subscription = storage.getLocationDynamicly().listen((loc) {
      location = loc;
    });
  }

  _buildAdressName(BuildContext context) {
    return StreamBuilder<String>(
      stream: storage.streamSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator(
            backgroundColor: Colors.white,
            color: Colors.black,
          );
        }
        if (snapshot.hasError) {
          return KText(text: snapshot.error.toString());
        }
        return Row(
          children: [
            KText(text: location),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
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
          },
          onTapCancel: () {
            setState(() {
              isTapped = false;
            });
            _animationController.reverse();
          },
          child: CachedNetworkImage(
            imageUrl:
                'https://i.ibb.co/2ds60Dw/dcf77798-d702-4d92-b554-1acfe887c162.jpg',
            imageBuilder: (context, imageProvider) {
              return Transform.scale(
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
              );
            },
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) => Container(),
            cacheManager: CacheManager(
              Config(
                'my_custom_cache_key',
                stalePeriod: const Duration(days: 7),
                maxNrOfCacheObjects: 10,
                repo:
                    JsonCacheInfoRepository(databaseName: 'my_custom_cache.db'),
                fileService: HttpFileService(),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
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
            child: LimitedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      KText(
                        text: 'Your adress and delivery time',
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
                  ),
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

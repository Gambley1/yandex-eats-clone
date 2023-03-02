import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

enum CacheImageType {
  bigImage,
  smallImage,
}

enum InkEffect {
  withEffect,
  noEffect,
}

class CachedImage extends StatelessWidget {
  final String smallCacheKey = 'smalllmageCacheKey';
  final String bigCacheKey = 'bigImageCacheKey';

  CachedImage({
    super.key,
    required this.imageUrl,
    required this.imageType,
    required this.inkEffect,
    this.index,
    this.width = 100,
    this.height = 100,
    this.bottom = 0,
    this.left = 20,
    this.top = 20,
    this.right = 0,
    this.radius = kDefaultBorderRadius,
    this.sizeXMark = 18,
    this.sizeSimpleIcon = 32,
  });

  final String imageUrl;
  final double height,
      width,
      top,
      left,
      right,
      bottom,
      sizeXMark,
      sizeSimpleIcon,
      radius;
  final CacheImageType imageType;
  final InkEffect inkEffect;
  final int? index;

  final colorList = [
    Colors.brown.withOpacity(.9),
    Colors.black.withOpacity(.9),
    Colors.cyan.withOpacity(.8),
    Colors.green.withOpacity(.8),
    Colors.indigo.withOpacity(.9),
  ];

  _getRandomColor() {
    final random = Random(index);
    return colorList[random.nextInt(colorList.length)];
  }

  _buildError() => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            radius,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              child: CustomIcon(
                icon: FontAwesomeIcons.circleXmark,
                type: IconType.simpleIcon,
                size: sizeXMark,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CustomIcon(
                icon: FontAwesomeIcons.images,
                type: IconType.simpleIcon,
                size: sizeSimpleIcon,
              ),
            ),
          ],
        ),
      );

  _buildErrorEmpty() => const SizedBox.shrink();

  _config({required String cacheKeyName, int stalePerioud = 1}) => Config(
        cacheKeyName,
        stalePeriod: Duration(
          days: stalePerioud,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return imageType == CacheImageType.smallImage
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            cacheManager: CacheManager(
              _config(cacheKeyName: smallCacheKey),
            ),
            imageBuilder: (context, imageProvider) => inkEffect ==
                    InkEffect.noEffect
                ? Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Ink(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            placeholder: (context, url) => ShimmerLoading(
              radius: kDefaultBorderRadius,
              width: width,
              height: height,
            ),
            errorWidget: (context, url, error) {
              return _buildErrorEmpty();
            },
          )
        : CachedNetworkImage(
            imageUrl: imageUrl,
            cacheManager: CacheManager(
              _config(cacheKeyName: bigCacheKey),
            ),
            imageBuilder: (context, imageProvider) => Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          _getRandomColor(),
                        ],
                        stops: const [0.6, 1],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            placeholder: (context, url) => const ShimmerLoading(),
            placeholderFadeInDuration: const Duration(seconds: 2),
            errorWidget: (context, url, error) => _buildErrorEmpty(),
          );
  }
}

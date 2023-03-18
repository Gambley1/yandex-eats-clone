import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show kDefaultBorderRadius, ShimmerLoading;
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    show CacheManager, Config;

enum CacheImageType {
  bigImage,
  smallImage,
  smallImageWithNoShimmer,
}

enum InkEffect {
  withEffect,
  noEffect,
}

class CachedImage extends StatelessWidget {
  static const smallCacheKey = 'smallImageCacheKey';
  static const smallCacheKeyWithoutShimmer = 'smallImageCacheKeyWithoutShimmer';
  static const bigCacheKey = 'bigImageCacheKey';

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

  // _buildError() => Container(
  _buildErrorEmpty() => const SizedBox.shrink();

  _config({required String cacheKeyName, int stalePerioud = 1}) => Config(
        cacheKeyName,
        maxNrOfCacheObjects: 60,
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
        : imageType == CacheImageType.smallImageWithNoShimmer
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                cacheManager: CacheManager(
                  _config(cacheKeyName: smallCacheKeyWithoutShimmer),
                ),
                cacheKey: imageUrl,
                imageBuilder: (context, imageProvider) => Container(
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
                placeholder: (context, url) => Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      radius,
                    ),
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/images/PlaceHolderRestaurant.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
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

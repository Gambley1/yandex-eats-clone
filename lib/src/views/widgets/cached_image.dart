import 'dart:math' show Random;

import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show KText, ShimmerLoading, kDefaultBorderRadius;
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
    this.width = 100,
    this.height = 100,
    this.bottom = 0,
    this.left = 20,
    this.top = 20,
    this.right = 0,
    this.radius = kDefaultBorderRadius,
    this.sizeXMark = 18,
    this.sizeSimpleIcon = 32,
    this.onTap,
    this.onTapBorderRadius = kDefaultBorderRadius,
    this.placeIdToParse = '',
    this.heroTag = '',
    this.restaurantName = '',
  });

  final String imageUrl, placeIdToParse, heroTag, restaurantName;
  final double height,
      width,
      top,
      left,
      right,
      bottom,
      sizeXMark,
      sizeSimpleIcon,
      radius,
      onTapBorderRadius;
  final CacheImageType imageType;
  final InkEffect inkEffect;
  final VoidCallback? onTap;

  late final hasInkEffect = inkEffect == InkEffect.withEffect;

  late final isSmallImage = imageType == CacheImageType.smallImage;
  late final isSmallImageWithNoShimmer =
      imageType == CacheImageType.smallImageWithNoShimmer;
  late final isBigImage = imageType == CacheImageType.bigImage;
  late final hasOnTapFunction = onTap != null;

  final colorList = [
    Colors.brown.withOpacity(.9),
    Colors.black.withOpacity(.9),
    Colors.cyan.withOpacity(.8),
    Colors.green.withOpacity(.8),
    Colors.indigo.withOpacity(.9),
  ];

  _config({required String cacheKeyName, int stalePerioud = 1}) => Config(
        cacheKeyName,
        maxNrOfCacheObjects: 60,
        stalePeriod: Duration(
          days: stalePerioud,
        ),
      );

  _defaultCacheManager(String cackeKeyName) => CacheManager(
        _config(cacheKeyName: cackeKeyName),
      );

  _getRandomColor() {
    final placeId = placeIdToParse.replaceAll(RegExp(r'[^\d]'), '');
    final index = int.tryParse(placeId) ?? 1;
    final random = Random(index);
    return colorList[random.nextInt(colorList.length)];
  }

  _buildErrorEmpty(
    double width,
    double height, {
    double radius = kDefaultBorderRadius,
  }) =>
      Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(radius),
        ),
      );

  _buildPlaceHolder(double width, double heigth) => Container(
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
      );

  _buildErrorPlaceHolder(double width, double height) =>
      _buildPlaceHolder(width, height);

  _buildImage(
    double width,
    double height,
    ImageProvider<Object> imageProvider, {
    double radius = kDefaultBorderRadius,
    BoxFit boxFit = BoxFit.cover,
    bool inkEffectOn = true,
    bool buildBigImage = false,
  }) {
    imageBoxDecoration() => BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          image: DecorationImage(
            image: imageProvider,
            fit: boxFit,
          ),
        );

    smoothImageFade() => Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  _getRandomColor(),
                ],
                stops: const [0.1, 1],
              ),
            ),
          ),
        );

    imageWithInk() => hasOnTapFunction
        ? InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(onTapBorderRadius),
            child: Ink(
              height: height,
              width: width,
              decoration: imageBoxDecoration(),
            ),
          )
        : Ink(
            height: height,
            width: width,
            decoration: imageBoxDecoration(),
          );

    imageWithoutInk() => hasOnTapFunction
        ? GestureDetector(
            onTap: onTap,
            child: Container(
              height: height,
              width: width,
              decoration: imageBoxDecoration(),
            ),
          )
        : Container(
            height: height,
            width: width,
            decoration: imageBoxDecoration(),
          );

    statisticAndDetailsOfRest() => Positioned(
          left: 12,
          bottom: 38,
          child: Stack(
            children: [
              Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(kDefaultBorderRadius + 16),
                  color: Colors.grey.shade300,
                ),
              ),
              Positioned(
                child: Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: const KText(
                    text: '4.8',
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        );

    bigImage() => Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: boxFit,
                ),
              ),
            ),
            smoothImageFade(),
            // statisticAndDetailsOfRest(),
            // nameOfRest(),
          ],
        );

    if (inkEffectOn) return imageWithInk();
    if (buildBigImage) return bigImage();
    return imageWithoutInk();
  }

  _buildCachedNetworkImage(BuildContext context) {
    smallCachedImage() => CachedNetworkImage(
          imageUrl: imageUrl,
          cacheManager: _defaultCacheManager(smallCacheKey),
          imageBuilder: (context, imageProvider) => _buildImage(
            width,
            height,
            imageProvider,
            radius: radius,
            inkEffectOn: hasInkEffect,
          ),
          placeholder: (_, __) => ShimmerLoading(
            radius: radius,
            width: width,
            height: height,
          ),
          errorWidget: (_, __, ___) =>
              _buildErrorEmpty(width, height, radius: radius),
        );

    smallWithoutShimmerCachedImage() => CachedNetworkImage(
          imageUrl: imageUrl,
          cacheManager: _defaultCacheManager(smallCacheKeyWithoutShimmer),
          imageBuilder: (_, imageProvider) => _buildImage(
            width,
            height,
            imageProvider,
            inkEffectOn: hasInkEffect,
          ),
          placeholder: (_, __) => _buildPlaceHolder(width, height),
          errorWidget: (_, __, ___) => _buildErrorPlaceHolder(width, height),
        );

    bigCachedImage() => CachedNetworkImage(
          imageUrl: imageUrl,
          cacheManager: _defaultCacheManager(bigCacheKey),
          imageBuilder: (_, imageProvider) => _buildImage(
            width,
            height,
            imageProvider,
            buildBigImage: true,
            inkEffectOn: hasInkEffect,
          ),
          placeholder: (_, __) => const ShimmerLoading(),
          placeholderFadeInDuration: const Duration(seconds: 2),
          errorWidget: (_, __, ___) => _buildErrorPlaceHolder(width, height),
        );

    if (isSmallImage) return smallCachedImage();
    if (isSmallImageWithNoShimmer) return smallWithoutShimmerCachedImage();
    if (isBigImage) return bigCachedImage();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCachedNetworkImage(context);
  }
}

// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template image_attachment_thumbnail}
/// Widget for building image attachment thumbnail.
/// {@endtemplate}
class ImageAttachmentThumbnail extends StatelessWidget {
  /// {@macro image_attachment_thumbnail}
  const ImageAttachmentThumbnail({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.memCacheHeight,
    this.memCacheWidth,
    this.resizeHeight,
    this.resizeWidth,
    this.fit = BoxFit.cover,
    this.withPlaceholder = true,
    this.withAdaptiveColors = true,
    this.borderRadius,
    this.errorBuilder = _defaultErrorBuilder,
  });

  /// The image url to show.
  final String imageUrl;

  /// Width of the attachment image thumbnail.
  final double? width;

  /// Height of the attachment image thumbnail.
  final double? height;

  /// Memory width of the attachment image thumbnail.
  final int? memCacheWidth;

  /// Memory height of the attachment image thumbnail.
  final int? memCacheHeight;

  /// Resize width of the attachment image thumbnail.
  final int? resizeWidth;

  /// rEsize height of the attachment image thumbnail.
  final int? resizeHeight;

  /// The border radius of the image.
  final BorderRadiusGeometry? borderRadius;

  /// Fit of the attachment image thumbnail.
  final BoxFit? fit;

  /// Whether to show a default shimmer placeholder when image is loading.
  final bool withPlaceholder;

  /// Whether the shimmer placeholder should use adaptive colors.
  final bool withAdaptiveColors;

  /// Builder used when the thumbnail fails to load.
  final ThumbnailErrorBuilder errorBuilder;

  // Default error builder for image attachment thumbnail.
  static Widget _defaultErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace, {
    double? height,
    double? width,
    BorderRadiusGeometry? borderRadius,
  }) {
    return ThumbnailError(
      error: error,
      stackTrace: stackTrace,
      height: height ?? double.infinity,
      width: width ?? double.infinity,
      borderRadius: borderRadius,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = this.width;
    final height = this.height;

    return NetworkImageAttachment(
      url: imageUrl,
      fit: fit,
      width: width,
      height: height,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      resizeWidth: resizeWidth,
      resizeHeight: resizeHeight,
      withPlaceholder: withPlaceholder,
      withAdaptiveColors: withAdaptiveColors,
      borderRadius: borderRadius,
      errorBuilder: errorBuilder,
    );
  }
}

class NetworkImageAttachment extends StatelessWidget {
  const NetworkImageAttachment({
    required this.url,
    required this.errorBuilder,
    required this.withAdaptiveColors,
    required this.withPlaceholder,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.fit,
    required this.memCacheWidth,
    required this.memCacheHeight,
    required this.resizeHeight,
    required this.resizeWidth,
    super.key,
  });

  final String url;
  final double? width;
  final double? height;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? resizeWidth;
  final int? resizeHeight;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final bool withPlaceholder;
  final bool withAdaptiveColors;
  final ThumbnailErrorBuilder errorBuilder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      cacheKey: url,
      memCacheHeight: memCacheHeight,
      memCacheWidth: memCacheWidth,
      imageBuilder: (context, imageProvider) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: resizeHeight == null && resizeWidth == null
                  ? imageProvider
                  : ResizeImage(
                      imageProvider,
                      width: resizeWidth,
                      height: resizeHeight,
                    ),
              fit: fit,
            ),
          ),
        );
      },
      placeholder: !withPlaceholder
          ? null
          : (context, __) => ShimmerPlaceholder.rectangle(
                height: height,
                width: width,
                withAdaptiveColors: withAdaptiveColors,
                borderRadius: borderRadius,
              ),
      errorWidget: (context, url, error) {
        return errorBuilder(
          context,
          error,
          StackTrace.current,
          height: height,
          width: width,
          borderRadius: borderRadius,
        );
      },
    );
  }
}

// ignore_for_file: comment_references, public_member_api_docs

import 'dart:io' show File;
import 'dart:math';
import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// {@template imageAttachmentThumbnail}
/// Widget for building image attachment thumbnail.
///
/// This widget is used when the [Attachment.type] is [AttachmentType.image].
/// {@endtemplate}
class ImageAttachmentThumbnail extends StatelessWidget {
  /// {@macro image_attachment_thumbnail}
  const ImageAttachmentThumbnail({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.width,
    this.height,
    this.memCacheHeight,
    this.memCacheWidth,
    this.fit = BoxFit.cover,
    this.filterQuality = FilterQuality.low,
    this.withPlaceholder = true,
    this.withAdaptiveColors = true,
    this.borderRadius,
    this.border,
    this.errorBuilder = _defaultErrorBuilder,
  });

  const ImageAttachmentThumbnail.network({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.memCacheHeight,
    this.memCacheWidth,
    this.fit = BoxFit.cover,
    this.filterQuality = FilterQuality.low,
    this.withPlaceholder = true,
    this.withAdaptiveColors = true,
    this.borderRadius,
    this.border,
    this.errorBuilder = _defaultErrorBuilder,
  }) : imageFile = null;

  const ImageAttachmentThumbnail.memory({
    required this.imageFile,
    super.key,
    this.width,
    this.height,
    this.memCacheHeight,
    this.memCacheWidth,
    this.fit = BoxFit.cover,
    this.filterQuality = FilterQuality.low,
    this.withPlaceholder = true,
    this.withAdaptiveColors = true,
    this.borderRadius,
    this.border,
    this.errorBuilder = _defaultErrorBuilder,
  }) : imageUrl = null;

  /// The image url to show.
  final String? imageUrl;

  /// The image url to show.
  final File? imageFile;

  /// Width of the attachment image thumbnail.
  final double? width;

  /// Height of the attachment image thumbnail.
  final double? height;

  /// Memory width of the attachment image thumbnail.
  final int? memCacheWidth;

  /// Memory height of the attachment image thumbnail.
  final int? memCacheHeight;

  /// The border radius of the image.
  final BorderRadiusGeometry? borderRadius;

  /// The border of the container that wraps an image.
  final BoxBorder? border;

  /// Fit of the attachment image thumbnail.
  final BoxFit? fit;

  /// The quality of the image. Default is low.
  final FilterQuality filterQuality;

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
    final file = imageFile;
    final width = this.width;
    final height = this.height;

    if (file != null) {
      return LocalImageAttachment(
        fit: fit,
        imageFile: file,
        width: width,
        height: height,
        borderRadius: borderRadius,
        withPlaceholder: withPlaceholder,
        withAdaptiveColors: withAdaptiveColors,
        errorBuilder: errorBuilder,
        filterQuality: filterQuality,
      );
    }

    if (imageUrl != null) {
      return NetworkImageAttachment(
        url: imageUrl!,
        fit: fit,
        width: width,
        height: height,
        memCacheHeight: memCacheHeight,
        memCacheWidth: memCacheWidth,
        withPlaceholder: withPlaceholder,
        withAdaptiveColors: withAdaptiveColors,
        borderRadius: borderRadius,
        border: border,
        errorBuilder: errorBuilder,
        filterQuality: filterQuality,
      );
    }

    // Return error widget if no image is found.
    return errorBuilder(
      context,
      'Image attachment is not valid',
      StackTrace.current,
      height: height,
      width: width,
      borderRadius: borderRadius,
    );
  }
}

class LocalImageAttachment extends StatelessWidget {
  const LocalImageAttachment({
    required this.errorBuilder,
    required this.fit,
    this.width,
    this.height,
    this.borderRadius,
    this.withPlaceholder = true,
    this.filterQuality = FilterQuality.low,
    this.imageFile,
    this.bytes,
    this.withAdaptiveColors = true,
    super.key,
  });

  final Uint8List? bytes;
  final File? imageFile;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final FilterQuality filterQuality;
  final bool withPlaceholder;
  final bool withAdaptiveColors;
  final ThumbnailErrorBuilder errorBuilder;

  @override
  Widget build(BuildContext context) {
    final bytes = this.bytes ?? imageFile?.readAsBytesSync();
    final path = imageFile?.path;
    if (bytes != null) {
      return CachedMemoryImage(
        uniqueKey: 'app://content/image/$path/${Random().nextInt(1000000)}',
        fit: fit,
        bytes: bytes,
        height: height,
        width: width,
        cacheHeight: height?.toInt(),
        cacheWidth: width?.toInt(),
        errorBuilder: errorBuilder,
        filterQuality: filterQuality,
        placeholder: !withPlaceholder
            ? null
            : ShimmerPlaceholder.rectangle(
                height: height,
                width: width,
                withAdaptiveColors: withAdaptiveColors,
                borderRadius: borderRadius,
              ),
      );
    }

    if (path != null) {
      return Image.file(
        File(path),
        width: width,
        height: height,
        cacheHeight: height?.toInt(),
        cacheWidth: width?.toInt(),
        fit: fit,
      );
    }

    // Return error widget if no image is found.
    return errorBuilder(
      context,
      'Image attachment is not valid',
      StackTrace.current,
      height: height,
      width: width,
      borderRadius: borderRadius,
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
    required this.border,
    required this.fit,
    required this.memCacheWidth,
    required this.memCacheHeight,
    required this.filterQuality,
    super.key,
  });

  final String url;
  final double? width;
  final double? height;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final BoxFit? fit;
  final FilterQuality filterQuality;
  final bool withPlaceholder;
  final bool withAdaptiveColors;
  final ThumbnailErrorBuilder errorBuilder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      cacheKey: url,
      memCacheHeight: memCacheHeight ?? height?.toInt(),
      memCacheWidth: memCacheWidth ?? width?.toInt(),
      imageBuilder: (context, imageProvider) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: border,
            borderRadius: borderRadius,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
              filterQuality: filterQuality,
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

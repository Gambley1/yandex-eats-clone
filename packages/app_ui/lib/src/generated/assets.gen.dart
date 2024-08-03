/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/facebook-logo-icon.svg
  SvgGenImage get facebookLogoIcon =>
      const SvgGenImage('assets/icons/facebook-logo-icon.svg');

  /// File path: assets/icons/filter-icon.svg
  SvgGenImage get filterIcon =>
      const SvgGenImage('assets/icons/filter-icon.svg');

  /// File path: assets/icons/google-icon.svg
  SvgGenImage get googleIcon =>
      const SvgGenImage('assets/icons/google-icon.svg');

  /// File path: assets/icons/heart-icon.svg
  SvgGenImage get heartIcon => const SvgGenImage('assets/icons/heart-icon.svg');

  /// File path: assets/icons/no-image-found-icon.svg
  SvgGenImage get noImageFoundIcon =>
      const SvgGenImage('assets/icons/no-image-found-icon.svg');

  /// File path: assets/icons/pin-icon.svg
  SvgGenImage get pinIcon => const SvgGenImage('assets/icons/pin-icon.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        facebookLogoIcon,
        filterIcon,
        googleIcon,
        heartIcon,
        noImageFoundIcon,
        pinIcon
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/burger.png
  AssetGenImage get burger => const AssetGenImage('assets/images/burger.png');

  /// File path: assets/images/burito.png
  AssetGenImage get burito => const AssetGenImage('assets/images/burito.png');

  /// File path: assets/images/ice-cream.png
  AssetGenImage get iceCream =>
      const AssetGenImage('assets/images/ice-cream.png');

  /// File path: assets/images/no-internet.jpg
  AssetGenImage get noInternet =>
      const AssetGenImage('assets/images/no-internet.jpg');

  /// File path: assets/images/papa-burger-logo.jpg
  AssetGenImage get papaBurgerLogo =>
      const AssetGenImage('assets/images/papa-burger-logo.jpg');

  /// File path: assets/images/papa-burger.png
  AssetGenImage get papaBurger =>
      const AssetGenImage('assets/images/papa-burger.png');

  /// File path: assets/images/papa_burger_ic_launcher.png
  AssetGenImage get papaBurgerIcLauncher =>
      const AssetGenImage('assets/images/papa_burger_ic_launcher.png');

  /// File path: assets/images/papa_burger_ic_launcher_adaptive_back.png
  AssetGenImage get papaBurgerIcLauncherAdaptiveBack => const AssetGenImage(
      'assets/images/papa_burger_ic_launcher_adaptive_back.png');

  /// File path: assets/images/papa_burger_ic_launcher_adaptive_fore.png
  AssetGenImage get papaBurgerIcLauncherAdaptiveFore => const AssetGenImage(
      'assets/images/papa_burger_ic_launcher_adaptive_fore.png');

  /// File path: assets/images/placeholder-image.jpg
  AssetGenImage get placeholderImage =>
      const AssetGenImage('assets/images/placeholder-image.jpg');

  /// File path: assets/images/placeholder-restaurant.jpg
  AssetGenImage get placeholderRestaurant =>
      const AssetGenImage('assets/images/placeholder-restaurant.jpg');

  /// File path: assets/images/placeholder.png
  AssetGenImage get placeholder =>
      const AssetGenImage('assets/images/placeholder.png');

  /// File path: assets/images/profile_photo.png
  AssetGenImage get profilePhoto =>
      const AssetGenImage('assets/images/profile_photo.png');

  /// File path: assets/images/welcome.png
  AssetGenImage get welcome => const AssetGenImage('assets/images/welcome.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        burger,
        burito,
        iceCream,
        noInternet,
        papaBurgerLogo,
        papaBurger,
        papaBurgerIcLauncher,
        papaBurgerIcLauncherAdaptiveBack,
        papaBurgerIcLauncherAdaptiveFore,
        placeholderImage,
        placeholderRestaurant,
        placeholder,
        profilePhoto,
        welcome
      ];
}

class Assets {
  Assets._();

  static const String package = 'app_ui';

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size = null});

  final String _assetName;

  static const String package = 'app_ui';

  final Size? size;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    @Deprecated('Do not specify package for a generated library asset')
    String? package = package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    @Deprecated('Do not specify package for a generated library asset')
    String? package = package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => 'packages/app_ui/$_assetName';
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size = null,
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size = null,
  }) : _isVecFormat = true;

  final String _assetName;

  static const String package = 'app_ui';

  final Size? size;
  final bool _isVecFormat;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    @Deprecated('Do not specify package for a generated library asset')
    String? package = package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture(
      _isVecFormat
          ? AssetBytesLoader(_assetName,
              assetBundle: bundle, packageName: package)
          : SvgAssetLoader(_assetName,
              assetBundle: bundle, packageName: package),
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => 'packages/app_ui/$_assetName';
}

import 'package:flutter/material.dart';

/// Provides values of current device screen `width` and `height` by provided
/// context.
extension BuildContextX on BuildContext {
  /// Returns [ThemeData] from [Theme.of].
  ThemeData get theme => Theme.of(this);

  /// Returns [TextTheme] from [Theme.of]
  TextTheme get textTheme => theme.textTheme;

  /// Material body large text style.
  TextStyle? get bodyLarge => textTheme.bodyLarge;

  /// Material body medium text style.
  TextStyle? get bodyMedium => textTheme.bodyMedium;

  /// Material body small text style.
  TextStyle? get bodySmall => textTheme.bodySmall;

  /// Material display large text style.
  TextStyle? get displayLarge => textTheme.displayLarge;

  /// Material display medium text style.
  TextStyle? get displayMedium => textTheme.displayMedium;

  /// Material display small text style.
  TextStyle? get displaySmall => textTheme.displaySmall;

  /// Material headline large text style.
  TextStyle? get headlineLarge => textTheme.headlineLarge;

  /// Material headline medium text style.
  TextStyle? get headlineMedium => textTheme.headlineMedium;

  /// Material headline small text style.
  TextStyle? get headlineSmall => textTheme.headlineSmall;

  /// Material label large text style.
  TextStyle? get labelLarge => textTheme.labelLarge;

  /// Material label medium text style.
  TextStyle? get labelMedium => textTheme.labelMedium;

  /// Material label small text style.
  TextStyle? get labelSmall => textTheme.labelSmall;

  /// Material title large text style.
  TextStyle? get titleLarge => textTheme.titleLarge;

  /// Material title medium text style.
  TextStyle? get titleMedium => textTheme.titleMedium;

  /// Material title small text style.
  TextStyle? get titleSmall => textTheme.titleSmall;

  /// Defines current theme [Brightness].
  Brightness get brightness => theme.brightness;

  /// Whether current theme [Brightness] is light.
  bool get isLight => brightness == Brightness.light;

  /// Whether current theme [Brightness] is dark.
  bool get isDark => !isLight;

  /// Defines an adaptive [Color], depending on current theme brightness.
  Color get adaptiveColor => isDark ? Colors.white : Colors.black;

  /// Defines a reversed adaptive [Color], depending on current theme
  /// brightness.
  Color get reversedAdaptiveColor => isDark ? Colors.black : Colors.white;

  /// Defines a customisable adaptive [Color]. If [light] or [dark] is not
  /// provided default colors are used.
  Color customAdaptiveColor({Color? light, Color? dark}) =>
      isDark ? (light ?? Colors.white) : (dark ?? Colors.black);

  /// Defines a customisable reversed adaptive [Color]. If [light] or [dark]
  /// is not provided default reversed colors are used.
  Color customReversedAdaptiveColor({Color? light, Color? dark}) =>
      isDark ? (dark ?? Colors.black) : (light ?? Colors.white);

  /// Defines [MediaQueryData] based on provided context.
  Size get size => MediaQuery.sizeOf(this);

  /// Defines view insets from [MediaQuery] with current [BuildContext].
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// Defines view padding of from [MediaQuery] with current [BuildContext].
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  /// Defines value of device current width based on [size].
  double get screenWidth => size.width;

  /// Defines value of device current height based on [size].
  double get screenHeight => size.height;

  /// Defines value of current device pixel ratio.
  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(this);

  /// Whether the current device is an `Android`.
  bool get isAndroid => theme.platform == TargetPlatform.android;

  /// Whether the current device is an `iOS`.
  bool get isIOS => !isAndroid;

  /// Whether the current device is a `mobile`.
  bool get isMobile => isAndroid || isIOS;
}

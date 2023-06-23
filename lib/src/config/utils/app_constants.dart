import 'package:flutter/material.dart'
    show
        BorderRadius,
        BuildContext,
        Color,
        Colors,
        FontWeight,
        IconData,
        Icons,
        OutlineInputBorder,
        TextDecoration,
        TextStyle,
        UnderlineInputBorder;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:papa_burger/src/restaurant.dart' show NavigatorExtension;

const double kDefaultHorizontalPadding = 12;
const double kDefaultVerticalPadding = 12;

const double kDefaultSizedboxW = 12;
const double kDefaultSizedboxH = 12;

const double kDefaultVerticalSpacingBetweenParagraphs = 24;
const double kDefaultVerticalSpacingBetweenContent = 12;
const double kDefaultVerticalSpacingBetweenSections = 12;

const double kDefaultBorderRadius = 16;
const double kDefaultSearchBarRadius = 24;

const LatLng almatyCenterPosititon = LatLng(43.2364, 76.9185);

const defaultTimeout = Duration(seconds: 10);

Color statusColor(String status) {
  final status$ = status.toLowerCase();
  if (status$ == 'pending') {
    return Colors.yellow.shade800;
  }
  if (status$ == 'canceled') {
    return Colors.red;
  }
  return Colors.green;
}

TextStyle defaultTextStyle({
  TextDecoration decoration = TextDecoration.none,
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.w500,
  double size = 16,
  double? letterSpacing,
}) =>
    GoogleFonts.getFont(
      'Quicksand',
      textStyle: TextStyle(
        decoration: decoration,
        color: color,
        fontWeight: fontWeight,
        fontSize: size,
        letterSpacing: letterSpacing,
      ),
    );

OutlineInputBorder outlinedBorder(
  double radius, {
  double? borderRadius,
}) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? radius),
    );

UnderlineInputBorder underlinedBorder(
  double radius, {
  double? borderRadius,
}) =>
    const UnderlineInputBorder();

IconData getIcon(String name) {
  switch (name) {
    case 'Profile':
      return Icons.person;
    case 'Orders':
      return FontAwesomeIcons.cartShopping;
    case 'Notifications':
      return Icons.notifications;
    case 'Addresses':
      return FontAwesomeIcons.addressCard;
    case 'Promo codes':
      return Icons.qr_code_rounded;
    case 'Support':
      return Icons.help;
    case 'About service':
      return Icons.info;
    case 'Become a Courier':
      return Icons.delivery_dining;
    case 'Food for business':
      return Icons.business;
    default:
      return Icons.error;
  }
}

void Function()? getFunction(BuildContext context, String name) {
  switch (name) {
    case 'Profile':
      return () {
        context.navigateToProfile();
      };
    case 'Orders':
      return () {
        context.navigateToOrdersView();
      };
    case 'Notifications':
      return () {};
    case 'Addresses':
      return () {};
    case 'Promo codes':
      return () {};
    case 'Support':
      return () {};
    case 'About service':
      return () {};
    case 'Become a Courier':
      return () {};
    case 'Food for business':
      return () {};
    default:
      return () {};
  }
}

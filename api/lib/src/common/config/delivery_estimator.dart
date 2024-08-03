// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:yandex_food_api/api.dart';

class DeliveryEstimator {
  // ignore: constant_identifier_names
  static const double _AVERAGE_SPEED = 60; // km/h

  static double _calculateDistance(Location start, Location end) {
    // Haversine formula to calculate distance between two coordinates
    const earthRadius = 6371; // km
    final lat1 = _degreesToRadians(start.lat);
    final lon1 = _degreesToRadians(start.lng);
    final lat2 = _degreesToRadians(end.lat);
    final lon2 = _degreesToRadians(end.lng);

    final dlat = lat2 - lat1;
    final dlon = lon2 - lon1;

    final a =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  static Duration estimateDeliveryTime(Location restaurant, Location user) {
    final distance = _calculateDistance(restaurant, user);
    final travelTime = distance / _AVERAGE_SPEED;

    final minutes = (travelTime * 60).round();
    return Duration(minutes: minutes);
  }
}

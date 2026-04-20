// utility to calculate distance wherever you need it
import 'dart:math';

double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
  const earthRadius = 6371000.0; // meters
  final dLat = (lat2 - lat1) * pi / 180;
  final dLng = (lng2 - lng1) * pi / 180;
  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180) *
          cos(lat2 * pi / 180) *
          sin(dLng / 2) *
          sin(dLng / 2);
  return earthRadius * 2 * atan2(sqrt(a), sqrt(1 - a));
}

// estimated walking time (assumes 5km/h walking speed)
int estimatedWalkMinutes(double distanceInMeters) =>
    (distanceInMeters / 83).ceil(); // 83 meters per minute

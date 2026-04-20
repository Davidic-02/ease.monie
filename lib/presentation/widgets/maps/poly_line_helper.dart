import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class PolylineHelper {
  static Polyline buildRoute(List<LatLng> points) {
    return Polyline(
      polylineId: const PolylineId('route'),
      points: points,
      color: const Color(0xFF1976D2),
      width: 5,
    );
  }
}

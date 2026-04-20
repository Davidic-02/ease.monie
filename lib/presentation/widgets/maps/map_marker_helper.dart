import 'package:esae_monie/models/extensions/atm_extension.dart';
import 'package:esae_monie/models/maps/atm.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Marker buildATMMarker(
  ATMWithMeta data, {
  required VoidCallback onTap,
  required BitmapDescriptor icon,
}) {
  return Marker(
    markerId: MarkerId(data.atm.id),
    position: data.atm.toLatLng(),
    infoWindow: InfoWindow(
      title: data.atm.name,
      snippet: '${data.distance.toInt()} m • ${data.estimatedTime} min',
    ),
    icon: icon,
    onTap: onTap,
  );
}

class ATMWithMeta {
  final ATM atm;
  final double distance;
  final int estimatedTime;

  ATMWithMeta({
    required this.atm,
    required this.distance,
    required this.estimatedTime,
  });
}

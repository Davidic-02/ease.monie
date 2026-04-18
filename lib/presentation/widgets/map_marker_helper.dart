import 'package:esae_monie/models/extensions/atm_extension.dart';
import 'package:esae_monie/models/maps/atm.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Marker buildATMMarker(
  ATM atm, {
  required VoidCallback onTap,
  required BitmapDescriptor icon,
}) {
  return Marker(
    markerId: MarkerId(atm.id),
    position: atm.toLatLng(),
    infoWindow: InfoWindow(
      title: atm.name,
      snippet: '${atm.distance} m • ${atm.estimatedTime} min',
    ),
    icon: icon,
    onTap: onTap,
  );
}

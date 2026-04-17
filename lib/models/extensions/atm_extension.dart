import 'package:esae_monie/models/maps/atm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension ATMX on ATM {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

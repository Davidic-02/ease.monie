import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:esae_monie/blocs/maps/maps_bloc.dart';
import 'package:esae_monie/blocs/location/location_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';

class MapMyLocationButton extends StatelessWidget {
  final GoogleMapController? mapController;
  final bool mapReady;
  final MapState mapState;
  final Color surfaceColor;

  const MapMyLocationButton({
    super.key,
    required this.mapController,
    required this.mapReady,
    required this.mapState,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: mapState.selectedATM != null ? 310 : 32,
      right: 16,
      child: Material(
        color: surfaceColor,
        shape: const CircleBorder(),
        elevation: 4,
        shadowColor: AppColors.shadowColor,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            context.read<MapBloc>().add(const MapEvent.yourLocationTapped());
            final loc = context.read<LocationBloc>().state.currentLocation;
            if (loc != null && mapReady && mapController != null) {
              mapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(loc.latitude, loc.longitude),
                    zoom: 15,
                  ),
                ),
              );
            }
          },
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.my_location,
              color: AppColors.secondaryColor,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

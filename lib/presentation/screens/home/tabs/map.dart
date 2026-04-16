import 'package:esae_monie/blocs/location/location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  static const String routeName = 'map_screen';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (!state.isLocationServiceEnabled) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _promptEnableLocationService(context);
            });

            return const Center(child: Text("Location services are disabled"));
          }

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: state.currentLocation == null
                  ? const LatLng(7.1475, 3.3619)
                  : LatLng(
                      state.currentLocation!.latitude,
                      state.currentLocation!.longitude,
                    ),
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          );
        },
      ),
    );
  }

  void _promptEnableLocationService(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Enable Location Services",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text(
            "Location Services are turned off on your device.\n\n"
            "To use map features and access your current location, "
            "please enable Location Services in your phone settings.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Not Now"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }
}

import 'package:esae_monie/blocs/location/location_bloc.dart';
import 'package:esae_monie/blocs/maps/maps_bloc.dart';
import 'package:esae_monie/models/maps/atm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends HookWidget {
  const MapScreen({super.key});

  static const String routeName = 'map_screen';

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final mapController = useRef<GoogleMapController?>(null);
    final mapReady = useRef(false);

    return Scaffold(
      body: BlocListener<LocationBloc, LocationState>(
        listener: (context, locationState) {
          if (!locationState.isLocationServiceEnabled) {
            _promptEnableLocationService(context);
          }
        },
        child: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, locationState) {
            if (!locationState.isLocationServiceEnabled) {
              return const Center(
                child: Text('Location services are disabled'),
              );
            }

            return BlocBuilder<MapBloc, MapState>(
              builder: (context, mapState) {
                return Stack(
                  children: [
                    // ── GOOGLE MAP ──────────────────────────────────────────
                    GoogleMap(
                      onMapCreated: (controller) {
                        mapController.value = controller;
                        mapReady.value = true;
                      },
                      onCameraIdle: () {
                        if (!mapReady.value || mapController.value == null) {
                          return;
                        }
                        mapController.value!.getVisibleRegion().then((bounds) {
                          context.read<MapBloc>().add(
                            MapEvent.cameraIdle(bounds),
                          );
                        });
                      },
                      initialCameraPosition: CameraPosition(
                        target: locationState.currentLocation == null
                            ? const LatLng(7.1475, 3.3619)
                            : LatLng(
                                locationState.currentLocation!.latitude,
                                locationState.currentLocation!.longitude,
                              ),
                        zoom: 15,
                      ),
                      // ✅ Markers built directly from bloc state — no local state
                      markers: mapState.displayedATMs.map((atm) {
                        return Marker(
                          markerId: MarkerId(atm.id),
                          position: LatLng(atm.latitude, atm.longitude),
                          infoWindow: InfoWindow(
                            title: atm.name,
                            snippet:
                                '${atm.distance}m • ${atm.estimatedTime}min',
                          ),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed,
                          ),
                          onTap: () {
                            context.read<MapBloc>().add(
                              MapEvent.atmSelected(atm),
                            );
                          },
                        );
                      }).toSet(),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),

                    // ── SEARCH BAR ──────────────────────────────────────────
                    Positioned(
                      top: 60,
                      left: 16,
                      right: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (query) {
                            context.read<MapBloc>().add(
                              MapEvent.searchChanged(query),
                            );
                          },
                          decoration: InputDecoration(
                            hintText: 'Search ATM...',
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.search),
                            // ✅ Driven by bloc state, not controller.text
                            suffixIcon: mapState.searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      searchController.clear();
                                      context.read<MapBloc>().add(
                                        const MapEvent.searchCleared(),
                                      );
                                    },
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── LOADING ─────────────────────────────────────────────
                    if (mapState.isLoading)
                      const Center(child: CircularProgressIndicator()),

                    // ── ERROR ───────────────────────────────────────────────
                    if (mapState.error.isNotEmpty)
                      Positioned(
                        bottom: 200,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  mapState.error,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () => context.read<MapBloc>().add(
                                  const MapEvent.clearError(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // ── ATM COUNT BADGE ─────────────────────────────────────
                    Positioned(
                      top: 120,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Text(
                          '${mapState.displayedATMs.length} ATMs',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // ── SELECTED ATM CARD ───────────────────────────────────
                    if (mapState.selectedATM != null)
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: _buildATMCard(context, mapState.selectedATM!),
                      ),

                    // ── YOUR LOCATION BUTTON ────────────────────────────────
                    Positioned(
                      bottom: mapState.selectedATM != null ? 220 : 32,
                      right: 16,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: () {
                          context.read<MapBloc>().add(
                            const MapEvent.yourLocationTapped(),
                          );

                          final loc = locationState.currentLocation;
                          if (loc != null &&
                              mapReady.value &&
                              mapController.value != null) {
                            mapController.value!.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(loc.latitude, loc.longitude),
                                  zoom: 15,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildATMCard(BuildContext context, ATM atm) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        atm.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        atm.address,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.read<MapBloc>().add(
                    const MapEvent.atmDeselected(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text('${atm.distance}m'),
                const SizedBox(width: 16),
                const Icon(Icons.timer, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text('${atm.estimatedTime}min'),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.read<MapBloc>().add(MapEvent.routeRequested(atm)),
                icon: const Icon(Icons.directions, color: Colors.white),
                label: const Text(
                  'Get Directions',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _promptEnableLocationService(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Enable Location Services',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Location Services are turned off on your device.\n\n'
          'To use map features and access your current location, '
          'please enable Location Services in your phone settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}

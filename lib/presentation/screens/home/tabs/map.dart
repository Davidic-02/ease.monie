import 'package:esae_monie/blocs/location/location_bloc.dart';
import 'package:esae_monie/blocs/maps/maps_bloc.dart';
import 'package:esae_monie/models/maps/atm.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends HookWidget {
  const MapScreen({super.key});

  static const String routeName = 'map_screen';

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final mapController = useRef<GoogleMapController?>(null);
    final mapReady = useRef(false);
    final showSuggestions = useState(false);

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

            return BlocConsumer<MapBloc, MapState>(
              // In BlocConsumer listener — also pan camera when searchCenter changes
              listener: (context, mapState) {
                // Pan to selected ATM
                if (mapState.selectedATM != null &&
                    mapReady.value &&
                    mapController.value != null) {
                  mapController.value!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                          mapState.selectedATM!.latitude,
                          mapState.selectedATM!.longitude,
                        ),
                        zoom: 16,
                      ),
                    ),
                  );
                }

                // Pan camera when search finds results in a new area
                if (mapState.isSearchingFromCustomLocation &&
                    mapState.searchCenter != null &&
                    mapState.selectedATM == null &&
                    mapReady.value &&
                    mapController.value != null) {
                  mapController.value!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: mapState.searchCenter!, zoom: 14),
                    ),
                  );
                }
              },
              builder: (context, mapState) {
                return Stack(
                  children: [
                    // ── GOOGLE MAP ──────────────────────────────────────
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
                      onTap: (LatLng position) {
                        // Only set custom location if not tapping a marker
                        // (marker onTap fires first and stops propagation)
                        showSuggestions.value = false;
                        FocusScope.of(context).unfocus();
                        context.read<MapBloc>().add(
                          MapEvent.customLocationSelected(position),
                        );
                      },
                      onLongPress: (latLng) {
                        context.read<MapBloc>().add(
                          MapEvent.customLocationSelected(latLng),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              '📍 Searching ATMs near this location...',
                            ),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'Reset',
                              onPressed: () {
                                context.read<MapBloc>().add(
                                  const MapEvent.resetSearchCenter(),
                                );
                              },
                            ),
                          ),
                        );
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
                      // ← polylines drawn here
                      polylines: mapState.polylines,
                      markers: {
                        ...mapState.displayedATMs.map((atm) {
                          final isSelected = mapState.selectedATM?.id == atm.id;
                          return Marker(
                            markerId: MarkerId(atm.id),
                            position: LatLng(atm.latitude, atm.longitude),
                            infoWindow: InfoWindow(
                              title: atm.name,
                              snippet: atm.address ?? '',
                            ),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              isSelected
                                  ? BitmapDescriptor.hueBlue
                                  : BitmapDescriptor.hueRed,
                            ),
                            zIndex: isSelected ? 2 : 1,
                            onTap: () {
                              showSuggestions.value = false;
                              context.read<MapBloc>().add(
                                MapEvent.atmSelected(atm),
                              );
                            },
                          );
                        }),
                        if (mapState.isSearchingFromCustomLocation &&
                            mapState.searchCenter != null)
                          Marker(
                            markerId: const MarkerId('custom_location'),
                            position: mapState.searchCenter!,
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen,
                            ),
                            infoWindow: const InfoWindow(
                              title: '📍 Custom Search Location',
                              snippet: 'Long press map to change',
                            ),
                          ),
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                    ),

                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: CustomTopbar(title: 'Atm Locator'),
                        ),
                      ),
                    ),

                    // ── SEARCH BAR + DROPDOWN ─────────────────────────────
                    Positioned(
                      top: mapState.isSearchingFromCustomLocation ? 119 : 125,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            Container(
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
                                  showSuggestions.value = query.isNotEmpty;
                                  context.read<MapBloc>().add(
                                    MapEvent.searchChanged(query),
                                  );
                                },
                                onTap: () {
                                  if (searchController.text.isNotEmpty) {
                                    showSuggestions.value = true;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search ATM...',
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: mapState.searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            searchController.clear();
                                            showSuggestions.value = false;
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

                            // Dropdown list
                            if (showSuggestions.value &&
                                mapState.displayedATMs.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                constraints: const BoxConstraints(
                                  maxHeight: 250,
                                ),
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
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: mapState.displayedATMs.length
                                      .clamp(0, 6),
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final atm = mapState.displayedATMs[index];
                                    return ListTile(
                                      leading: const Icon(
                                        Icons.atm,
                                        color: Colors.blue,
                                      ),
                                      title: Text(
                                        atm.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        atm.address ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      trailing: atm.isOpen
                                          ? const Text(
                                              'Open',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : const Text(
                                              'Closed',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                      onTap: () {
                                        searchController.text = atm.name;
                                        showSuggestions.value = false;
                                        FocusScope.of(context).unfocus();
                                        context.read<MapBloc>().add(
                                          MapEvent.atmSelected(atm),
                                        );
                                        // Camera move handled by BlocConsumer listener
                                      },
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // ── LOADING ───────────────────────────────────────────
                    if (mapState.fetchStatus ==
                        FormzSubmissionStatus.inProgress)
                      const Center(child: CircularProgressIndicator()),

                    // ── ERROR ─────────────────────────────────────────────
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

                    // ── ATM COUNT BADGE ───────────────────────────────────
                    Positioned(
                      top: mapState.isSearchingFromCustomLocation ? 190 : 170,
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

                    // ── SELECTED ATM CARD ─────────────────────────────────
                    if (mapState.selectedATM != null)
                      Positioned(
                        bottom: 24,
                        left: 16,
                        right: 16,
                        child: _buildFloatingCard(
                          context,
                          mapState,
                          locationState.currentLocation,
                        ),
                      ),

                    // ── YOUR LOCATION FAB ─────────────────────────────────
                    Positioned(
                      bottom: mapState.selectedATM != null ? 310 : 32,
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

  Widget _buildFloatingCard(
    BuildContext context,
    MapState mapState,
    Position? userLocation,
  ) {
    final atm = mapState.selectedATM!;

    // ── Distance & duration from real route data ──
    final distanceM = mapState.routeDistanceM;
    final durationMin = mapState.routeDurationMin;

    final distanceText = distanceM == null
        ? '-- m'
        : distanceM >= 1000
        ? '${(distanceM / 1000).toStringAsFixed(1)} km'
        : '$distanceM m';

    final durationText = durationMin == null ? '-- min' : '$durationMin min';

    // ── User location label ──
    // Replace the userLabel line inside _buildFloatingCard:
    final userLabel = mapState.isSearchingFromCustomLocation
        ? (mapState.customLocationLabel.isNotEmpty
              ? mapState.customLocationLabel
              : 'Resolving location…')
        : (mapState.userAddressLabel.isNotEmpty
              ? mapState.userAddressLabel
              : 'Acquiring location…');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── ROUTE BAR (only visible after route is drawn) ──────────────
        if (mapState.polylines.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.directions_walk,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      distanceText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Container(width: 1, height: 20, color: Colors.white38),
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      durationText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        // ── FLOATING INFO CARD ─────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── YOUR LOCATION ──────────────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.home_outlined,
                      size: 18,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Location',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // ── DOTTED CONNECTOR ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(left: 18, top: 4, bottom: 4),
                child: Column(
                  children: List.generate(
                    3,
                    (_) => Container(
                      width: 2,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ),
              ),

              // ── ATM NEARBY ─────────────────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.atm, size: 18, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ATM Nearby',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          atm.address?.isNotEmpty == true
                              ? atm.address!
                              : atm.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── ROUTE LOADING INDICATOR ────────────────────────────
              if (mapState.routeStatus == FormzSubmissionStatus.inProgress)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Center(child: CircularProgressIndicator()),
                ),

              // ── ACTION BUTTONS ─────────────────────────────────────
              if (mapState.routeStatus != FormzSubmissionStatus.inProgress)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.read<MapBloc>().add(
                          MapEvent.routeRequested(atm),
                        ),
                        icon: const Icon(
                          Icons.route,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          mapState.polylines.isEmpty ? 'Show Route' : 'Reroute',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchDirections(
                          context,
                          atm,
                          userLocation,
                          mapState,
                        ),
                        icon: const Icon(
                          Icons.directions,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Navigate',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchDirections(
    BuildContext context,
    ATM atm,
    Position? userLocation,
    MapState mapState, // ← pass mapState
  ) async {
    // Use custom location as origin if active, else GPS
    final origin =
        mapState.isSearchingFromCustomLocation && mapState.searchCenter != null
        ? '${mapState.searchCenter!.latitude},${mapState.searchCenter!.longitude}'
        : userLocation != null
        ? '${userLocation.latitude},${userLocation.longitude}'
        : '';

    final destination = '${atm.latitude},${atm.longitude}';

    final googleMapsAppUrl = Uri.parse(
      'comgooglemaps://?daddr=$destination'
      '${origin.isNotEmpty ? '&saddr=$origin' : ''}'
      '&directionsmode=driving',
    );

    final googleMapsBrowserUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '${origin.isNotEmpty ? '&origin=$origin' : ''}'
      '&destination=$destination'
      '&travelmode=driving',
    );

    if (await canLaunchUrl(googleMapsAppUrl)) {
      await launchUrl(googleMapsAppUrl);
    } else {
      await launchUrl(
        googleMapsBrowserUrl,
        mode: LaunchMode.externalApplication,
      );
    }
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

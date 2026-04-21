import 'package:esae_monie/blocs/location/location_bloc.dart';
import 'package:esae_monie/blocs/maps/maps_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/presentation/widgets/maps/map_badges.dart';
import 'package:esae_monie/presentation/widgets/maps/map_error_banner.dart';
import 'package:esae_monie/presentation/widgets/maps/map_floating_card.dart';
import 'package:esae_monie/presentation/widgets/maps/map_myLocation_button.dart';
import 'package:esae_monie/presentation/widgets/maps/map_search_bar.dart';
import 'package:esae_monie/presentation/widgets/maps/maps_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:esae_monie/presentation/widgets/maps/dark_mode.dart';

class MapScreen extends HookWidget {
  const MapScreen({super.key});

  static const String routeName = 'map_screen';

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final searchFocusNode = useFocusNode();
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
              return Center(
                child: Text(
                  'Location services are disabled',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            return BlocConsumer<MapBloc, MapState>(
              listenWhen: (prev, curr) =>
                  prev.selectedATM != curr.selectedATM ||
                  prev.searchCenter != curr.searchCenter ||
                  prev.isDarkMode != curr.isDarkMode,
              listener: (context, mapState) {
                final ctrl = mapController.value;
                if (!mapReady.value || ctrl == null) return;

                ctrl.setMapStyle(mapState.isDarkMode ? darkMapStyle : null);

                if (mapState.selectedATM != null) {
                  ctrl.animateCamera(
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

                if (mapState.isSearchingFromCustomLocation &&
                    mapState.searchCenter != null &&
                    mapState.selectedATM == null) {
                  ctrl.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: mapState.searchCenter!, zoom: 14),
                    ),
                  );
                }
              },
              builder: (context, mapState) {
                final isDark = mapState.isDarkMode;
                final surfaceColor = isDark
                    ? AppColors.darkSurface
                    : AppColors.whiteColor;

                return Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: (controller) {
                        mapController.value = controller;
                        mapReady.value = true;
                        controller.setMapStyle(
                          mapState.isDarkMode ? darkMapStyle : null,
                        );
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
                            backgroundColor: surfaceColor,
                            content: Text(
                              '📍 Searching ATMs near this location...',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'Reset',
                              textColor: AppColors.secondaryColor,
                              onPressed: () => context.read<MapBloc>().add(
                                const MapEvent.resetSearchCenter(),
                              ),
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
                                  ? BitmapDescriptor.hueAzure
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
                    MapAppBar(),
                    MapSearchBar(
                      searchController: searchController,
                      searchFocusNode: searchFocusNode,
                      showSuggestions: showSuggestions.value,
                      onShowSuggestions: () => showSuggestions.value = true,
                      onHideSuggestions: () => showSuggestions.value = false,
                      mapState: mapState,
                      surfaceColor: surfaceColor,
                    ),
                    if (mapState.fetchStatus ==
                        FormzSubmissionStatus.inProgress)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    MapErrorBanner(mapState: mapState),
                    MapATMCountBadge(
                      mapState: mapState,
                      surfaceColor: surfaceColor,
                    ),
                    if (mapState.selectedATM != null)
                      Positioned(
                        bottom: 24,
                        left: 16,
                        right: 16,
                        child: MapFloatingCard(
                          mapState: mapState,
                          userLocation: locationState.currentLocation,
                          surfaceColor: surfaceColor,
                        ),
                      ),
                    MapMyLocationButton(
                      mapController: mapController.value,
                      mapReady: mapReady.value,
                      mapState: mapState,
                      surfaceColor: surfaceColor,
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

  void _promptEnableLocationService(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Enable Location Services',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Text(
          'Location Services are turned off on your device.\n\n'
          'To use map features and access your current location, '
          'please enable Location Services in your phone settings.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Not Now',
              style: TextStyle(color: AppColors.greyColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
            child: const Text(
              'Open Settings',
              style: TextStyle(color: AppColors.secondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

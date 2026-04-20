import 'package:esae_monie/blocs/location/location_bloc.dart';
import 'package:esae_monie/blocs/maps/maps_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/maps/atm.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
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
    final searchFocusNode = useFocusNode();
    final mapController = useRef<GoogleMapController?>(null);
    final mapReady = useRef(false);
    final showSuggestions = useState(false);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.whiteColor;
    final shadowColor = AppColors.shadowColor;

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
              listener: (context, mapState) {
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
                              textColor: AppColors.primaryColor,
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

                    // ── TOP BAR ───────────────────────────────────────────
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: CustomTopbar(title: 'ATM Locator'),
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
                            // Search field using CustomTextFormField
                            Container(
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(color: shadowColor, blurRadius: 10),
                                ],
                              ),
                              child: CustomTextFormField(
                                controller: searchController,
                                focusNode: searchFocusNode,
                                hintText: 'Search ATM...',
                                keyboardType: TextInputType.text,
                                prefixIcon: 'search', // your SVG asset name
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
                                editIcon: mapState.searchQuery.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          searchController.clear();
                                          showSuggestions.value = false;
                                          context.read<MapBloc>().add(
                                            const MapEvent.searchCleared(),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.clear,
                                          color: AppColors.greyColor,
                                        ),
                                      )
                                    : null,
                                customFilled: mapState.searchQuery.isNotEmpty,
                              ),
                            ),

                            // ── SUGGESTION DROPDOWN ───────────────────────
                            if (showSuggestions.value &&
                                mapState.displayedATMs.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                constraints: const BoxConstraints(
                                  maxHeight: 250,
                                ),
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: mapState.displayedATMs.length
                                      .clamp(0, 6),
                                  separatorBuilder: (_, __) => Divider(
                                    height: 1,
                                    color: AppColors.greyColor.withOpacity(.2),
                                  ),
                                  itemBuilder: (context, index) {
                                    final atm = mapState.displayedATMs[index];
                                    return ListTile(
                                      leading: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.atm,
                                          color: AppColors.primaryColor,
                                          size: 18,
                                        ),
                                      ),
                                      title: Text(
                                        atm.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      subtitle: Text(
                                        atm.address ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 12),
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: atm.isOpen
                                              ? AppColors.greenColor
                                                    .withOpacity(.1)
                                              : AppColors.redColor.withOpacity(
                                                  .1,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          atm.isOpen ? 'Open' : 'Closed',
                                          style: TextStyle(
                                            color: atm.isOpen
                                                ? AppColors.greenColor
                                                : AppColors.redColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        searchController.text = atm.name;
                                        showSuggestions.value = false;
                                        FocusScope.of(context).unfocus();
                                        context.read<MapBloc>().add(
                                          MapEvent.atmSelected(atm),
                                        );
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
                      Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),

                    // ── ERROR ─────────────────────────────────────────────
                    if (mapState.error.isNotEmpty)
                      Positioned(
                        bottom: 200,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.errorColor.withOpacity(.08),
                            border: Border.all(color: AppColors.errorColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.errorColor,
                              ),
                              AppSpacing.horizontalSpaceSmall,
                              Expanded(
                                child: Text(
                                  mapState.error,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: AppColors.errorColor),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: AppColors.errorColor,
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
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: shadowColor, blurRadius: 5),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.atm,
                              size: 14,
                              color: AppColors.primaryColor,
                            ),
                            AppSpacing.horizontalSpaceTiny,
                            Text(
                              '${mapState.displayedATMs.length} ATMs',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor,
                                  ),
                            ),
                          ],
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: shadowColor, blurRadius: 8),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.my_location,
                            color: AppColors.primaryColor,
                          ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.whiteColor;

    final distanceM = mapState.routeDistanceM;
    final durationMin = mapState.routeDurationMin;

    final distanceText = distanceM == null
        ? '-- m'
        : distanceM >= 1000
        ? '${(distanceM / 1000).toStringAsFixed(1)} km'
        : '$distanceM m';

    final durationText = durationMin == null ? '-- min' : '$durationMin min';

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
        // ── ROUTE BAR ─────────────────────────────────────────────────
        if (mapState.polylines.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _routeStat(Icons.directions_walk, distanceText),
                Container(
                  width: 1,
                  height: 20,
                  color: AppColors.whiteColor.withOpacity(.4),
                ),
                _routeStat(Icons.timer, durationText),
              ],
            ),
          ),

        // ── FLOATING INFO CARD ─────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── YOUR LOCATION ROW ──────────────────────────────────
              _locationRow(
                context,
                icon: Icons.home_outlined,
                label: 'Your Location',
                sublabel: userLabel,
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
                        color: AppColors.greyColor.withOpacity(.4),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ),
              ),

              // ── ATM ROW ────────────────────────────────────────────
              _locationRow(
                context,
                icon: Icons.atm,
                label: 'ATM Nearby',
                sublabel: atm.address?.isNotEmpty == true
                    ? atm.address!
                    : atm.name,
              ),

              AppSpacing.verticalSpaceLarge,

              // ── ROUTE LOADING ──────────────────────────────────────
              if (mapState.routeStatus == FormzSubmissionStatus.inProgress)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),

              // ── ACTION BUTTONS ─────────────────────────────────────
              if (mapState.routeStatus != FormzSubmissionStatus.inProgress)
                Row(
                  children: [
                    Expanded(
                      child: Button(
                        mapState.polylines.isEmpty ? 'Show Route' : 'Reroute',
                        icon: Icons.route,
                        iconColor: AppColors.whiteColor,
                        color: AppColors.primaryColor,
                        onPressed: () => context.read<MapBloc>().add(
                          MapEvent.routeRequested(atm),
                        ),
                      ),
                    ),
                    AppSpacing.horizontalSpaceSmall,
                    Expanded(
                      child: Button(
                        'Navigate',
                        icon: Icons.directions,
                        iconColor: AppColors.whiteColor,
                        color: AppColors.greenColor,
                        onPressed: () => _launchDirections(
                          context,
                          atm,
                          userLocation,
                          mapState,
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

  Widget _routeStat(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.whiteColor, size: 20),
        AppSpacing.horizontalSpaceSmall,
        Text(
          label,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _locationRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String sublabel,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.primaryColor),
        ),
        AppSpacing.horizontalSpaceMedium,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                sublabel,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
    MapState mapState,
  ) async {
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
            child: Text(
              'Not Now',
              style: TextStyle(color: AppColors.greyColor),
            ),
          ),
          Button(
            'Open Settings',
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
          ),
        ],
      ),
    );
  }
}

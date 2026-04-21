import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:esae_monie/blocs/maps/maps_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/maps/atm.dart';
import 'package:esae_monie/presentation/widgets/button.dart';

const Color _navigateColor = Color(0xFFB8956A); // Light brown/grey

class MapFloatingCard extends StatelessWidget {
  final MapState mapState;
  final Position? userLocation;
  final Color surfaceColor;

  const MapFloatingCard({
    super.key,
    required this.mapState,
    required this.userLocation,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    final atm = mapState.selectedATM!;
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
        if (mapState.polylines.isNotEmpty)
          _buildRouteBar(distanceText, durationText),
        _buildInfoCard(context, atm, userLabel),
      ],
    );
  }

  Widget _buildRouteBar(String distanceText, String durationText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.blueColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor.withOpacity(.3),
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
    );
  }

  Widget _buildInfoCard(BuildContext context, ATM atm, String userLabel) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          _locationRow(
            context,
            icon: Icons.home_outlined,
            label: 'Your Location',
            sublabel: userLabel,
          ),
          _buildLocationConnector(),
          _locationRow(
            context,
            icon: Icons.atm,
            label: 'ATM Nearby',
            sublabel: atm.address?.isNotEmpty == true ? atm.address! : atm.name,
          ),
          AppSpacing.verticalSpaceLarge,
          _buildActionButtons(context, atm),
        ],
      ),
    );
  }

  Widget _buildLocationConnector() {
    return Padding(
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
    );
  }

  Widget _buildActionButtons(BuildContext context, ATM atm) {
    if (mapState.routeStatus == FormzSubmissionStatus.inProgress) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.blueColor),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Button(
            mapState.polylines.isEmpty ? 'Show Route' : 'Reroute',
            color: AppColors.blueColor,
            onPressed: () =>
                context.read<MapBloc>().add(MapEvent.routeRequested(atm)),
          ),
        ),
        AppSpacing.horizontalSpaceSmall,
        Expanded(
          child: Button(
            'Navigate',
            color: const Color.fromARGB(255, 167, 160, 151),
            onPressed: () => _launchDirections(context, atm),
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
            color: AppColors.secondaryColor.withOpacity(.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.secondaryColor),
        ),
        AppSpacing.horizontalSpaceSmall,
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

  Future<void> _launchDirections(BuildContext context, ATM atm) async {
    final origin =
        mapState.isSearchingFromCustomLocation && mapState.searchCenter != null
        ? '${mapState.searchCenter!.latitude},${mapState.searchCenter!.longitude}'
        : userLocation != null
        ? '${userLocation!.latitude},${userLocation!.longitude}'
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
      '&destination=$destination&travelmode=driving',
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
}

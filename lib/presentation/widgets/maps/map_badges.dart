import 'package:flutter/material.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/blocs/maps/maps_bloc.dart';

class MapATMCountBadge extends StatelessWidget {
  final MapState mapState;
  final Color surfaceColor;

  const MapATMCountBadge({
    super.key,
    required this.mapState,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: mapState.isSearchingFromCustomLocation ? 190 : 170,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 5)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.atm, size: 13, color: AppColors.secondaryColor),
            const SizedBox(width: 4),
            Text(
              '${mapState.displayedATMs.length} ATMs',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.secondaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

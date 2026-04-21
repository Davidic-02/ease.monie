import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esae_monie/blocs/maps/maps_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';

class MapErrorBanner extends StatelessWidget {
  final MapState mapState;

  const MapErrorBanner({super.key, required this.mapState});

  @override
  Widget build(BuildContext context) {
    if (mapState.error.isEmpty) return const SizedBox.shrink();

    return Positioned(
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
            const Icon(Icons.error_outline, color: AppColors.errorColor),
            AppSpacing.horizontalSpaceSmall,
            Expanded(
              child: Text(
                mapState.error,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.errorColor),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.errorColor),
              onPressed: () =>
                  context.read<MapBloc>().add(const MapEvent.clearError()),
            ),
          ],
        ),
      ),
    );
  }
}

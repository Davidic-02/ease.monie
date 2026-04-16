import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class ServiceCard extends StatelessWidget {
  final ServicesModel service;
  final VoidCallback onButtonPressed;
  final bool showProgressBar;
  final bool showPercentageBadge;
  final String buttonText;
  final String? bottomLeftText;
  final Color? buttonColor;
  final Color? progressColor;
  final Color? progressBackgroundColor;
  final DateTime? deadlineDate;
  final bool showDaysLeftBadge;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onButtonPressed,
    this.showProgressBar = false,
    this.showPercentageBadge = false,
    this.buttonText = 'Donate',
    this.bottomLeftText,
    this.buttonColor,
    this.progressColor,
    this.progressBackgroundColor,
    this.deadlineDate,
    this.showDaysLeftBadge = true,
  });

  int? get daysLeft {
    if (deadlineDate == null) return null;
    final difference = deadlineDate!.difference(DateTime.now()).inDays;
    return difference >= 0 ? difference : 0;
  }

  Color _getDaysLeftColor() {
    if (daysLeft == null) return Colors.green;

    if (daysLeft! == 0) {
      return Colors.red.shade600;
    } else if (daysLeft! <= 2) {
      return Colors.red.shade400;
    } else if (daysLeft! <= 5) {
      return Colors.orange.shade400;
    } else if (daysLeft! <= 10) {
      return Colors.amber.shade400;
    } else {
      return Colors.green.shade400;
    }
  }

  String _getDaysLeftText() {
    if (daysLeft == null) return '';
    if (daysLeft == 0) return 'Expires today';
    if (daysLeft == 1) return '1 day left';
    return '$daysLeft days left';
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = showPercentageBadge
        ? service.getDonationColor(context)
        : null;

    final finalButtonColor = buttonColor ?? AppColors.blueColor;
    final finalProgressColor = progressColor ?? AppColors.blueColor;
    final finalProgressBgColor =
        progressBackgroundColor ?? AppColors.blueColor.withValues(alpha: 0.2);

    // Determine what to show at bottom left
    String overallDonatedAmount;
    if (bottomLeftText != null) {
      overallDonatedAmount = bottomLeftText!;
    } else {
      overallDonatedAmount = '₦${service.donatedAmount.toStringAsFixed(0)}';
    }

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container with Optional Days Left Badge
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      service.imagePath,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Days Left Badge - TOP LEFT with backdrop blur effect
                if (showDaysLeftBadge &&
                    deadlineDate != null &&
                    daysLeft != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getDaysLeftColor().withValues(
                              alpha: 0.2,
                            ), // very transparent
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _getDaysLeftText(),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            AppSpacing.verticalSpaceMedium,

            // Title and Optional Percentage Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    service.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (showPercentageBadge && badgeColor != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${(service.donationProgress * 100).toStringAsFixed(0)}%',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: badgeColor),
                    ),
                  ),
                ],
              ],
            ),

            // Organizer/Subtitle Text
            Text(
              service.organizer,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),

            AppSpacing.verticalSpaceMedium,

            // Optional Progress Bar
            if (showProgressBar) ...[
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: finalProgressBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: service.donationProgress.clamp(0.0, 1.0),
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      finalProgressColor,
                    ),
                  ),
                ),
              ),
              AppSpacing.verticalSpaceMedium,
            ],

            // Bottom Text and Action Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    overallDonatedAmount,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onButtonPressed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: finalButtonColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      buttonText,
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ServicesModel {
  final String id;
  final String imagePath;
  final String title;
  final String organizer;
  final double targetAmount;
  final double donatedAmount;
  ServicesModel({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.organizer,
    required this.targetAmount,
    required this.donatedAmount,
  });

  double get donationProgress => donatedAmount / targetAmount;

  Color getDonationColor(BuildContext context) {
    if (donationProgress < 0.5) return Colors.red;
    if (donationProgress >= 0.8) return Colors.green;
    return Theme.of(context).colorScheme.primary;
  }

  ServicesModel copyWith({
    String? id,
    String? imagePath,
    String? title,
    String? organizer,
    double? targetAmount,
    double? donatedAmount,
  }) {
    return ServicesModel(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
      organizer: organizer ?? this.organizer,
      targetAmount: targetAmount ?? this.targetAmount,
      donatedAmount: donatedAmount ?? this.donatedAmount,
    );
  }
}

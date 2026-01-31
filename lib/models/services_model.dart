import 'package:flutter/material.dart';

class ServicesModel {
  final String id;
  final String imagePath;
  final String title;
  final String organizer;
  final double targetAmount;
  final double donatedAmount;
  final String? cashBack;
  ServicesModel({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.organizer,
    required this.targetAmount,
    required this.donatedAmount,
    this.cashBack,
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

List<ServicesModel> giftModel = [
  ServicesModel(
    id: 'gift1',
    imagePath: 'assets/images/gift1.png',
    title: 'Eid Gift',
    organizer: 'Send Eid Gift to your loved ones',
    targetAmount: 0,
    donatedAmount: 0,
    cashBack: '10%',
  ),
  ServicesModel(
    id: 'gift2',
    imagePath: 'assets/images/gift2.png',
    title: 'Birthday Gift',
    organizer: 'Send Birthday Gift to your loved ones',
    targetAmount: 0,
    donatedAmount: 0,
    cashBack: '20%',
  ),
  ServicesModel(
    id: 'gift3',
    imagePath: 'assets/images/gift3.png',
    title: 'Marriage Gift',
    organizer: 'Send Marriage Gift to your loved ones',
    targetAmount: 0,
    cashBack: '10%',
    donatedAmount: 0,
  ),
];

List<ServicesModel> insuranceModel = [
  ServicesModel(
    id: 'insurance1',
    imagePath: 'assets/images/insurance1.png',
    title: 'Family Insurance',
    organizer: 'Family Plans Cover two or more members',
    targetAmount: 0,
    donatedAmount: 0,
  ),

  ServicesModel(
    id: 'insurance2',
    imagePath: 'assets/images/insurance2.png',
    title: 'House Insurance',
    organizer: 'Family Plans Cover two or more members',
    targetAmount: 0,
    donatedAmount: 0,
  ),

  ServicesModel(
    id: 'insurance3',
    imagePath: 'assets/images/insurance3.png',
    title: 'Health Insurance',
    organizer: 'Family Plans Cover two or more members',
    targetAmount: 0,
    donatedAmount: 0,
  ),
];

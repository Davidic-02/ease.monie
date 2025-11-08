import 'package:flutter/material.dart';

class AppSpacing {
  const AppSpacing._();

  static Size screenHeight(BuildContext context) => MediaQuery.of(context).size;

  static Size screenWidth(BuildContext context) => MediaQuery.of(context).size;

  // Vertical Spacing
  static SizedBox verticalSpaceTiny = const SizedBox(height: 4);
  static SizedBox verticalSpaceSmall = const SizedBox(height: 8);
  static SizedBox verticalSpaceMedium = const SizedBox(height: 16);
  static SizedBox verticalSpaceLarge = const SizedBox(height: 25);
  static SizedBox verticalSpaceHuge = const SizedBox(height: 30);
  static SizedBox verticalSpaceMassive = const SizedBox(height: 40);

  // Vertical Heights.
  static double verticalValueTiny = 4;
  static double verticalValueSmall = 8;
  static double verticalValueMedium = 10;
  static double verticalValueSpaceLarge = 16;

  // Horizontal Spacing.
  static SizedBox horizontalSpaceTiny = const SizedBox(width: 4);
  static SizedBox horizontalSpaceSmall = const SizedBox(width: 8);
  static SizedBox horizontalSpaceMedium = const SizedBox(width: 16);
  static SizedBox horizontalSpaceLarge = const SizedBox(width: 24);
  static SizedBox horizontalSpaceHuge = const SizedBox(width: 32);
  static SizedBox horizontalSpaceMassive = const SizedBox(width: 40);

  static double horizontalSpacing = 20;
  static double horizontalSpacingTiny = 4;
  static double horizontalSpacingSmall = 8;
  static double horizontalSpacingMedium = 20;
}

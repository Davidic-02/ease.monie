import 'package:esae_monie/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//LIGHT MODE
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBg,
  primaryColor: AppColors.primaryColor,
  colorScheme: const ColorScheme.light(
    primary: AppColors.whiteColor,
    secondary: AppColors.accentNeon,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: AppColors.textColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.textColor,
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.manrope(color: AppColors.textColor),
    bodyMedium: GoogleFonts.manrope(color: AppColors.textColor),
    bodySmall: GoogleFonts.manrope(color: AppColors.greyColor),
    displaySmall: GoogleFonts.manrope(color: AppColors.textColor),
    headlineSmall: GoogleFonts.manrope(
      color: AppColors.textColor,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.primaryColor.withValues(alpha: .04),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedIconTheme: const IconThemeData(color: AppColors.primaryColor),
    unselectedIconTheme: IconThemeData(
      color: AppColors.primaryColor.withValues(alpha: .5),
    ),
  ),
);

//DARK MODE
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.blackColor,
  primaryColor: AppColors.primaryColor.withValues(alpha: .1),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.blackColor,
    secondary: AppColors.redColor,
    surface: AppColors.darkSurface,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primaryColor.withValues(alpha: .2),
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.manrope(color: Colors.white),
    bodyMedium: GoogleFonts.manrope(color: AppColors.whiteColor),
    bodySmall: GoogleFonts.manrope(color: AppColors.whiteColor),
    displaySmall: GoogleFonts.manrope(
      color: AppColors.accentNeon,
      fontSize: 18,
    ),
    headlineSmall: GoogleFonts.manrope(
      color: AppColors.whiteColor,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.primaryColor.withValues(alpha: .1),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accentNeon,
      foregroundColor: AppColors.darkBg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedIconTheme: const IconThemeData(color: AppColors.primaryColor),
    unselectedIconTheme: IconThemeData(
      color: AppColors.primaryColor.withValues(alpha: .5),
    ),
  ),
);

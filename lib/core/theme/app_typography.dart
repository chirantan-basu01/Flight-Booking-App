import 'package:flutter/material.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'SF Pro Display';

  static TextStyle get heading1 => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
        height: 1.3,
      );

  static TextStyle get heading2 => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
        height: 1.3,
      );

  static TextStyle get heading3 => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
        height: 1.3,
      );

  static TextStyle get body => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.darkGray,
        height: 1.5,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.darkGray,
        height: 1.5,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.darkGray,
        height: 1.5,
      );

  static TextStyle get caption => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.mediumGray,
        height: 1.4,
      );

  static TextStyle get captionMedium => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.mediumGray,
        height: 1.4,
      );

  static TextStyle get price => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryBlue,
        height: 1.2,
      );

  static TextStyle get priceSmall => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryBlue,
        height: 1.2,
      );

  static TextStyle get button => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        height: 1.2,
      );

  static TextStyle get buttonSmall => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        height: 1.2,
      );

  static TextStyle get label => const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.mediumGray,
        letterSpacing: 0.5,
        height: 1.2,
      );

  static TextStyle get time => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
        height: 1.2,
      );

  static TextStyle get airportCode => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
        height: 1.2,
      );

  static TextStyle get duration => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.mediumGray,
        height: 1.2,
      );
}
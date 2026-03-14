import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';

class BarcodeWidget extends StatelessWidget {
  final String? barcodeSvg;
  final String? bookingReference;

  const BarcodeWidget({
    super.key,
    this.barcodeSvg,
    this.bookingReference,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barcode
          if (barcodeSvg != null && barcodeSvg!.isNotEmpty)
            SvgPicture.string(
              barcodeSvg!,
              fit: BoxFit.contain,
              width: double.infinity,
              height: 70,
            )
          else
            _buildFallbackBarcode(),

          const SizedBox(height: 12),

          // Booking Reference
          if (bookingReference != null)
            Text(
              bookingReference!,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: AppColors.black,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallbackBarcode() {
    // Generate a simple barcode-like pattern as fallback
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          40,
          (index) {
            final width = (index % 3 == 0) ? 3.0 : (index % 2 == 0) ? 2.0 : 1.5;
            return Container(
              width: width,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              color: index % 2 == 0 ? AppColors.black : Colors.transparent,
            );
          },
        ),
      ),
    );
  }
}
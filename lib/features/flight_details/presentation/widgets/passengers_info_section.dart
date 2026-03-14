import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/features/flight_details/domain/models/passenger_model.dart';
import 'package:flight_booking_app/features/flight_details/domain/models/booking_info_model.dart';

class PassengersInfoSection extends StatelessWidget {
  final List<PassengerModel> passengers;
  final BookingInfoModel? bookingInfo;

  const PassengersInfoSection({
    super.key,
    required this.passengers,
    this.bookingInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomPaint(
        painter: _PassengerCardPainter(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Passengers Info',
                style: AppTypography.heading2.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              // Passenger List
              ...passengers.asMap().entries.map((entry) {
                final index = entry.key;
                final passenger = entry.value;
                final isLast = index == passengers.length - 1;

                return Column(
                  children: [
                    _buildPassengerRow(passenger),
                    if (!isLast) ...[
                      const SizedBox(height: 16),
                      _buildDashedDivider(),
                      const SizedBox(height: 16),
                    ],
                  ],
                );
              }),

              const SizedBox(height: 20),

              // Dashed divider before barcode (this aligns with notches)
              _buildDashedDivider(),

              const SizedBox(height: 24),

              // Barcode - centered
              _buildBarcode(),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerRow(PassengerModel passenger) {
    return Row(
      children: [
        // Profile Picture (circular)
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: passenger.profilePicture ?? '',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 48,
              height: 48,
              color: AppColors.lightGray,
              child: const Icon(
                Icons.person,
                size: 24,
                color: AppColors.mediumGray,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 48,
              height: 48,
              color: AppColors.lightGray,
              child: const Icon(
                Icons.person,
                size: 24,
                color: AppColors.mediumGray,
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Passenger Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PASSENGER ${passenger.passengerNumber ?? 1}',
                style: AppTypography.caption.copyWith(
                  fontSize: 11,
                  color: AppColors.mediumGray,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${passenger.title ?? ''} ${passenger.name ?? 'Unknown'}',
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),

        // Seat Number
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'SEAT',
              style: AppTypography.caption.copyWith(
                fontSize: 11,
                color: AppColors.mediumGray,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              passenger.seat ?? '-',
              style: AppTypography.heading2.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 6.0;
        const dashSpace = 4.0;
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dashCount,
            (index) => Container(
              width: dashWidth,
              height: 1,
              color: AppColors.borderGray,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBarcode() {
    if (bookingInfo?.barcode != null && bookingInfo!.barcode!.isNotEmpty) {
      return Center(
        child: SizedBox(
          width: 200,
          height: 50,
          child: SvgPicture.string(
            bookingInfo!.barcode!,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    // Fallback barcode pattern - realistic looking barcode
    return Center(
      child: SizedBox(
        width: 200,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _generateBarcodePattern().asMap().entries.map((entry) {
            final index = entry.key;
            final width = entry.value;
            return Container(
              width: width,
              height: 45,
              color: index % 2 == 0 ? AppColors.black : Colors.transparent,
            );
          }).toList(),
        ),
      ),
    );
  }

  List<double> _generateBarcodePattern() {
    // Generate a realistic barcode pattern with varying widths
    final List<double> pattern = [];
    final List<double> widths = [1.0, 1.5, 2.0, 2.5, 3.0, 1.0, 2.0, 1.5];

    // Start bars
    pattern.addAll([2.0, 1.0, 2.0, 1.0]);

    // Middle section - varied pattern
    for (int i = 0; i < 35; i++) {
      pattern.add(widths[i % widths.length]);
    }

    // End bars
    pattern.addAll([1.0, 2.0, 1.0, 2.0]);

    return pattern;
  }
}

class _PassengerCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double notchRadius = 14;
    const double cornerRadius = 20;
    // Position notches at approximately 70% of the card height (where divider before barcode is)
    final notchY = size.height * 0.72;

    final path = Path();

    // Start from top-left corner
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // Top edge
    path.lineTo(size.width - cornerRadius, 0);

    // Top-right corner
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // Right edge down to notch
    path.lineTo(size.width, notchY - notchRadius);

    // Right notch (semi-circle going inward)
    path.arcToPoint(
      Offset(size.width, notchY + notchRadius),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );

    // Right edge after notch to bottom-right corner
    path.lineTo(size.width, size.height - cornerRadius);

    // Bottom-right corner
    path.quadraticBezierTo(size.width, size.height, size.width - cornerRadius, size.height);

    // Bottom edge
    path.lineTo(cornerRadius, size.height);

    // Bottom-left corner
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);

    // Left edge up to notch
    path.lineTo(0, notchY + notchRadius);

    // Left notch (semi-circle going inward)
    path.arcToPoint(
      Offset(0, notchY - notchRadius),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );

    // Left edge back to start
    path.lineTo(0, cornerRadius);

    path.close();

    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(path.shift(const Offset(0, 4)), shadowPaint);

    // Draw fill
    final fillPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = AppColors.borderGray
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
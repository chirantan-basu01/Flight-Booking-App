import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/features/flight_details/domain/models/flight_detail_model.dart';

class BoardingPassCard extends StatelessWidget {
  final FlightDetailModel flightDetails;

  const BoardingPassCard({
    super.key,
    required this.flightDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomPaint(
        painter: _BoardingPassPainter(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Airline Header
              _buildAirlineHeader(),

              const SizedBox(height: 20),

              // Flight Route
              _buildFlightRoute(),

              const SizedBox(height: 20),

              // Dashed Divider
              _buildDashedDivider(),

              const SizedBox(height: 16),

              // Flight Info Row (Terminal, Gate, Class)
              _buildFlightInfoRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAirlineHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Airline Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: flightDetails.airlineLogo ?? '',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  width: 40,
                  height: 40,
                  color: AppColors.lightGray,
                  child: const Icon(Icons.flight, size: 20),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 40,
                  height: 40,
                  color: AppColors.lightGray,
                  child: const Icon(Icons.flight, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              flightDetails.airlineName ?? 'Unknown Airline',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        // Flight ID
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Flight ID',
              style: AppTypography.caption.copyWith(
                fontSize: 11,
                color: AppColors.mediumGray,
              ),
            ),
            Text(
              flightDetails.flightId ?? flightDetails.flightNumber ?? '',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFlightRoute() {
    return Row(
      children: [
        // Departure
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatTime(flightDetails.departure?.time),
                style: AppTypography.heading1.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                flightDetails.departure?.airportCode ?? '',
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              Text(
                flightDetails.departure?.city ?? '',
                style: AppTypography.caption.copyWith(
                  fontSize: 13,
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
        ),

        // Duration with plane
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.borderGray,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderGray),
                    ),
                    child: const Icon(
                      Icons.flight,
                      size: 14,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.borderGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                flightDetails.duration ?? '',
                style: AppTypography.caption.copyWith(
                  fontSize: 13,
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
        ),

        // Arrival
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(flightDetails.arrival?.time),
                style: AppTypography.heading1.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                flightDetails.arrival?.airportCode ?? '',
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              Text(
                flightDetails.arrival?.city ?? '',
                style: AppTypography.caption.copyWith(
                  fontSize: 13,
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
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

  Widget _buildFlightInfoRow() {
    return Row(
      children: [
        _buildInfoItem('Terminal', flightDetails.terminal ?? '-'),
        const SizedBox(width: 24),
        _buildInfoItem('Gate', flightDetails.gate ?? '-'),
        const Spacer(),
        _buildInfoItem('Class', flightDetails.flightClass ?? 'Economy', alignEnd: true),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.caption.copyWith(
            fontSize: 11,
            color: AppColors.mediumGray,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  String _formatTime(String? time) {
    if (time == null) return '--:--';
    // If time is in HH:MM:SS format, extract HH:MM
    if (time.contains(':')) {
      final parts = time.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
    }
    return time;
  }
}

class _BoardingPassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double notchRadius = 14;
    const double cornerRadius = 20;
    final notchY = size.height * 0.72; // Position for the notches

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
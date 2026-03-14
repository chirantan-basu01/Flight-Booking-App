import 'package:flutter/material.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';

class SavedTripCard extends StatelessWidget {
  final String airlineName;
  final String airlineLogo;
  final String departureTime;
  final String departureCode;
  final String departureCity;
  final String arrivalTime;
  final String arrivalCode;
  final String arrivalCity;
  final String duration;
  final String date;

  const SavedTripCard({
    super.key,
    required this.airlineName,
    required this.airlineLogo,
    required this.departureTime,
    required this.departureCode,
    required this.departureCity,
    required this.arrivalTime,
    required this.arrivalCode,
    required this.arrivalCity,
    required this.duration,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    const double notchRadius = 10;
    const double dividerFromBottom = 52; // Position of divider from bottom

    return SizedBox(
      width: 280,
      child: CustomPaint(
        painter: _TicketPainter(
          notchRadius: notchRadius,
          dividerFromBottom: dividerFromBottom,
          borderColor: const Color(0xFFE0E0E0),
          fillColor: AppColors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Airline Name
              Center(
                child: Text(
                  airlineName,
                  style: AppTypography.heading3.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF22C55E),
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Flight Route Row
              Row(
                children: [
                  // Departure Info
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          departureTime,
                          style: AppTypography.heading3.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF22C55E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: departureCode,
                                style: AppTypography.heading3.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              TextSpan(
                                text: ' ($departureCity)',
                                style: AppTypography.caption.copyWith(
                                  fontSize: 10,
                                  color: AppColors.mediumGray,
                                ),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),

                  // Duration with plane icon
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 1,
                              color: const Color(0xFFD0D0D0),
                            ),
                            const SizedBox(width: 3),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.flight,
                                  size: 11,
                                  color: Color(0xFF3B82F6),
                                ),
                              ),
                            ),
                            const SizedBox(width: 3),
                            Container(
                              width: 10,
                              height: 1,
                              color: const Color(0xFFD0D0D0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          duration,
                          style: AppTypography.caption.copyWith(
                            fontSize: 10,
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Arrival Info
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          arrivalTime,
                          style: AppTypography.heading3.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: arrivalCode,
                                style: AppTypography.heading3.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              TextSpan(
                                text: ' ($arrivalCity)',
                                style: AppTypography.caption.copyWith(
                                  fontSize: 10,
                                  color: AppColors.mediumGray,
                                ),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Dashed Divider (this aligns with the notches)
              _buildDashedDivider(),

              const SizedBox(height: 10),

              // Date Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DATE',
                          style: AppTypography.label.copyWith(
                            fontSize: 9,
                            color: AppColors.mediumGray,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          date,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'DATE',
                          style: AppTypography.label.copyWith(
                            fontSize: 9,
                            color: AppColors.mediumGray,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          date,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const dashSpace = 3.0;
        final dashCount =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dashCount,
            (index) => Container(
              width: dashWidth,
              height: 1,
              color: const Color(0xFFE0E0E0),
            ),
          ),
        );
      },
    );
  }
}

class _TicketPainter extends CustomPainter {
  final double notchRadius;
  final double dividerFromBottom;
  final Color borderColor;
  final Color fillColor;

  _TicketPainter({
    required this.notchRadius,
    required this.dividerFromBottom,
    required this.borderColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final notchY = size.height - dividerFromBottom;
    const cornerRadius = 14.0;

    // Create the ticket path with notches
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
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Right edge after notch to bottom-right corner
    path.lineTo(size.width, size.height - cornerRadius);

    // Bottom-right corner
    path.quadraticBezierTo(
        size.width, size.height, size.width - cornerRadius, size.height);

    // Bottom edge
    path.lineTo(cornerRadius, size.height);

    // Bottom-left corner
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);

    // Left edge up to notch
    path.lineTo(0, notchY + notchRadius);

    // Left notch (semi-circle going inward)
    path.arcToPoint(
      Offset(0, notchY - notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Left edge back to start
    path.lineTo(0, cornerRadius);

    path.close();

    // Draw fill
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
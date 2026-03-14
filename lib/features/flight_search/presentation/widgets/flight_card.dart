import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/flight_model.dart';

class FlightCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback onSelect;

  const FlightCard({
    super.key,
    required this.flight,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipPath(
        clipper: TicketClipper(notchRadius: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top section - Flight details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Airline Info Row
                    Row(
                      children: [
                        // Airline Logo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: flight.airlineLogo ?? '',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.lightGray,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.flight,
                                color: AppColors.mediumGray,
                                size: 20,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.lightGray,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.flight,
                                color: AppColors.mediumGray,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Airline Name
                        Expanded(
                          child: Text(
                            flight.airlineName ?? 'Unknown Airline',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Flight Route Row
                    Row(
                      children: [
                        // Departure
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatTime(flight.departure?.time),
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 2),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: flight.departure?.airportCode ?? '',
                                      style: AppTypography.heading2.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' (${flight.departure?.city ?? ''})',
                                      style: AppTypography.caption.copyWith(
                                        fontSize: 12,
                                        color: AppColors.mediumGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Duration and Flight Line
                        Expanded(
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.flight,
                                    size: 18,
                                    color: AppColors.primaryBlue,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                flight.duration ?? '',
                                style: AppTypography.caption.copyWith(
                                  fontSize: 12,
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
                                _formatTime(flight.arrival?.time),
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 2),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: flight.arrival?.airportCode ?? '',
                                      style: AppTypography.heading2.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '(${flight.arrival?.city ?? ''})',
                                      style: AppTypography.caption.copyWith(
                                        fontSize: 12,
                                        color: AppColors.mediumGray,
                                      ),
                                    ),
                                  ],
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

              // Dotted divider with notches
              SizedBox(
                height: 24,
                child: Row(
                  children: [
                    // Left notch space
                    const SizedBox(width: 12),
                    // Dotted line
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          const dashWidth = 6.0;
                          const dashSpace = 4.0;
                          final dashCount =
                              (constraints.maxWidth / (dashWidth + dashSpace))
                                  .floor();
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(dashCount, (index) {
                              return Container(
                                width: dashWidth,
                                height: 1,
                                color: AppColors.borderGray,
                              );
                            }),
                          );
                        },
                      ),
                    ),
                    // Right notch space
                    const SizedBox(width: 12),
                  ],
                ),
              ),

              // Bottom section - Price and button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${flight.price?.amount?.toStringAsFixed(0) ?? '0'}',
                          style: AppTypography.price.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '/person',
                          style: AppTypography.caption.copyWith(
                            fontSize: 12,
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),

                    // Select Button
                    ElevatedButton(
                      onPressed: onSelect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: AppColors.white,
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Select flight',
                        style: AppTypography.button.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String? time) {
    if (time == null) return '--:--';
    // If time is in HH:mm:ss format, convert to HH:mm
    if (time.contains(':')) {
      final parts = time.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
    }
    return time;
  }
}

/// Custom clipper to create ticket-style notches on the sides
class TicketClipper extends CustomClipper<Path> {
  final double notchRadius;

  TicketClipper({this.notchRadius = 12});

  @override
  Path getClip(Size size) {
    final path = Path();
    final notchY = size.height * 0.62; // Position notches at ~62% from top

    // Start from top-left
    path.moveTo(0, 16);

    // Top-left corner
    path.quadraticBezierTo(0, 0, 16, 0);

    // Top edge
    path.lineTo(size.width - 16, 0);

    // Top-right corner
    path.quadraticBezierTo(size.width, 0, size.width, 16);

    // Right edge down to notch
    path.lineTo(size.width, notchY - notchRadius);

    // Right notch (semi-circle cut inward)
    path.arcToPoint(
      Offset(size.width, notchY + notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Right edge down to bottom
    path.lineTo(size.width, size.height - 16);

    // Bottom-right corner
    path.quadraticBezierTo(size.width, size.height, size.width - 16, size.height);

    // Bottom edge
    path.lineTo(16, size.height);

    // Bottom-left corner
    path.quadraticBezierTo(0, size.height, 0, size.height - 16);

    // Left edge up to notch
    path.lineTo(0, notchY + notchRadius);

    // Left notch (semi-circle cut inward)
    path.arcToPoint(
      Offset(0, notchY - notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Left edge up to top
    path.lineTo(0, 16);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
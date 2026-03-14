import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/features/flight_details/domain/models/passenger_model.dart';

class PassengerInfoCard extends StatelessWidget {
  final PassengerModel passenger;

  const PassengerInfoCard({
    super.key,
    required this.passenger,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Profile Picture
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: passenger.profilePicture ?? '',
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 56,
                height: 56,
                color: AppColors.lightGray,
                child: const Icon(
                  Icons.person,
                  size: 28,
                  color: AppColors.mediumGray,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 56,
                height: 56,
                color: AppColors.lightGray,
                child: const Icon(
                  Icons.person,
                  size: 28,
                  color: AppColors.mediumGray,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

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
                const SizedBox(height: 4),
                Text(
                  '${passenger.title ?? ''} ${passenger.name ?? 'Unknown'}',
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 16,
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
              const SizedBox(height: 4),
              Text(
                passenger.seat ?? '-',
                style: AppTypography.heading2.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
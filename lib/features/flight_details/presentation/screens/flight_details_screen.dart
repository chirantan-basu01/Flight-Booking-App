import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/features/flight_details/presentation/providers/flight_details_providers.dart';
import 'package:flight_booking_app/features/flight_details/presentation/widgets/boarding_pass_card.dart';
import 'package:flight_booking_app/features/flight_details/presentation/widgets/passengers_info_section.dart';

class FlightDetailsScreen extends ConsumerWidget {
  final int flightId;

  const FlightDetailsScreen({
    super.key,
    required this.flightId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightDetailsAsync = ref.watch(flightDetailsProvider(flightId));

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Back button in white circle
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: AppColors.black,
                        size: 24,
                      ),
                    ),
                  ),
                  // Title centered
                  Expanded(
                    child: Text(
                      'Your flight details',
                      textAlign: TextAlign.center,
                      style: AppTypography.heading2.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  // Empty space for symmetry
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
        ),
        body: flightDetailsAsync.when(
        data: (data) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Boarding Pass Card
              if (data.flightDetails != null)
                BoardingPassCard(flightDetails: data.flightDetails!),

              const SizedBox(height: 24),

              // Passengers Info Section with Barcode
              if (data.passengers != null)
                PassengersInfoSection(
                  passengers: data.passengers!,
                  bookingInfo: data.bookingInfo,
                ),

              const SizedBox(height: 80), // Space for FAB
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBlue,
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load flight details',
                  style: AppTypography.heading2,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: AppTypography.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref.invalidate(flightDetailsProvider(flightId)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: FloatingActionButton.extended(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Boarding pass saved!'),
                  backgroundColor: AppColors.primaryBlue,
                ),
              );
            },
            backgroundColor: AppColors.black,
            foregroundColor: AppColors.white,
            elevation: 2,
            shape: const StadiumBorder(),
            label: Text(
              'Download & Save pass',
              style: AppTypography.button.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
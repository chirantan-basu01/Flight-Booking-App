import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/features/flight_search/presentation/providers/flight_search_providers.dart';
import 'package:flight_booking_app/features/flight_search/presentation/widgets/flight_card.dart';
import 'package:flight_booking_app/features/flight_search/presentation/widgets/filter_chips.dart';
import 'package:flight_booking_app/features/flight_search/presentation/widgets/filter_bottom_sheet.dart';
import 'package:flight_booking_app/shared/widgets/shimmer_loading.dart';
import 'package:flight_booking_app/shared/widgets/animated_press_button.dart';
import 'package:flight_booking_app/routes/app_router.dart';

class FlightResultsScreen extends ConsumerWidget {
  const FlightResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightResults = ref.watch(flightSearchResultsProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
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
                      'Flight result',
                      textAlign: TextAlign.center,
                      style: AppTypography.heading2.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  // Menu button in white circle
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: AppColors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: const FilterChips(),
          ),

          // Flight List
          Expanded(
            child: flightResults.when(
              data: (flights) {
                if (flights.isEmpty) {
                  return _buildEmptyState(context, ref);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(flightSearchResultsProvider);
                  },
                  color: AppColors.primaryBlue,
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 8,
                      bottom: MediaQuery.of(context).padding.bottom + 80,
                    ),
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      final flight = flights[index];
                      return FadeInListItem(
                        index: index,
                        child: FlightCard(
                          flight: flight,
                          onSelect: () {
                            FlightDetailsRoute(flightId: flight.id ?? 0).push(context);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(
                context,
                ref,
                error.toString(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterBottomSheet(context, ref),
        backgroundColor: const Color(0xFFBFCFFF),
        elevation: 2,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.filter_alt_outlined,
          color: AppColors.primaryBlue,
          size: 26,
        ),
      ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  Widget _buildLoadingState() {
    return const FlightListShimmer(itemCount: 5);
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flight_outlined,
            size: 80,
            color: AppColors.mediumGray.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No flights found',
            style: AppTypography.heading2.copyWith(
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: AppTypography.body.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {
              ref.read(flightFilterStateProvider.notifier).clearFilters();
              ref.invalidate(flightSearchResultsProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Clear filters'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    String error,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: AppTypography.heading2.copyWith(
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTypography.body.copyWith(
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(flightSearchResultsProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
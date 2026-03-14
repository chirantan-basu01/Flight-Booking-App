import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/filter_model.dart';
import 'package:flight_booking_app/features/flight_search/presentation/providers/flight_search_providers.dart';
import 'package:flight_booking_app/features/home/presentation/providers/home_providers.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  @override
  void initState() {
    super.initState();
    // Load current filters into bottom sheet state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentFilters = ref.read(flightFilterStateProvider);
      ref.read(filterBottomSheetStateProvider.notifier).loadFromFilter(currentFilters);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(filterBottomSheetStateProvider);
    final filterNotifier = ref.read(filterBottomSheetStateProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: AppTypography.heading2,
                ),
                TextButton(
                  onPressed: filterNotifier.reset,
                  child: Text(
                    'Reset',
                    style: AppTypography.body.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Filter Options
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Airline Filter
                  _buildSectionTitle('Airline'),
                  const SizedBox(height: 12),
                  _buildSelectorButton(
                    value: filterState.selectedAirline ?? 'All Airlines',
                    onTap: () => _showAirlineSelector(filterNotifier),
                  ),

                  const SizedBox(height: 24),

                  // Stops Filter
                  _buildSectionTitle('Stops'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStopOption(null, 'Any', filterState.selectedStops, filterNotifier),
                      const SizedBox(width: 8),
                      _buildStopOption(0, 'Direct', filterState.selectedStops, filterNotifier),
                      const SizedBox(width: 8),
                      _buildStopOption(1, '1 Stop', filterState.selectedStops, filterNotifier),
                      const SizedBox(width: 8),
                      _buildStopOption(2, '2+ Stops', filterState.selectedStops, filterNotifier),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Price Range Filter
                  _buildSectionTitle('Price Range'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${filterState.priceMin.toInt()}',
                        style: AppTypography.bodyMedium,
                      ),
                      Text(
                        '\$${filterState.priceMax.toInt()}',
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(filterState.priceMin, filterState.priceMax),
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    activeColor: AppColors.primaryBlue,
                    inactiveColor: AppColors.borderGray,
                    onChanged: (values) {
                      filterNotifier.setPriceRange(values.start, values.end);
                    },
                  ),

                  const SizedBox(height: 24),

                  // Aircraft Type Filter
                  _buildSectionTitle('Aircraft Type'),
                  const SizedBox(height: 12),
                  _buildSelectorButton(
                    value: filterState.selectedAircraftType ?? 'All Aircraft',
                    onTap: () => _showAircraftTypeSelector(filterNotifier),
                  ),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _applyFilters(filterState),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Apply Filters',
                    style: AppTypography.button.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
    );
  }

  Widget _buildSelectorButton({
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: AppTypography.body.copyWith(color: AppColors.black),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.mediumGray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStopOption(
    int? stops,
    String label,
    int? selectedStops,
    FilterBottomSheetState notifier,
  ) {
    final isSelected = selectedStops == stops;
    return Expanded(
      child: GestureDetector(
        onTap: () => notifier.setStops(stops),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primaryBlue : AppColors.borderGray,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.caption.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.darkGray,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAirlineSelector(FilterBottomSheetState filterNotifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AirlineSelectorSheet(
        onSelected: (airline) {
          filterNotifier.setAirline(airline);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAircraftTypeSelector(FilterBottomSheetState filterNotifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AircraftTypeSelectorSheet(
        onSelected: (aircraftType) {
          filterNotifier.setAircraftType(aircraftType);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _applyFilters(FilterBottomSheetData filterState) {
    if (filterState.hasFilters) {
      ref.read(flightFilterStateProvider.notifier).updateFilter(
            FilterModel(
              airline: filterState.selectedAirline,
              stops: filterState.selectedStops,
              aircraftType: filterState.selectedAircraftType,
              priceMin: filterState.priceMin > 0 ? filterState.priceMin : null,
              priceMax: filterState.priceMax < 1000 ? filterState.priceMax : null,
            ),
          );
    } else {
      ref.read(flightFilterStateProvider.notifier).clearFilters();
    }

    Navigator.pop(context);
  }
}

/// Airline Selector Bottom Sheet
class _AirlineSelectorSheet extends ConsumerWidget {
  final ValueChanged<String?> onSelected;

  const _AirlineSelectorSheet({required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final airlinesAsync = ref.watch(airlinesProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Select Airline',
              style: AppTypography.heading2,
            ),
          ),

          const Divider(height: 1),

          // List
          Expanded(
            child: airlinesAsync.when(
              data: (airlines) {
                final items = [null, ...airlines.map((a) => a.airline).where((a) => a != null && a.isNotEmpty)];

                return ListView.separated(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).padding.bottom + 20,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderGray),
                  itemBuilder: (context, index) {
                    final airline = items[index];
                    final displayName = airline ?? 'All Airlines';

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.flight,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        displayName,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      onTap: () => onSelected(airline),
                    );
                  },
                );
              },
              loading: () => _buildShimmerList(),
              error: (_, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                    const SizedBox(height: 12),
                    Text('Failed to load airlines', style: AppTypography.body),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.invalidate(airlinesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 8,
      itemBuilder: (context, index) => _buildShimmerItem(),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 150,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Aircraft Type Selector Bottom Sheet
class _AircraftTypeSelectorSheet extends ConsumerWidget {
  final ValueChanged<String?> onSelected;

  const _AircraftTypeSelectorSheet({required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aircraftTypesAsync = ref.watch(aircraftTypesProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Select Aircraft Type',
              style: AppTypography.heading2,
            ),
          ),

          const Divider(height: 1),

          // List
          Expanded(
            child: aircraftTypesAsync.when(
              data: (aircraftTypes) {
                final items = [null, ...aircraftTypes.map((a) => a.aircraft).where((a) => a != null && a.isNotEmpty)];

                return ListView.separated(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).padding.bottom + 20,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderGray),
                  itemBuilder: (context, index) {
                    final aircraft = items[index];
                    final displayName = aircraft ?? 'All Aircraft';

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.airplanemode_active,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        displayName,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      onTap: () => onSelected(aircraft),
                    );
                  },
                );
              },
              loading: () => _buildShimmerList(),
              error: (_, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                    const SizedBox(height: 12),
                    Text('Failed to load aircraft types', style: AppTypography.body),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.invalidate(aircraftTypesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 6,
      itemBuilder: (context, index) => _buildShimmerItem(),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 120,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
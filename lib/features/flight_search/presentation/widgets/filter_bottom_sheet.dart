import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/filter_model.dart';
import 'package:flight_booking_app/features/flight_search/presentation/providers/flight_search_providers.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  final List<String> _airlines = [
    'All Airlines',
    'Garuda Indonesia',
    'Singapore Airlines',
    'AirAsia',
    'Japan Airlines',
    'Citilink',
    'Lion Air',
    'Thai Airways',
    'Malaysia Airlines',
  ];

  final List<String> _aircraftTypes = [
    'All Aircraft',
    'Boeing 737',
    'Boeing 777',
    'Boeing 787',
    'Airbus A320',
    'Airbus A350',
  ];

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
                  _buildDropdown(
                    value: filterState.selectedAirline ?? 'All Airlines',
                    items: _airlines,
                    onChanged: (value) {
                      filterNotifier.setAirline(value == 'All Airlines' ? null : value);
                    },
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
                  _buildDropdown(
                    value: filterState.selectedAircraftType ?? 'All Aircraft',
                    items: _aircraftTypes,
                    onChanged: (value) {
                      filterNotifier.setAircraftType(value == 'All Aircraft' ? null : value);
                    },
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

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: AppTypography.body.copyWith(color: AppColors.black),
              ),
            );
          }).toList(),
          onChanged: onChanged,
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
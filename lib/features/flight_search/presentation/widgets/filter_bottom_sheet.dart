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
  String? _selectedAirline;
  int? _selectedStops;
  String? _selectedAircraftType;
  RangeValues _priceRange = const RangeValues(0, 1000);

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
    // Load current filters
    final currentFilters = ref.read(flightFilterStateProvider);
    if (currentFilters != null) {
      _selectedAirline = currentFilters.airline;
      _selectedStops = currentFilters.stops;
      _selectedAircraftType = currentFilters.aircraftType;
      if (currentFilters.priceMin != null && currentFilters.priceMax != null) {
        _priceRange = RangeValues(
          currentFilters.priceMin!,
          currentFilters.priceMax!,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: _resetFilters,
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
                    value: _selectedAirline ?? 'All Airlines',
                    items: _airlines,
                    onChanged: (value) {
                      setState(() {
                        _selectedAirline = value == 'All Airlines' ? null : value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Stops Filter
                  _buildSectionTitle('Stops'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStopOption(null, 'Any'),
                      const SizedBox(width: 8),
                      _buildStopOption(0, 'Direct'),
                      const SizedBox(width: 8),
                      _buildStopOption(1, '1 Stop'),
                      const SizedBox(width: 8),
                      _buildStopOption(2, '2+ Stops'),
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
                        '\$${_priceRange.start.toInt()}',
                        style: AppTypography.bodyMedium,
                      ),
                      Text(
                        '\$${_priceRange.end.toInt()}',
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    activeColor: AppColors.primaryBlue,
                    inactiveColor: AppColors.borderGray,
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Aircraft Type Filter
                  _buildSectionTitle('Aircraft Type'),
                  const SizedBox(height: 12),
                  _buildDropdown(
                    value: _selectedAircraftType ?? 'All Aircraft',
                    items: _aircraftTypes,
                    onChanged: (value) {
                      setState(() {
                        _selectedAircraftType = value == 'All Aircraft' ? null : value;
                      });
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
                  onPressed: _applyFilters,
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

  Widget _buildStopOption(int? stops, String label) {
    final isSelected = _selectedStops == stops;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedStops = stops;
          });
        },
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

  void _resetFilters() {
    setState(() {
      _selectedAirline = null;
      _selectedStops = null;
      _selectedAircraftType = null;
      _priceRange = const RangeValues(0, 1000);
    });
  }

  void _applyFilters() {
    // Check if any filters are actually set
    final hasFilters = _selectedAirline != null ||
        _selectedStops != null ||
        _selectedAircraftType != null ||
        _priceRange.start > 0 ||
        _priceRange.end < 1000;

    if (hasFilters) {
      ref.read(flightFilterStateProvider.notifier).updateFilter(
            FilterModel(
              airline: _selectedAirline,
              stops: _selectedStops,
              aircraftType: _selectedAircraftType,
              priceMin: _priceRange.start > 0 ? _priceRange.start : null,
              priceMax: _priceRange.end < 1000 ? _priceRange.end : null,
            ),
          );
    } else {
      ref.read(flightFilterStateProvider.notifier).clearFilters();
    }

    Navigator.pop(context);
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/features/flight_search/presentation/providers/flight_search_providers.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/filter_model.dart';

class ActiveFilterChips extends ConsumerWidget {
  const ActiveFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(flightFilterStateProvider);

    if (filters == null || !_hasActiveFilters(filters)) {
      return const SizedBox.shrink();
    }

    final chips = _buildFilterChips(filters, ref);

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Active filters',
                style: AppTypography.caption.copyWith(
                  color: AppColors.mediumGray,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  ref.read(flightFilterStateProvider.notifier).clearFilters();
                },
                child: Text(
                  'Clear all',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips,
          ),
        ],
      ),
    );
  }

  bool _hasActiveFilters(FilterModel filters) {
    return filters.airline != null ||
        filters.stops != null ||
        filters.aircraftType != null ||
        (filters.priceMin != null && filters.priceMin! > 0) ||
        (filters.priceMax != null && filters.priceMax! < 1000);
  }

  List<Widget> _buildFilterChips(FilterModel filters, WidgetRef ref) {
    final chips = <Widget>[];

    // Airline filter
    if (filters.airline != null) {
      chips.add(_ActiveFilterChip(
        label: filters.airline!,
        onRemove: () {
          _updateFilter(ref, filters.copyWith(airline: null));
        },
      ));
    }

    // Stops filter
    if (filters.stops != null) {
      final stopsLabel = filters.stops == 0
          ? 'Direct only'
          : filters.stops == 1
              ? '1 Stop'
              : '${filters.stops}+ Stops';
      chips.add(_ActiveFilterChip(
        label: stopsLabel,
        onRemove: () {
          _updateFilter(ref, filters.copyWith(stops: null));
        },
      ));
    }

    // Price range filter
    if ((filters.priceMin != null && filters.priceMin! > 0) ||
        (filters.priceMax != null && filters.priceMax! < 1000)) {
      final minPrice = filters.priceMin?.toInt() ?? 0;
      final maxPrice = filters.priceMax?.toInt() ?? 1000;
      chips.add(_ActiveFilterChip(
        label: '\$$minPrice - \$$maxPrice',
        onRemove: () {
          _updateFilter(ref, filters.copyWith(priceMin: null, priceMax: null));
        },
      ));
    }

    // Aircraft type filter
    if (filters.aircraftType != null) {
      chips.add(_ActiveFilterChip(
        label: filters.aircraftType!,
        onRemove: () {
          _updateFilter(ref, filters.copyWith(aircraftType: null));
        },
      ));
    }

    return chips;
  }

  void _updateFilter(WidgetRef ref, FilterModel updatedFilter) {
    // Check if all filters are cleared
    if (updatedFilter.airline == null &&
        updatedFilter.stops == null &&
        updatedFilter.aircraftType == null &&
        (updatedFilter.priceMin == null || updatedFilter.priceMin == 0) &&
        (updatedFilter.priceMax == null || updatedFilter.priceMax == 1000)) {
      ref.read(flightFilterStateProvider.notifier).clearFilters();
    } else {
      ref.read(flightFilterStateProvider.notifier).updateFilter(updatedFilter);
    }
  }
}

class _ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveFilterChip({
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
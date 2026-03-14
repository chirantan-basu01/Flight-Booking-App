import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/features/flight_search/presentation/providers/flight_search_providers.dart';

class FilterChips extends ConsumerWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(flightSortStateProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Sort Options
          _SortChip(
            label: 'Lowest to Highest',
            isSelected: currentSort == 'price_asc',
            onTap: () {
              ref.read(flightSortStateProvider.notifier).updateSort('price_asc');
            },
          ),
          const SizedBox(width: 10),
          _SortChip(
            label: 'Preferred airlines',
            isSelected: currentSort == 'preferred',
            onTap: () {
              ref.read(flightSortStateProvider.notifier).updateSort('preferred');
            },
          ),
          const SizedBox(width: 10),
          _SortChip(
            label: 'Flight time',
            isSelected: currentSort == 'duration_asc',
            onTap: () {
              ref.read(flightSortStateProvider.notifier).updateSort('duration_asc');
            },
          ),
          const SizedBox(width: 10),
          _SortChip(
            label: 'Earliest departure',
            isSelected: currentSort == 'departure_asc',
            onTap: () {
              ref.read(flightSortStateProvider.notifier).updateSort('departure_asc');
            },
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          label,
          style: AppTypography.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
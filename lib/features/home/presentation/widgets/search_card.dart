import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/features/home/presentation/providers/search_state_provider.dart';
import 'package:flight_booking_app/features/home/presentation/widgets/airport_selector_bottom_sheet.dart';
import 'package:flight_booking_app/routes/app_router.dart';

class SearchCard extends ConsumerWidget {
  const SearchCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchStateNotifierProvider);
    final searchNotifier = ref.read(searchStateNotifierProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // From Field
                _buildAirportField(
                  label: 'From',
                  value: searchState.fromAirport != null
                      ? '${searchState.fromAirport!.city} (${searchState.fromAirport!.airportCode})'
                      : 'Select departure',
                  hasValue: searchState.fromAirport != null,
                  onTap: () => _showAirportSelector(
                    context,
                    ref,
                    isDeparture: true,
                  ),
                ),

                const SizedBox(height: 16),

                // Divider
                Container(
                  height: 1,
                  color: const Color(0xFFEEEEEE),
                ),

                const SizedBox(height: 16),

                // To Field
                _buildAirportField(
                  label: 'To',
                  value: searchState.toAirport != null
                      ? '${searchState.toAirport!.city} (${searchState.toAirport!.airportCode})'
                      : 'Select arrival',
                  hasValue: searchState.toAirport != null,
                  onTap: () => _showAirportSelector(
                    context,
                    ref,
                    isDeparture: false,
                  ),
                ),

                const SizedBox(height: 16),

                // Divider
                Container(
                  height: 1,
                  color: const Color(0xFFEEEEEE),
                ),

                const SizedBox(height: 16),

                // Departure Date and Amount Row
                Row(
                  children: [
                    // Departure Date
                    Expanded(
                      child: _buildDateField(
                        label: 'Departure',
                        date: searchState.departureDate,
                        onTap: () => _showDatePicker(context, ref),
                      ),
                    ),

                    // Amount
                    Expanded(
                      child: _buildPassengersField(
                        label: 'Amount',
                        count: searchState.passengers,
                        onTap: () => _showPassengerSelector(context, ref),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Search Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: searchNotifier.isValid
                        ? () => const FlightResultsRoute().go(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      disabledBackgroundColor: const Color(0xFF333333),
                      foregroundColor: AppColors.white,
                      shape: const StadiumBorder(), // Pill shape
                      elevation: 0,
                    ),
                    child: Text(
                      'Search flights',
                      style: AppTypography.button.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Swap Button - positioned on the right, overlapping the first divider
          Positioned(
            right: 20,
            top: 58, // Position to overlap between From and To
            child: GestureDetector(
              onTap: searchNotifier.swapAirports,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.swap_vert,
                    color: AppColors.black,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirportField({
    required String label,
    required String value,
    required bool hasValue,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontSize: 13,
              color: AppColors.mediumGray,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.heading2.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: hasValue ? AppColors.black : AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    final dateText = date != null
        ? DateFormat('EEE, d MMM').format(date)
        : 'Select date';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontSize: 13,
              color: AppColors.mediumGray,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                dateText,
                style: AppTypography.heading2.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: date != null ? AppColors.black : AppColors.mediumGray,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: date != null ? AppColors.black : AppColors.mediumGray,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPassengersField({
    required String label,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontSize: 13,
              color: AppColors.mediumGray,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '$count ${count == 1 ? 'person' : 'people'}',
                style: AppTypography.heading2.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 24,
                color: AppColors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAirportSelector(
    BuildContext context,
    WidgetRef ref, {
    required bool isDeparture,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AirportSelectorBottomSheet(
        isDeparture: isDeparture,
        onSelected: (airport) {
          final notifier = ref.read(searchStateNotifierProvider.notifier);
          if (isDeparture) {
            notifier.updateFromAirport(airport);
          } else {
            notifier.updateToAirport(airport);
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(searchStateNotifierProvider.notifier).updateDepartureDate(picked);
    }
  }

  void _showPassengerSelector(BuildContext context, WidgetRef ref) {
    final currentCount = ref.read(searchStateNotifierProvider).passengers;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PassengerSelectorSheet(
        currentCount: currentCount,
        onSelected: (count) {
          ref.read(searchStateNotifierProvider.notifier).updatePassengers(count);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _PassengerSelectorSheet extends StatefulWidget {
  final int currentCount;
  final ValueChanged<int> onSelected;

  const _PassengerSelectorSheet({
    required this.currentCount,
    required this.onSelected,
  });

  @override
  State<_PassengerSelectorSheet> createState() => _PassengerSelectorSheetState();
}

class _PassengerSelectorSheetState extends State<_PassengerSelectorSheet> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.currentCount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Select Passengers',
            style: AppTypography.heading2,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCounterButton(
                icon: Icons.remove,
                onPressed: _count > 1 ? () => setState(() => _count--) : null,
              ),
              const SizedBox(width: 40),
              Text(
                '$_count',
                style: AppTypography.heading1.copyWith(fontSize: 48),
              ),
              const SizedBox(width: 40),
              _buildCounterButton(
                icon: Icons.add,
                onPressed: _count < 9 ? () => setState(() => _count++) : null,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$_count ${_count == 1 ? 'person' : 'people'}',
            style: AppTypography.body,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => widget.onSelected(_count),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text('Confirm', style: AppTypography.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.primaryBlue : AppColors.lightGray,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isEnabled ? AppColors.white : AppColors.mediumGray,
          size: 24,
        ),
      ),
    );
  }
}
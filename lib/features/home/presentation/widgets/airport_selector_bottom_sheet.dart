import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/features/home/domain/models/airport_model.dart';
import 'package:flight_booking_app/features/home/presentation/providers/home_providers.dart';

class AirportSelectorBottomSheet extends ConsumerStatefulWidget {
  final bool isDeparture;
  final ValueChanged<AirportModel> onSelected;

  const AirportSelectorBottomSheet({
    super.key,
    required this.isDeparture,
    required this.onSelected,
  });

  @override
  ConsumerState<AirportSelectorBottomSheet> createState() =>
      _AirportSelectorBottomSheetState();
}

class _AirportSelectorBottomSheetState
    extends ConsumerState<AirportSelectorBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Clear search query when opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(airportSearchQueryProvider.notifier).clear();
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    final searchQuery = ref.read(airportSearchQueryProvider);
    final search = searchQuery.isEmpty ? null : searchQuery;

    if (widget.isDeparture) {
      ref
          .read(paginatedDepartureAirportsProvider(search: search).notifier)
          .loadMore(search: search);
    } else {
      ref
          .read(paginatedArrivalAirportsProvider(search: search).notifier)
          .loadMore(search: search);
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        ref.read(airportSearchQueryProvider.notifier).updateQuery(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(airportSearchQueryProvider);
    final search = searchQuery.isEmpty ? null : searchQuery;

    final airportsAsync = widget.isDeparture
        ? ref.watch(paginatedDepartureAirportsProvider(search: search))
        : ref.watch(paginatedArrivalAirportsProvider(search: search));

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

          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              widget.isDeparture ? 'Select Departure' : 'Select Arrival',
              style: AppTypography.heading2,
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: AppTypography.body.copyWith(color: AppColors.black),
              decoration: InputDecoration(
                hintText: 'Search airport or city...',
                hintStyle: AppTypography.body.copyWith(color: AppColors.mediumGray),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.mediumGray,
                ),
                filled: true,
                fillColor: AppColors.lightGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Airport List
          Expanded(
            child: airportsAsync.when(
              data: (paginatedState) {
                final airports = paginatedState.airports;

                if (airports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.flight_outlined,
                          size: 48,
                          color: AppColors.mediumGray,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No airports found',
                          style: AppTypography.body,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: airports.length + (paginatedState.hasMore ? 1 : 0),
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    color: AppColors.borderGray,
                  ),
                  itemBuilder: (context, index) {
                    // Show shimmer loading at the bottom
                    if (index >= airports.length) {
                      return _buildAirportShimmer();
                    }

                    final airport = airports[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.flight,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      title: Text(
                        airport.city ?? 'Unknown',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      subtitle: Text(
                        airport.airportCode ?? '',
                        style: AppTypography.caption,
                      ),
                      trailing: airport.flightCount != null
                          ? Text(
                              '${airport.flightCount} flights',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.primaryBlue,
                              ),
                            )
                          : null,
                      onTap: () => widget.onSelected(airport),
                    );
                  },
                );
              },
              loading: () => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 6,
                itemBuilder: (context, index) => _buildAirportShimmer(),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Failed to load airports',
                      style: AppTypography.body,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        if (widget.isDeparture) {
                          ref.invalidate(paginatedDepartureAirportsProvider(search: search));
                        } else {
                          ref.invalidate(paginatedArrivalAirportsProvider(search: search));
                        }
                      },
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

  Widget _buildAirportShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Icon placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            // Text placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            // Flight count placeholder
            Container(
              width: 60,
              height: 12,
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
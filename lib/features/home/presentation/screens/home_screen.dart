import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/features/home/presentation/widgets/search_card.dart';
import 'package:flight_booking_app/features/home/presentation/widgets/saved_trip_card.dart';
import 'package:flight_booking_app/features/home/presentation/providers/home_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Prefetch airports data for offline availability after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefetchAirports();
    });
  }

  void _prefetchAirports() {
    // Trigger airport data fetch in background to populate cache
    // These will be available offline once fetched
    ref.read(paginatedDepartureAirportsProvider(search: null).future);
    ref.read(paginatedArrivalAirportsProvider(search: null).future);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6366F1), // Deep indigo at top
              Color(0xFF818CF8), // Medium indigo
              Color(0xFFA5B4FC), // Light purple
              Color(0xFFD4DBFD), // Very light lavender
              Color(0xFFEEF0FB), // Almost white
              Color(0xFFF5F5F7), // Light gray at bottom
            ],
            stops: [0.0, 0.06, 0.12, 0.20, 0.30, 0.45],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and avatar
                _buildHeader(),

                // Search Card
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SearchCard(),
                ),

                const SizedBox(height: 28),

                // Saved Trips Section
                _buildSavedTripsSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Plan your trip',
              style: AppTypography.heading1.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
          // Profile Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedTripsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saved trips',
                style: AppTypography.heading2.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'See more',
                  style: AppTypography.body.copyWith(
                    color: AppColors.darkGray,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Horizontal scrollable saved trips
        SizedBox(
          height: 195,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: const [
              SavedTripCard(
                airlineName: 'Citilink',
                airlineLogo: 'https://airhex.com/images/airline-logos/citilink.png',
                departureTime: '07:47',
                departureCode: 'CGK',
                departureCity: 'Jakarta',
                arrivalTime: '14:30',
                arrivalCode: 'NRT',
                arrivalCity: 'Tokyo',
                duration: '7h 15m',
                date: 'Jan 20, 2025',
              ),
              SizedBox(width: 12),
              SavedTripCard(
                airlineName: 'Garuda',
                airlineLogo: 'https://airhex.com/images/airline-logos/garuda-indonesia.png',
                departureTime: '09:15',
                departureCode: 'CGK',
                departureCity: 'Jakarta',
                arrivalTime: '16:45',
                arrivalCode: 'NRT',
                arrivalCity: 'Tokyo',
                duration: '7h 30m',
                date: 'Jan 22, 2025',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                isActive: true,
              ),
              _buildNavItem(
                icon: Icons.flight,
                isActive: false,
              ),
              _buildNavItem(
                icon: Icons.grid_view_rounded,
                isActive: false,
              ),
              _buildNavItem(
                icon: Icons.person_outline_rounded,
                isActive: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? AppColors.primaryBlue : AppColors.mediumGray,
          size: 26,
        ),
        if (isActive) ...[
          const SizedBox(height: 4),
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}

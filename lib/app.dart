import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flight_booking_app/core/theme/app_theme.dart';
import 'package:flight_booking_app/routes/app_router.dart';
import 'package:flight_booking_app/shared/widgets/network_aware_widget.dart';

class FlightBookingApp extends ConsumerWidget {
  const FlightBookingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Flight Booking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      builder: (context, child) {
        return NetworkAwareWidget(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flight_booking_app/features/home/presentation/screens/home_screen.dart';
import 'package:flight_booking_app/features/flight_search/presentation/screens/flight_results_screen.dart';
import 'package:flight_booking_app/features/flight_details/presentation/screens/flight_details_screen.dart';

part 'app_router.g.dart';

// Route paths
abstract class AppRoutes {
  static const String home = '/';
  static const String flightResults = '/flight-results';
  static const String flightDetails = '/flight-details/:flightId';

  static String flightDetailsPath(int flightId) => '/flight-details/$flightId';
}

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<FlightResultsRoute>(
      path: 'flight-results',
    ),
    TypedGoRoute<FlightDetailsRoute>(
      path: 'flight-details/:flightId',
    ),
  ],
)
@immutable
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

@immutable
class FlightResultsRoute extends GoRouteData {
  const FlightResultsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FlightResultsScreen();
  }
}

@immutable
class FlightDetailsRoute extends GoRouteData {
  const FlightDetailsRoute({required this.flightId});

  final int flightId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FlightDetailsScreen(flightId: flightId);
  }
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: $appRoutes,
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.message ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
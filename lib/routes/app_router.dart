import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flight_booking_app/features/home/presentation/screens/home_screen.dart';
import 'package:flight_booking_app/features/flight_search/presentation/screens/flight_results_screen.dart';
import 'package:flight_booking_app/features/flight_details/presentation/screens/flight_details_screen.dart';

part 'app_router.g.dart';

// Custom page transition
CustomTransitionPage<T> buildPageWithSlideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Slide from right with fade
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;

      var slideTween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );
      var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(slideTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}

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
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildPageWithSlideTransition(
      context: context,
      state: state,
      child: const FlightResultsScreen(),
    );
  }
}

@immutable
class FlightDetailsRoute extends GoRouteData {
  const FlightDetailsRoute({required this.flightId});

  final int flightId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildPageWithSlideTransition(
      context: context,
      state: state,
      child: FlightDetailsScreen(flightId: flightId),
    );
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
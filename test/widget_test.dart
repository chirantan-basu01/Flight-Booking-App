import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flight_booking_app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: FlightBookingApp(),
      ),
    );

    // Verify that the app renders without errors.
    expect(find.text('Plan your trip'), findsOneWidget);
  });
}
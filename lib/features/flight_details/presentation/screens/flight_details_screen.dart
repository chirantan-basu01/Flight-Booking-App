import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlightDetailsScreen extends ConsumerWidget {
  final int flightId;

  const FlightDetailsScreen({
    super.key,
    required this.flightId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement Flight Details Screen UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your flight details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flight Details Screen',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Flight ID: $flightId',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
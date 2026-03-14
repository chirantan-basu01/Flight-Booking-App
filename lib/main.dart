import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flight_booking_app/app.dart';
import 'package:flight_booking_app/core/constants/api_constants.dart';
import 'package:flight_booking_app/core/network/cache_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for caching
  await Hive.initFlutter();

  // Initialize API response cache
  await CacheConfig.initialize();

  // Set environment based on build flavor
  const String environment =
      String.fromEnvironment('ENV', defaultValue: 'dev');

  switch (environment) {
    case 'prod':
      ApiConstants.setEnvironment(Environment.prod);
      break;
    case 'staging':
      ApiConstants.setEnvironment(Environment.staging);
      break;
    default:
      ApiConstants.setEnvironment(Environment.dev);
  }

  runApp(
    const ProviderScope(
      child: FlightBookingApp(),
    ),
  );
}
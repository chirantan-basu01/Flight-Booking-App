import 'package:flight_booking_app/core/network/dio_provider.dart';
import 'package:flight_booking_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flight_booking_app/features/home/data/datasources/home_mock_datasource.dart';
import 'package:flight_booking_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:flight_booking_app/features/home/domain/models/airport_model.dart';
import 'package:flight_booking_app/features/home/domain/repositories/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_providers.g.dart';

/// Set to true to use mock data (when API is unavailable)
/// Set to false to use real API
const bool useMockData = true;

@riverpod
HomeRemoteDataSource homeRemoteDataSource(HomeRemoteDataSourceRef ref) {
  if (useMockData) {
    return HomeMockDataSource();
  }
  return HomeRemoteDataSourceImpl(ref.watch(dioProvider));
}

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepositoryImpl(ref.watch(homeRemoteDataSourceProvider));
}

@riverpod
Future<List<AirportModel>> departureAirports(
  DepartureAirportsRef ref, {
  String? search,
}) async {
  final repository = ref.watch(homeRepositoryProvider);
  final result = await repository.getDepartureAirports(search: search);
  return result.fold(
    (failure) => throw Exception(failure.localizedMessage),
    (airports) => airports,
  );
}

@riverpod
Future<List<AirportModel>> arrivalAirports(
  ArrivalAirportsRef ref, {
  String? search,
}) async {
  final repository = ref.watch(homeRepositoryProvider);
  final result = await repository.getArrivalAirports(search: search);
  return result.fold(
    (failure) => throw Exception(failure.localizedMessage),
    (airports) => airports,
  );
}
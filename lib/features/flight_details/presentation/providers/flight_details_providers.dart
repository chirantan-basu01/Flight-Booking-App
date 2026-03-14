import 'package:flight_booking_app/core/network/dio_provider.dart';
import 'package:flight_booking_app/features/flight_details/data/datasources/flight_details_remote_datasource.dart';
import 'package:flight_booking_app/features/flight_details/data/datasources/flight_details_mock_datasource.dart';
import 'package:flight_booking_app/features/flight_details/data/repositories/flight_details_repository_impl.dart';
import 'package:flight_booking_app/features/flight_details/domain/models/flight_detail_response_model.dart';
import 'package:flight_booking_app/features/flight_details/domain/repositories/flight_details_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flight_details_providers.g.dart';

/// Set to true to use mock data (when API is unavailable)
/// Set to false to use real API
const bool useMockData = false;

@riverpod
FlightDetailsRemoteDataSource flightDetailsRemoteDataSource(
  FlightDetailsRemoteDataSourceRef ref,
) {
  if (useMockData) {
    return FlightDetailsMockDataSource();
  }
  return FlightDetailsRemoteDataSourceImpl(ref.watch(dioProvider));
}

@riverpod
FlightDetailsRepository flightDetailsRepository(FlightDetailsRepositoryRef ref) {
  return FlightDetailsRepositoryImpl(
    ref.watch(flightDetailsRemoteDataSourceProvider),
  );
}

@riverpod
Future<FlightDetailResponseModel> flightDetails(
  FlightDetailsRef ref,
  int flightId,
) async {
  final repository = ref.watch(flightDetailsRepositoryProvider);
  final result = await repository.getFlightDetails(flightId);

  return result.fold(
    (failure) => throw Exception(failure.localizedMessage),
    (response) => response,
  );
}
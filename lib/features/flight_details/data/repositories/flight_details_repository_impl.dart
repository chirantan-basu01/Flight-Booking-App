import 'package:dartz/dartz.dart';
import 'package:flight_booking_app/core/error/failures.dart';
import 'package:flight_booking_app/features/flight_details/data/datasources/flight_details_remote_datasource.dart';
import 'package:flight_booking_app/features/flight_details/domain/models/flight_detail_response_model.dart';
import 'package:flight_booking_app/features/flight_details/domain/repositories/flight_details_repository.dart';

class FlightDetailsRepositoryImpl implements FlightDetailsRepository {
  final FlightDetailsRemoteDataSource _remoteDataSource;

  FlightDetailsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, FlightDetailResponseModel>> getFlightDetails(int flightId) async {
    try {
      final response = await _remoteDataSource.getFlightDetails(flightId);

      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message ?? 'Failed to get flight details'));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
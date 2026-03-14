import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_booking_app/core/error/failures.dart';
import 'package:flight_booking_app/features/flight_search/data/datasources/flight_search_remote_datasource.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/flight_search_response.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/search_params_model.dart';
import 'package:flight_booking_app/features/flight_search/domain/repositories/flight_search_repository.dart';

class FlightSearchRepositoryImpl implements FlightSearchRepository {
  final FlightSearchRemoteDataSource _remoteDataSource;

  FlightSearchRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, FlightSearchResponse>> searchFlights(
    SearchParamsModel params,
  ) async {
    try {
      final response = await _remoteDataSource.searchFlights(params);

      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(
          ServerFailure(message: response.message ?? 'Failed to search flights'),
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left(TimeoutFailure());
      }
      if (e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure());
      }
      return Left(
        ServerFailure(
          message: e.message ?? 'Server error occurred',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
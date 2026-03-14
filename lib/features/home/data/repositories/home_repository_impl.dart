import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_booking_app/core/error/failures.dart';
import 'package:flight_booking_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flight_booking_app/features/home/domain/models/airport_model.dart';
import 'package:flight_booking_app/features/home/domain/models/airline_model.dart';
import 'package:flight_booking_app/features/home/domain/models/aircraft_type_model.dart';
import 'package:flight_booking_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<AirportModel>>> getDepartureAirports({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _remoteDataSource.getDepartureAirports(
        search: search,
        page: page,
        limit: limit,
      );

      if (response.isSuccess && response.data != null) {
        return Right(response.data!.airports ?? []);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AirportModel>>> getArrivalAirports({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _remoteDataSource.getArrivalAirports(
        search: search,
        page: page,
        limit: limit,
      );

      if (response.isSuccess && response.data != null) {
        return Right(response.data!.airports ?? []);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AirlineModel>>> getAirlines({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _remoteDataSource.getAirlines(
        search: search,
        page: page,
        limit: limit,
      );

      if (response.isSuccess && response.data != null) {
        return Right(response.data!.airlines ?? []);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AircraftTypeModel>>> getAircraftTypes({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _remoteDataSource.getAircraftTypes(
        search: search,
        page: page,
        limit: limit,
      );

      if (response.isSuccess && response.data != null) {
        return Right(response.data!.aircraftTypes ?? []);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Failure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure();
      case DioExceptionType.connectionError:
        return NetworkFailure();
      case DioExceptionType.badResponse:
        return ServerFailure(
          statusCode: e.response?.statusCode,
          message: e.response?.data?['message']?.toString(),
        );
      default:
        return UnknownFailure(message: e.message);
    }
  }
}
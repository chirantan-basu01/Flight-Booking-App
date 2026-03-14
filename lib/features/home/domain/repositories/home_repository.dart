import 'package:dartz/dartz.dart';
import 'package:flight_booking_app/core/error/failures.dart';
import 'package:flight_booking_app/features/home/domain/models/airport_model.dart';
import 'package:flight_booking_app/features/home/domain/models/airline_model.dart';
import 'package:flight_booking_app/features/home/domain/models/aircraft_type_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<AirportModel>>> getDepartureAirports({
    String? search,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<AirportModel>>> getArrivalAirports({
    String? search,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<AirlineModel>>> getAirlines({
    String? search,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<AircraftTypeModel>>> getAircraftTypes({
    String? search,
    int page = 1,
    int limit = 10,
  });
}
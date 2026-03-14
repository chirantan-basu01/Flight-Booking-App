import 'package:dartz/dartz.dart';
import 'package:flight_booking_app/core/error/failures.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/flight_search_response.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/search_params_model.dart';

abstract class FlightSearchRepository {
  Future<Either<Failure, FlightSearchResponse>> searchFlights(
    SearchParamsModel params,
  );
}
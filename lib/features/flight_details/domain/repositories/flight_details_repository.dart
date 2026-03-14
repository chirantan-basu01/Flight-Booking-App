import 'package:dartz/dartz.dart';
import 'package:flight_booking_app/core/error/failures.dart';
import 'package:flight_booking_app/features/flight_details/domain/models/flight_detail_response_model.dart';

abstract class FlightDetailsRepository {
  Future<Either<Failure, FlightDetailResponseModel>> getFlightDetails(int flightId);
}
import 'package:dio/dio.dart';
import 'package:flight_booking_app/core/constants/api_constants.dart';
import 'package:flight_booking_app/core/network/api_response.dart';
import 'package:flight_booking_app/features/flight_details/domain/models/flight_detail_response_model.dart';

abstract class FlightDetailsRemoteDataSource {
  Future<ApiResponse<FlightDetailResponseModel>> getFlightDetails(int flightId);
}

class FlightDetailsRemoteDataSourceImpl implements FlightDetailsRemoteDataSource {
  final Dio _dio;

  FlightDetailsRemoteDataSourceImpl(this._dio);

  @override
  Future<ApiResponse<FlightDetailResponseModel>> getFlightDetails(int flightId) async {
    final response = await _dio.post(
      ApiConstants.flight,
      data: {'id': flightId},
    );

    return ApiResponse<FlightDetailResponseModel>.fromJson(
      response.data,
      (json) => FlightDetailResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
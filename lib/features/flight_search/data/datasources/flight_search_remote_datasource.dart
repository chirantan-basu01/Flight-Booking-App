import 'package:dio/dio.dart';
import 'package:flight_booking_app/core/constants/api_constants.dart';
import 'package:flight_booking_app/core/network/api_response.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/flight_search_response.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/search_params_model.dart';

abstract class FlightSearchRemoteDataSource {
  Future<ApiResponse<FlightSearchResponse>> searchFlights(
    SearchParamsModel params,
  );
}

class FlightSearchRemoteDataSourceImpl implements FlightSearchRemoteDataSource {
  final Dio _dio;

  FlightSearchRemoteDataSourceImpl(this._dio);

  @override
  Future<ApiResponse<FlightSearchResponse>> searchFlights(
    SearchParamsModel params,
  ) async {
    final response = await _dio.post(
      ApiConstants.search,
      data: params.toJson(),
    );

    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => FlightSearchResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
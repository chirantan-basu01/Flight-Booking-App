import 'package:dio/dio.dart';
import 'package:flight_booking_app/core/constants/api_constants.dart';
import 'package:flight_booking_app/core/network/api_response.dart';
import 'package:flight_booking_app/features/home/domain/models/airport_list_response.dart';
import 'package:flight_booking_app/features/home/domain/models/airline_list_response.dart';
import 'package:flight_booking_app/features/home/domain/models/aircraft_type_list_response.dart';

abstract class HomeRemoteDataSource {
  Future<ApiResponse<AirportListResponse>> getDepartureAirports({
    String? search,
    int page = 1,
    int limit = 10,
  });

  Future<ApiResponse<AirportListResponse>> getArrivalAirports({
    String? search,
    int page = 1,
    int limit = 10,
  });

  Future<ApiResponse<AirlineListResponse>> getAirlines({
    String? search,
    int page = 1,
    int limit = 10,
  });

  Future<ApiResponse<AircraftTypeListResponse>> getAircraftTypes({
    String? search,
    int page = 1,
    int limit = 10,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSourceImpl(this._dio);

  @override
  Future<ApiResponse<AirportListResponse>> getDepartureAirports({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.post(
      ApiConstants.airportsFrom,
      data: {
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'limit': limit,
      },
    );

    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => AirportListResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<AirportListResponse>> getArrivalAirports({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.post(
      ApiConstants.airportsTo,
      data: {
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'limit': limit,
      },
    );

    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => AirportListResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<AirlineListResponse>> getAirlines({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.post(
      ApiConstants.airlines,
      data: {
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'limit': limit,
      },
    );

    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => AirlineListResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<AircraftTypeListResponse>> getAircraftTypes({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.post(
      ApiConstants.aircraftTypes,
      data: {
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'limit': limit,
      },
    );

    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => AircraftTypeListResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
import 'package:flight_booking_app/core/network/api_response.dart';
import 'package:flight_booking_app/features/home/domain/models/airport_list_response.dart';
import 'package:flight_booking_app/features/home/domain/models/airline_list_response.dart';
import 'package:flight_booking_app/features/home/domain/models/aircraft_type_list_response.dart';
import 'package:flight_booking_app/features/home/domain/models/airport_model.dart';
import 'package:flight_booking_app/features/home/domain/models/airline_model.dart';
import 'package:flight_booking_app/features/home/domain/models/aircraft_type_model.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/pagination_model.dart';
import 'package:flight_booking_app/features/home/data/datasources/home_remote_datasource.dart';

/// Mock data source for development when API is unavailable
class HomeMockDataSource implements HomeRemoteDataSource {
  // Mock departure airports
  static final List<AirportModel> _departureAirports = [
    const AirportModel(
      airportCode: 'CGK',
      city: 'Jakarta',
      flightCount: 15,
    ),
    const AirportModel(
      airportCode: 'SUB',
      city: 'Surabaya',
      flightCount: 8,
    ),
    const AirportModel(
      airportCode: 'DPS',
      city: 'Bali',
      flightCount: 12,
    ),
    const AirportModel(
      airportCode: 'JOG',
      city: 'Yogyakarta',
      flightCount: 6,
    ),
    const AirportModel(
      airportCode: 'BDO',
      city: 'Bandung',
      flightCount: 5,
    ),
    const AirportModel(
      airportCode: 'SIN',
      city: 'Singapore',
      flightCount: 20,
    ),
    const AirportModel(
      airportCode: 'KUL',
      city: 'Kuala Lumpur',
      flightCount: 10,
    ),
  ];

  // Mock arrival airports
  static final List<AirportModel> _arrivalAirports = [
    const AirportModel(
      airportCode: 'NRT',
      city: 'Tokyo',
      flightCount: 10,
    ),
    const AirportModel(
      airportCode: 'HND',
      city: 'Tokyo Haneda',
      flightCount: 8,
    ),
    const AirportModel(
      airportCode: 'ICN',
      city: 'Seoul',
      flightCount: 12,
    ),
    const AirportModel(
      airportCode: 'HKG',
      city: 'Hong Kong',
      flightCount: 9,
    ),
    const AirportModel(
      airportCode: 'SYD',
      city: 'Sydney',
      flightCount: 6,
    ),
    const AirportModel(
      airportCode: 'MEL',
      city: 'Melbourne',
      flightCount: 5,
    ),
    const AirportModel(
      airportCode: 'LHR',
      city: 'London',
      flightCount: 4,
    ),
    const AirportModel(
      airportCode: 'CDG',
      city: 'Paris',
      flightCount: 3,
    ),
    const AirportModel(
      airportCode: 'DXB',
      city: 'Dubai',
      flightCount: 7,
    ),
  ];

  // Mock airlines
  static final List<AirlineModel> _airlines = [
    const AirlineModel(airline: 'AirAsia'),
    const AirlineModel(airline: 'Bird Indonesia Airline'),
    const AirlineModel(airline: 'Catty Airline'),
    const AirlineModel(airline: 'Citilink Airline'),
    const AirlineModel(airline: 'Garuda Indonesia'),
    const AirlineModel(airline: 'Japan Airlines'),
    const AirlineModel(airline: 'Lion Air'),
    const AirlineModel(airline: 'Malaysia Airlines'),
    const AirlineModel(airline: 'Singapore Airlines'),
    const AirlineModel(airline: 'Thai Airways'),
  ];

  // Mock aircraft types
  static final List<AircraftTypeModel> _aircraftTypes = [
    const AircraftTypeModel(aircraft: 'Airbus A320'),
    const AircraftTypeModel(aircraft: 'Airbus A350'),
    const AircraftTypeModel(aircraft: 'Boeing 737'),
    const AircraftTypeModel(aircraft: 'Boeing 777'),
    const AircraftTypeModel(aircraft: 'Boeing 787'),
  ];

  @override
  Future<ApiResponse<AirportListResponse>> getDepartureAirports({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    List<AirportModel> filteredAirports = _departureAirports;

    // Apply search filter
    if (search != null && search.isNotEmpty) {
      final searchLower = search.toLowerCase();
      filteredAirports = _departureAirports.where((airport) {
        return (airport.city?.toLowerCase().contains(searchLower) ?? false) ||
            (airport.airportCode?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
    }

    // Apply pagination
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    final paginatedAirports = filteredAirports.length > startIndex
        ? filteredAirports.sublist(
            startIndex,
            endIndex > filteredAirports.length
                ? filteredAirports.length
                : endIndex,
          )
        : <AirportModel>[];

    final totalPages = (filteredAirports.length / limit).ceil();

    return ApiResponse(
      status: 'success',
      message: 'Departure airports retrieved',
      data: AirportListResponse(
        airports: paginatedAirports,
        search: search,
        pagination: PaginationModel(
          total: filteredAirports.length,
          totalPages: totalPages,
          currentPage: page,
          limit: limit,
          hasNextPage: page < totalPages,
          hasPrevPage: page > 1,
        ),
      ),
    );
  }

  @override
  Future<ApiResponse<AirportListResponse>> getArrivalAirports({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    List<AirportModel> filteredAirports = _arrivalAirports;

    // Apply search filter
    if (search != null && search.isNotEmpty) {
      final searchLower = search.toLowerCase();
      filteredAirports = _arrivalAirports.where((airport) {
        return (airport.city?.toLowerCase().contains(searchLower) ?? false) ||
            (airport.airportCode?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
    }

    // Apply pagination
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    final paginatedAirports = filteredAirports.length > startIndex
        ? filteredAirports.sublist(
            startIndex,
            endIndex > filteredAirports.length
                ? filteredAirports.length
                : endIndex,
          )
        : <AirportModel>[];

    final totalPages = (filteredAirports.length / limit).ceil();

    return ApiResponse(
      status: 'success',
      message: 'Arrival airports retrieved',
      data: AirportListResponse(
        airports: paginatedAirports,
        search: search,
        pagination: PaginationModel(
          total: filteredAirports.length,
          totalPages: totalPages,
          currentPage: page,
          limit: limit,
          hasNextPage: page < totalPages,
          hasPrevPage: page > 1,
        ),
      ),
    );
  }

  @override
  Future<ApiResponse<AirlineListResponse>> getAirlines({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    List<AirlineModel> filteredAirlines = _airlines;

    // Apply search filter
    if (search != null && search.isNotEmpty) {
      final searchLower = search.toLowerCase();
      filteredAirlines = _airlines.where((airline) {
        return airline.airline?.toLowerCase().contains(searchLower) ?? false;
      }).toList();
    }

    // Apply pagination
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    final paginatedAirlines = filteredAirlines.length > startIndex
        ? filteredAirlines.sublist(
            startIndex,
            endIndex > filteredAirlines.length
                ? filteredAirlines.length
                : endIndex,
          )
        : <AirlineModel>[];

    final totalPages = (filteredAirlines.length / limit).ceil();

    return ApiResponse(
      status: 'success',
      message: 'Airlines retrieved',
      data: AirlineListResponse(
        airlines: paginatedAirlines,
        search: search,
        pagination: PaginationModel(
          total: filteredAirlines.length,
          totalPages: totalPages,
          currentPage: page,
          limit: limit,
          hasNextPage: page < totalPages,
          hasPrevPage: page > 1,
        ),
      ),
    );
  }

  @override
  Future<ApiResponse<AircraftTypeListResponse>> getAircraftTypes({
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    List<AircraftTypeModel> filteredTypes = _aircraftTypes;

    // Apply search filter
    if (search != null && search.isNotEmpty) {
      final searchLower = search.toLowerCase();
      filteredTypes = _aircraftTypes.where((type) {
        return type.aircraft?.toLowerCase().contains(searchLower) ?? false;
      }).toList();
    }

    // Apply pagination
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    final paginatedTypes = filteredTypes.length > startIndex
        ? filteredTypes.sublist(
            startIndex,
            endIndex > filteredTypes.length ? filteredTypes.length : endIndex,
          )
        : <AircraftTypeModel>[];

    final totalPages = (filteredTypes.length / limit).ceil();

    return ApiResponse(
      status: 'success',
      message: 'Aircraft types retrieved',
      data: AircraftTypeListResponse(
        aircraftTypes: paginatedTypes,
        search: search,
        pagination: PaginationModel(
          total: filteredTypes.length,
          totalPages: totalPages,
          currentPage: page,
          limit: limit,
          hasNextPage: page < totalPages,
          hasPrevPage: page > 1,
        ),
      ),
    );
  }
}
import 'package:flight_booking_app/core/network/api_response.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/flight_search_response.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/flight_model.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/departure_arrival_model.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/price_model.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/pagination_model.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/search_params_model.dart';
import 'package:flight_booking_app/features/flight_search/data/datasources/flight_search_remote_datasource.dart';

/// Mock data source for development when API is unavailable
class FlightSearchMockDataSource implements FlightSearchRemoteDataSource {
  // Mock flights data
  static final List<FlightModel> _mockFlights = [
    const FlightModel(
      id: 1,
      airlineName: 'Garuda Indonesia',
      airlineLogo: 'https://airhex.com/images/airline-logos/garuda-indonesia.png',
      flightNumber: 'GA101',
      departure: DepartureArrivalModel(
        time: '09:15',
        airportCode: 'CGK',
        city: 'Jakarta',
      ),
      arrival: DepartureArrivalModel(
        time: '16:45',
        airportCode: 'NRT',
        city: 'Tokyo',
      ),
      duration: '7h 30m',
      price: PriceModel(amount: 450, currency: 'USD'),
      aircraftType: 'Boeing 777',
      stops: 0,
    ),
    const FlightModel(
      id: 2,
      airlineName: 'Singapore Airlines',
      airlineLogo: 'https://airhex.com/images/airline-logos/singapore-airlines.png',
      flightNumber: 'SQ635',
      departure: DepartureArrivalModel(
        time: '11:30',
        airportCode: 'CGK',
        city: 'Jakarta',
      ),
      arrival: DepartureArrivalModel(
        time: '19:45',
        airportCode: 'NRT',
        city: 'Tokyo',
      ),
      duration: '8h 15m',
      price: PriceModel(amount: 520, currency: 'USD'),
      aircraftType: 'Airbus A350',
      stops: 1,
    ),
    const FlightModel(
      id: 3,
      airlineName: 'AirAsia',
      airlineLogo: 'https://airhex.com/images/airline-logos/airasia.png',
      flightNumber: 'AK123',
      departure: DepartureArrivalModel(
        time: '06:00',
        airportCode: 'CGK',
        city: 'Jakarta',
      ),
      arrival: DepartureArrivalModel(
        time: '14:30',
        airportCode: 'NRT',
        city: 'Tokyo',
      ),
      duration: '8h 30m',
      price: PriceModel(amount: 280, currency: 'USD'),
      aircraftType: 'Airbus A320',
      stops: 1,
    ),
    const FlightModel(
      id: 4,
      airlineName: 'Japan Airlines',
      airlineLogo: 'https://airhex.com/images/airline-logos/japan-airlines.png',
      flightNumber: 'JL726',
      departure: DepartureArrivalModel(
        time: '14:00',
        airportCode: 'CGK',
        city: 'Jakarta',
      ),
      arrival: DepartureArrivalModel(
        time: '21:30',
        airportCode: 'NRT',
        city: 'Tokyo',
      ),
      duration: '7h 30m',
      price: PriceModel(amount: 680, currency: 'USD'),
      aircraftType: 'Boeing 787',
      stops: 0,
    ),
    const FlightModel(
      id: 5,
      airlineName: 'Citilink',
      airlineLogo: 'https://airhex.com/images/airline-logos/citilink.png',
      flightNumber: 'QG801',
      departure: DepartureArrivalModel(
        time: '07:45',
        airportCode: 'CGK',
        city: 'Jakarta',
      ),
      arrival: DepartureArrivalModel(
        time: '16:00',
        airportCode: 'NRT',
        city: 'Tokyo',
      ),
      duration: '8h 15m',
      price: PriceModel(amount: 320, currency: 'USD'),
      aircraftType: 'Airbus A320',
      stops: 1,
    ),
    const FlightModel(
      id: 6,
      airlineName: 'Lion Air',
      airlineLogo: 'https://airhex.com/images/airline-logos/lion-air.png',
      flightNumber: 'JT201',
      departure: DepartureArrivalModel(
        time: '22:00',
        airportCode: 'CGK',
        city: 'Jakarta',
      ),
      arrival: DepartureArrivalModel(
        time: '06:30',
        airportCode: 'NRT',
        city: 'Tokyo',
      ),
      duration: '8h 30m',
      price: PriceModel(amount: 310, currency: 'USD'),
      aircraftType: 'Boeing 737',
      stops: 1,
    ),
    const FlightModel(
      id: 7,
      airlineName: 'Thai Airways',
      airlineLogo: 'https://airhex.com/images/airline-logos/thai-airways.png',
      flightNumber: 'TG432',
      departure: DepartureArrivalModel(
        time: '10:30',
        airportCode: 'CGK',
        city: 'Jakarta',
      ),
      arrival: DepartureArrivalModel(
        time: '18:45',
        airportCode: 'NRT',
        city: 'Tokyo',
      ),
      duration: '8h 15m',
      price: PriceModel(amount: 550, currency: 'USD'),
      aircraftType: 'Airbus A350',
      stops: 1,
    ),
    const FlightModel(
      id: 8,
      airlineName: 'Malaysia Airlines',
      airlineLogo: 'https://airhex.com/images/airline-logos/malaysia-airlines.png',
      flightNumber: 'MH715',
      departure: DepartureArrivalModel(
        time: '13:15',
        airportCode: 'CGK',
        city: 'Jakarta',
      ),
      arrival: DepartureArrivalModel(
        time: '21:00',
        airportCode: 'NRT',
        city: 'Tokyo',
      ),
      duration: '7h 45m',
      price: PriceModel(amount: 480, currency: 'USD'),
      aircraftType: 'Boeing 777',
      stops: 1,
    ),
  ];

  @override
  Future<ApiResponse<FlightSearchResponse>> searchFlights(
    SearchParamsModel params,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    List<FlightModel> filteredFlights = List.from(_mockFlights);

    // Apply filters
    if (params.filters != null) {
      final filters = params.filters!;

      // Filter by airline
      if (filters.airline != null && filters.airline!.isNotEmpty) {
        filteredFlights = filteredFlights
            .where((f) => f.airlineName?.toLowerCase().contains(
                  filters.airline!.toLowerCase(),
                ) ?? false)
            .toList();
      }

      // Filter by price range
      if (filters.priceMin != null && filters.priceMin! > 0) {
        filteredFlights = filteredFlights
            .where((f) => (f.price?.amount ?? 0) >= filters.priceMin!)
            .toList();
      }
      if (filters.priceMax != null && filters.priceMax! > 0) {
        filteredFlights = filteredFlights
            .where((f) => (f.price?.amount ?? 0) <= filters.priceMax!)
            .toList();
      }

      // Filter by stops
      if (filters.stops != null) {
        filteredFlights = filteredFlights
            .where((f) => f.stops == filters.stops)
            .toList();
      }

      // Filter by aircraft type
      if (filters.aircraftType != null && filters.aircraftType!.isNotEmpty) {
        filteredFlights = filteredFlights
            .where((f) => f.aircraftType?.toLowerCase().contains(
                  filters.aircraftType!.toLowerCase(),
                ) ?? false)
            .toList();
      }
    }

    // Apply sorting
    switch (params.sortBy) {
      case 'price_asc':
        filteredFlights.sort(
          (a, b) => (a.price?.amount ?? 0).compareTo(b.price?.amount ?? 0),
        );
        break;
      case 'price_desc':
        filteredFlights.sort(
          (a, b) => (b.price?.amount ?? 0).compareTo(a.price?.amount ?? 0),
        );
        break;
      case 'duration_asc':
        filteredFlights.sort(
          (a, b) => (a.duration ?? '').compareTo(b.duration ?? ''),
        );
        break;
      case 'departure_asc':
        filteredFlights.sort(
          (a, b) => (a.departure?.time ?? '').compareTo(b.departure?.time ?? ''),
        );
        break;
    }

    // Apply pagination
    final startIndex = (params.page - 1) * params.limit;
    final endIndex = startIndex + params.limit;
    final paginatedFlights = filteredFlights.length > startIndex
        ? filteredFlights.sublist(
            startIndex,
            endIndex > filteredFlights.length
                ? filteredFlights.length
                : endIndex,
          )
        : <FlightModel>[];

    final totalPages = (filteredFlights.length / params.limit).ceil();

    return ApiResponse(
      status: 'success',
      message: 'Flights found',
      data: FlightSearchResponse(
        searchParams: params,
        flights: paginatedFlights,
        pagination: PaginationModel(
          total: filteredFlights.length,
          totalPages: totalPages == 0 ? 1 : totalPages,
          currentPage: params.page,
          limit: params.limit,
          hasNextPage: params.page < totalPages,
          hasPrevPage: params.page > 1,
        ),
      ),
    );
  }
}
import 'package:flight_booking_app/core/network/api_response.dart';
import 'package:flight_booking_app/features/flight_details/data/datasources/flight_details_remote_datasource.dart';
import 'package:flight_booking_app/features/flight_details/domain/models/flight_detail_response_model.dart';
import 'package:flight_booking_app/features/flight_details/domain/models/flight_detail_model.dart';
import 'package:flight_booking_app/features/flight_details/domain/models/passenger_model.dart';
import 'package:flight_booking_app/features/flight_details/domain/models/booking_info_model.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/departure_arrival_model.dart';

class FlightDetailsMockDataSource implements FlightDetailsRemoteDataSource {
  @override
  Future<ApiResponse<FlightDetailResponseModel>> getFlightDetails(int flightId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final mockData = FlightDetailResponseModel(
      flightDetails: FlightDetailModel(
        id: flightId,
        airlineName: 'Garuda Indonesia',
        airlineLogo: 'https://airhex.com/images/airline-logos/garuda-indonesia.png',
        flightId: 'ID324200$flightId',
        flightNumber: 'GA${100 + flightId}',
        departure: const DepartureArrivalModel(
          time: '06:00',
          airportCode: 'CGK',
          city: 'Jakarta',
        ),
        arrival: const DepartureArrivalModel(
          time: '14:30',
          airportCode: 'NRT',
          city: 'Tokyo',
        ),
        duration: '7h 30m',
        aircraftType: 'Boeing 777',
        stops: 0,
        terminal: '2B',
        gate: '22',
        flightClass: 'Economy',
      ),
      passengers: [
        const PassengerModel(
          passengerNumber: 1,
          title: 'Mr.',
          name: 'John Doe',
          seat: '3A',
          profilePicture: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop',
        ),
      ],
      bookingInfo: BookingInfoModel(
        totalPassengers: 1,
        bookingReference: 'BK0000000$flightId',
        bookingDate: '2025-01-20',
        barcode: _generateMockBarcodeSvg(),
      ),
    );

    return ApiResponse<FlightDetailResponseModel>(
      status: 'success',
      message: 'Flight details retrieved',
      data: mockData,
    );
  }

  String _generateMockBarcodeSvg() {
    // Generate a simple barcode-like SVG
    final buffer = StringBuffer();
    buffer.write('<svg xmlns="http://www.w3.org/2000/svg" width="200" height="50" viewBox="0 0 200 50">');
    buffer.write('<rect width="200" height="50" fill="white"/>');

    // Generate random barcode bars
    double x = 5;
    final bars = [2, 1, 3, 1, 2, 3, 1, 2, 1, 3, 2, 1, 3, 1, 2, 1, 3, 2, 1, 2, 3, 1, 2, 1, 3, 1, 2, 3, 1, 2];
    for (int i = 0; i < bars.length; i++) {
      final width = bars[i].toDouble();
      if (i % 2 == 0) {
        buffer.write('<rect x="$x" y="5" width="$width" height="40" fill="black"/>');
      }
      x += width + 1;
    }

    buffer.write('</svg>');
    return buffer.toString();
  }
}
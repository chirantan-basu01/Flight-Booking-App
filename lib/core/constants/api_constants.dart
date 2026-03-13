enum Environment { dev, staging, prod }

class ApiConstants {
  static Environment _environment = Environment.dev;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static String get baseUrl {
    switch (_environment) {
      case Environment.dev:
        return 'https://flight.wigian.in/flight_api.php';
      case Environment.staging:
        return 'https://staging-flight.wigian.in/flight_api.php';
      case Environment.prod:
        return 'https://flight.wigian.in/flight_api.php';
    }
  }

  // API Endpoints
  static const String search = '/search';
  static const String list = '/list';
  static const String flight = '/flight';
  static const String airportsFrom = '/airports/from';
  static const String airportsTo = '/airports/to';
  static const String airlines = '/airlines';
  static const String aircraftTypes = '/aircraft-types';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Pagination defaults
  static const int defaultPage = 1;
  static const int defaultLimit = 10;

  // Sort options
  static const String sortPriceAsc = 'price_asc';
  static const String sortPriceDesc = 'price_desc';
  static const String sortDurationAsc = 'duration_asc';
  static const String sortDepartureAsc = 'departure_asc';
}
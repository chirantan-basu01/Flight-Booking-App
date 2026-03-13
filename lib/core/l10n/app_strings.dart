class AppStrings {
  AppStrings._();

  static const Map<String, String> _strings = {
    // Error Messages
    'error_no_internet': 'No internet connection. Please check your network.',
    'error_server': 'Server error. Please try again later.',
    'error_timeout': 'Request timed out. Please try again.',
    'error_unknown': 'Something went wrong. Please try again.',
    'error_not_found': 'Resource not found.',
    'error_bad_request': 'Invalid request. Please check your input.',
    'error_rate_limit': 'Too many requests. Please wait a moment.',
    'error_cache': 'Cache error occurred.',

    // Empty States
    'empty_flights': 'No flights found',
    'empty_flights_subtitle': 'Try adjusting your search criteria',
    'empty_airports': 'No airports found',

    // Actions
    'retry': 'Retry',
    'clear_all': 'Clear all',
    'apply': 'Apply',
    'reset': 'Reset',
    'search': 'Search',
    'cancel': 'Cancel',

    // Home Screen
    'plan_your_trip': 'Plan your trip',
    'from': 'From',
    'to': 'To',
    'departure_date': 'Departure date',
    'passengers': 'Passengers',
    'search_flights': 'Search flights',
    'saved_trips': 'Saved trips',
    'see_more': 'See more',

    // Flight Results Screen
    'flight_result': 'Flight result',
    'select_flight': 'Select flight',
    'per_person': 'per person',
    'direct': 'Direct',
    'stop': 'stop',
    'stops': 'stops',

    // Flight Details Screen
    'your_flight_details': 'Your flight details',
    'passengers_info': 'Passengers Info',
    'passenger': 'PASSENGER',
    'terminal': 'Terminal',
    'gate': 'Gate',
    'class': 'Class',
    'seat': 'Seat',
    'download_save_pass': 'Download & Save pass',

    // Filters
    'filters': 'Filters',
    'sort_by': 'Sort by',
    'lowest_to_highest': 'Lowest to Highest',
    'highest_to_lowest': 'Highest to Lowest',
    'shortest_duration': 'Shortest Duration',
    'earliest_departure': 'Earliest Departure',
    'preferred_airlines': 'Preferred airlines',
    'price_range': 'Price range',
    'number_of_stops': 'Number of stops',
    'aircraft_type': 'Aircraft type',
  };

  static String get(String key) {
    return _strings[key] ?? key;
  }
}
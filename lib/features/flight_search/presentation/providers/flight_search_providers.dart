import 'package:flight_booking_app/core/network/dio_provider.dart';
import 'package:flight_booking_app/features/flight_search/data/datasources/flight_search_remote_datasource.dart';
import 'package:flight_booking_app/features/flight_search/data/datasources/flight_search_mock_datasource.dart';
import 'package:flight_booking_app/features/flight_search/data/repositories/flight_search_repository_impl.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/flight_model.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/filter_model.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/search_params_model.dart';
import 'package:flight_booking_app/features/flight_search/domain/repositories/flight_search_repository.dart';
import 'package:flight_booking_app/features/home/presentation/providers/search_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flight_search_providers.g.dart';

/// Set to true to use mock data (when API is unavailable)
/// Set to false to use real API
const bool useMockData = true;

@riverpod
FlightSearchRemoteDataSource flightSearchRemoteDataSource(
  FlightSearchRemoteDataSourceRef ref,
) {
  if (useMockData) {
    return FlightSearchMockDataSource();
  }
  return FlightSearchRemoteDataSourceImpl(ref.watch(dioProvider));
}

@riverpod
FlightSearchRepository flightSearchRepository(FlightSearchRepositoryRef ref) {
  return FlightSearchRepositoryImpl(
    ref.watch(flightSearchRemoteDataSourceProvider),
  );
}

/// Current sort option for flight search
@riverpod
class FlightSortState extends _$FlightSortState {
  @override
  String build() => 'price_asc';

  void updateSort(String sortBy) {
    state = sortBy;
  }
}

/// Current filter state for flight search
@riverpod
class FlightFilterState extends _$FlightFilterState {
  @override
  FilterModel? build() => null;

  void updateFilter(FilterModel? filter) {
    state = filter;
  }

  void clearFilters() {
    state = null;
  }
}

/// Search flights based on search state, sort, and filters
@riverpod
Future<List<FlightModel>> flightSearchResults(
  FlightSearchResultsRef ref,
) async {
  final searchState = ref.watch(searchStateNotifierProvider);
  final sortBy = ref.watch(flightSortStateProvider);
  final filters = ref.watch(flightFilterStateProvider);

  // Build search params from search state
  final params = SearchParamsModel(
    from: searchState.fromAirport?.airportCode,
    to: searchState.toAirport?.airportCode,
    passengers: searchState.passengers,
    sortBy: sortBy,
    filters: filters,
    page: 1,
    limit: 20,
  );

  final repository = ref.watch(flightSearchRepositoryProvider);
  final result = await repository.searchFlights(params);

  return result.fold(
    (failure) => throw Exception(failure.localizedMessage),
    (response) => response.flights ?? [],
  );
}
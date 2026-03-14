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
const bool useMockData = false;

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

/// Temporary filter state for bottom sheet editing
@riverpod
class FilterBottomSheetState extends _$FilterBottomSheetState {
  @override
  FilterBottomSheetData build() => const FilterBottomSheetData();

  void setAirline(String? airline) {
    state = state.copyWith(selectedAirline: airline);
  }

  void setStops(int? stops) {
    state = state.copyWith(selectedStops: stops);
  }

  void setAircraftType(String? aircraftType) {
    state = state.copyWith(selectedAircraftType: aircraftType);
  }

  void setPriceRange(double min, double max) {
    state = state.copyWith(priceMin: min, priceMax: max);
  }

  void reset() {
    state = const FilterBottomSheetData();
  }

  void loadFromFilter(FilterModel? filter) {
    if (filter != null) {
      state = FilterBottomSheetData(
        selectedAirline: filter.airline,
        selectedStops: filter.stops,
        selectedAircraftType: filter.aircraftType,
        priceMin: filter.priceMin ?? 0,
        priceMax: filter.priceMax ?? 1000,
      );
    } else {
      state = const FilterBottomSheetData();
    }
  }
}

/// Data class for filter bottom sheet state
class FilterBottomSheetData {
  final String? selectedAirline;
  final int? selectedStops;
  final String? selectedAircraftType;
  final double priceMin;
  final double priceMax;

  const FilterBottomSheetData({
    this.selectedAirline,
    this.selectedStops,
    this.selectedAircraftType,
    this.priceMin = 0,
    this.priceMax = 1000,
  });

  FilterBottomSheetData copyWith({
    String? selectedAirline,
    int? selectedStops,
    String? selectedAircraftType,
    double? priceMin,
    double? priceMax,
  }) {
    return FilterBottomSheetData(
      selectedAirline: selectedAirline ?? this.selectedAirline,
      selectedStops: selectedStops ?? this.selectedStops,
      selectedAircraftType: selectedAircraftType ?? this.selectedAircraftType,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
    );
  }

  bool get hasFilters =>
      selectedAirline != null ||
      selectedStops != null ||
      selectedAircraftType != null ||
      priceMin > 0 ||
      priceMax < 1000;
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
import 'package:flutter/foundation.dart';
import 'package:flight_booking_app/core/network/dio_provider.dart';
import 'package:flight_booking_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flight_booking_app/features/home/data/datasources/home_mock_datasource.dart';
import 'package:flight_booking_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:flight_booking_app/features/home/domain/models/airport_model.dart';
import 'package:flight_booking_app/features/home/domain/repositories/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_providers.g.dart';

/// Set to true to use mock data (when API is unavailable)
/// Set to false to use real API
const bool useMockData = false;

@riverpod
HomeRemoteDataSource homeRemoteDataSource(HomeRemoteDataSourceRef ref) {
  if (useMockData) {
    return HomeMockDataSource();
  }
  return HomeRemoteDataSourceImpl(ref.watch(dioProvider));
}

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepositoryImpl(ref.watch(homeRemoteDataSourceProvider));
}

@riverpod
Future<List<AirportModel>> departureAirports(
  DepartureAirportsRef ref, {
  String? search,
}) async {
  final repository = ref.watch(homeRepositoryProvider);
  final result = await repository.getDepartureAirports(search: search);
  return result.fold(
    (failure) => throw Exception(failure.localizedMessage),
    (airports) => airports,
  );
}

@riverpod
Future<List<AirportModel>> arrivalAirports(
  ArrivalAirportsRef ref, {
  String? search,
}) async {
  final repository = ref.watch(homeRepositoryProvider);
  final result = await repository.getArrivalAirports(search: search);
  return result.fold(
    (failure) => throw Exception(failure.localizedMessage),
    (airports) => airports,
  );
}

/// Paginated state for airports
class PaginatedAirportsState {
  final List<AirportModel> airports;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final String? error;

  const PaginatedAirportsState({
    this.airports = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.error,
  });

  PaginatedAirportsState copyWith({
    List<AirportModel>? airports,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    String? error,
  }) {
    return PaginatedAirportsState(
      airports: airports ?? this.airports,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
    );
  }
}

/// Paginated departure airports provider
@riverpod
class PaginatedDepartureAirports extends _$PaginatedDepartureAirports {
  @override
  Future<PaginatedAirportsState> build({String? search}) async {
    return _loadPage(1, search: search);
  }

  Future<PaginatedAirportsState> _loadPage(int page, {String? search}) async {
    final repository = ref.watch(homeRepositoryProvider);
    final result = await repository.getDepartureAirports(
      search: search,
      page: page,
      limit: 10,
    );

    return result.fold(
      (failure) => throw Exception(failure.localizedMessage),
      (airports) => PaginatedAirportsState(
        airports: airports,
        currentPage: page,
        hasMore: airports.length >= 10,
        isLoadingMore: false,
      ),
    );
  }

  Future<void> loadMore({String? search}) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.isLoadingMore || !currentState.hasMore) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final repository = ref.read(homeRepositoryProvider);
      final nextPage = currentState.currentPage + 1;
      final result = await repository.getDepartureAirports(
        search: search,
        page: nextPage,
        limit: 10,
      );

      result.fold(
        (failure) {
          state = AsyncValue.data(currentState.copyWith(
            isLoadingMore: false,
            error: failure.localizedMessage,
          ));
        },
        (newAirports) {
          state = AsyncValue.data(currentState.copyWith(
            airports: [...currentState.airports, ...newAirports],
            currentPage: nextPage,
            hasMore: newAirports.length >= 10,
            isLoadingMore: false,
          ));
        },
      );
    } catch (e) {
      state = AsyncValue.data(currentState.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      ));
    }
  }
}

/// Paginated arrival airports provider
@riverpod
class PaginatedArrivalAirports extends _$PaginatedArrivalAirports {
  @override
  Future<PaginatedAirportsState> build({String? search}) async {
    return _loadPage(1, search: search);
  }

  Future<PaginatedAirportsState> _loadPage(int page, {String? search}) async {
    final repository = ref.watch(homeRepositoryProvider);
    final result = await repository.getArrivalAirports(
      search: search,
      page: page,
      limit: 10,
    );

    return result.fold(
      (failure) => throw Exception(failure.localizedMessage),
      (airports) => PaginatedAirportsState(
        airports: airports,
        currentPage: page,
        hasMore: airports.length >= 10,
        isLoadingMore: false,
      ),
    );
  }

  Future<void> loadMore({String? search}) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.isLoadingMore || !currentState.hasMore) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final repository = ref.read(homeRepositoryProvider);
      final nextPage = currentState.currentPage + 1;
      final result = await repository.getArrivalAirports(
        search: search,
        page: nextPage,
        limit: 10,
      );

      result.fold(
        (failure) {
          state = AsyncValue.data(currentState.copyWith(
            isLoadingMore: false,
            error: failure.localizedMessage,
          ));
        },
        (newAirports) {
          state = AsyncValue.data(currentState.copyWith(
            airports: [...currentState.airports, ...newAirports],
            currentPage: nextPage,
            hasMore: newAirports.length >= 10,
            isLoadingMore: false,
          ));
        },
      );
    } catch (e) {
      state = AsyncValue.data(currentState.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      ));
    }
  }
}

/// Airport search query state
@riverpod
class AirportSearchQuery extends _$AirportSearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

/// Passenger selector count state (for bottom sheet)
@riverpod
class PassengerSelectorCount extends _$PassengerSelectorCount {
  @override
  int build() => 1;

  void setCount(int count) {
    state = count;
  }

  void increment() {
    if (state < 9) state = state + 1;
  }

  void decrement() {
    if (state > 1) state = state - 1;
  }
}
import 'package:flight_booking_app/features/home/domain/models/airport_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_state_provider.freezed.dart';
part 'search_state_provider.g.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    AirportModel? fromAirport,
    AirportModel? toAirport,
    DateTime? departureDate,
    @Default(1) int passengers,
  }) = _SearchState;
}

@riverpod
class SearchStateNotifier extends _$SearchStateNotifier {
  @override
  SearchState build() => const SearchState();

  void updateFromAirport(AirportModel? airport) {
    state = state.copyWith(fromAirport: airport);
  }

  void updateToAirport(AirportModel? airport) {
    state = state.copyWith(toAirport: airport);
  }

  void updateDepartureDate(DateTime? date) {
    state = state.copyWith(departureDate: date);
  }

  void updatePassengers(int count) {
    state = state.copyWith(passengers: count);
  }

  void swapAirports() {
    state = state.copyWith(
      fromAirport: state.toAirport,
      toAirport: state.fromAirport,
    );
  }

  void reset() {
    state = const SearchState();
  }

  bool get isValid =>
      state.fromAirport != null &&
      state.toAirport != null &&
      state.departureDate != null &&
      state.passengers > 0;
}

/// Provider for debounced airport search
@riverpod
class DepartureSearchQuery extends _$DepartureSearchQuery {
  @override
  String build() => '';

  void update(String query) {
    state = query;
  }
}

@riverpod
class ArrivalSearchQuery extends _$ArrivalSearchQuery {
  @override
  String build() => '';

  void update(String query) {
    state = query;
  }
}
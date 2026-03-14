import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flight_booking_app/features/home/domain/models/aircraft_type_model.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/pagination_model.dart';

part 'aircraft_type_list_response.freezed.dart';
part 'aircraft_type_list_response.g.dart';

/// Response data for /aircraft-types endpoint
@freezed
class AircraftTypeListResponse with _$AircraftTypeListResponse {
  const factory AircraftTypeListResponse({
    @JsonKey(name: 'aircraft_types') List<AircraftTypeModel>? aircraftTypes,
    @JsonKey(name: 'search') String? search,
    @JsonKey(name: 'pagination') PaginationModel? pagination,
  }) = _AircraftTypeListResponse;

  factory AircraftTypeListResponse.fromJson(Map<String, dynamic> json) =>
      _$AircraftTypeListResponseFromJson(json);
}
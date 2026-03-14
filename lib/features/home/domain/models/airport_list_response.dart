import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flight_booking_app/features/home/domain/models/airport_model.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/pagination_model.dart';

part 'airport_list_response.freezed.dart';
part 'airport_list_response.g.dart';

/// Response data for /airports/from and /airports/to endpoints
@freezed
class AirportListResponse with _$AirportListResponse {
  const factory AirportListResponse({
    @JsonKey(name: 'airports') List<AirportModel>? airports,
    @JsonKey(name: 'search') String? search,
    @JsonKey(name: 'pagination') PaginationModel? pagination,
  }) = _AirportListResponse;

  factory AirportListResponse.fromJson(Map<String, dynamic> json) =>
      _$AirportListResponseFromJson(json);
}
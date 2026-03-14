import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flight_booking_app/features/home/domain/models/airline_model.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/pagination_model.dart';

part 'airline_list_response.freezed.dart';
part 'airline_list_response.g.dart';

/// Response data for /airlines endpoint
@freezed
class AirlineListResponse with _$AirlineListResponse {
  const factory AirlineListResponse({
    @JsonKey(name: 'airlines') List<AirlineModel>? airlines,
    @JsonKey(name: 'search') String? search,
    @JsonKey(name: 'pagination') PaginationModel? pagination,
  }) = _AirlineListResponse;

  factory AirlineListResponse.fromJson(Map<String, dynamic> json) =>
      _$AirlineListResponseFromJson(json);
}
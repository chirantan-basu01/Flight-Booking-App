import 'package:freezed_annotation/freezed_annotation.dart';
import 'flight_model.dart';
import 'search_params_model.dart';
import 'pagination_model.dart';

part 'flight_search_response.freezed.dart';
part 'flight_search_response.g.dart';

/// Response data for /search endpoint
@freezed
class FlightSearchResponse with _$FlightSearchResponse {
  const factory FlightSearchResponse({
    @JsonKey(name: 'search_params') SearchParamsModel? searchParams,
    @JsonKey(name: 'flights') List<FlightModel>? flights,
    @JsonKey(name: 'pagination') PaginationModel? pagination,
  }) = _FlightSearchResponse;

  factory FlightSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$FlightSearchResponseFromJson(json);
}
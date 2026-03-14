import 'package:freezed_annotation/freezed_annotation.dart';
import 'filter_model.dart';

part 'search_params_model.freezed.dart';
part 'search_params_model.g.dart';

/// Custom converter to handle filters that can be [] or {} from API
FilterModel? _filtersFromJson(dynamic json) {
  if (json == null) return null;
  if (json is List) return null; // Empty array means no filters
  if (json is Map<String, dynamic>) {
    // Check if it's an empty map or has actual values
    if (json.isEmpty) return null;
    return FilterModel.fromJson(json);
  }
  return null;
}

Map<String, dynamic>? _filtersToJson(FilterModel? filters) {
  return filters?.toJson();
}

@freezed
class SearchParamsModel with _$SearchParamsModel {
  const factory SearchParamsModel({
    @JsonKey(name: 'from') String? from,
    @JsonKey(name: 'to') String? to,
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'passengers') @Default(1) int passengers,
    @JsonKey(name: 'sort_by') @Default('price_asc') String sortBy,
    @JsonKey(name: 'filters', fromJson: _filtersFromJson, toJson: _filtersToJson) FilterModel? filters,
    @JsonKey(name: 'page') @Default(1) int page,
    @JsonKey(name: 'limit') @Default(10) int limit,
  }) = _SearchParamsModel;

  factory SearchParamsModel.fromJson(Map<String, dynamic> json) =>
      _$SearchParamsModelFromJson(json);
}
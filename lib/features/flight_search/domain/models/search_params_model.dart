import 'package:freezed_annotation/freezed_annotation.dart';
import 'filter_model.dart';

part 'search_params_model.freezed.dart';
part 'search_params_model.g.dart';

@freezed
class SearchParamsModel with _$SearchParamsModel {
  const factory SearchParamsModel({
    @JsonKey(name: 'from') String? from,
    @JsonKey(name: 'to') String? to,
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'passengers') @Default(1) int passengers,
    @JsonKey(name: 'sort_by') @Default('price_asc') String sortBy,
    @JsonKey(name: 'filters') FilterModel? filters,
    @JsonKey(name: 'page') @Default(1) int page,
    @JsonKey(name: 'limit') @Default(10) int limit,
  }) = _SearchParamsModel;

  factory SearchParamsModel.fromJson(Map<String, dynamic> json) =>
      _$SearchParamsModelFromJson(json);
}
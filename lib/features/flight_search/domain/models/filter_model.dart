import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_model.freezed.dart';
part 'filter_model.g.dart';

@freezed
class FilterModel with _$FilterModel {
  const factory FilterModel({
    @JsonKey(name: 'airline') String? airline,
    @JsonKey(name: 'price_min') double? priceMin,
    @JsonKey(name: 'price_max') double? priceMax,
    @JsonKey(name: 'stops') int? stops,
    @JsonKey(name: 'aircraft_type') String? aircraftType,
  }) = _FilterModel;

  factory FilterModel.fromJson(Map<String, dynamic> json) =>
      _$FilterModelFromJson(json);
}
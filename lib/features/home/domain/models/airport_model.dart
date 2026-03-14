import 'package:freezed_annotation/freezed_annotation.dart';

part 'airport_model.freezed.dart';
part 'airport_model.g.dart';

@freezed
class AirportModel with _$AirportModel {
  const factory AirportModel({
    @JsonKey(name: 'airport_code') String? airportCode,
    @JsonKey(name: 'city') String? city,
    @JsonKey(name: 'flight_count') int? flightCount,
  }) = _AirportModel;

  factory AirportModel.fromJson(Map<String, dynamic> json) =>
      _$AirportModelFromJson(json);
}
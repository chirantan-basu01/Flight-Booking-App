import 'package:freezed_annotation/freezed_annotation.dart';

part 'departure_arrival_model.freezed.dart';
part 'departure_arrival_model.g.dart';

@freezed
class DepartureArrivalModel with _$DepartureArrivalModel {
  const factory DepartureArrivalModel({
    @JsonKey(name: 'time') String? time,
    @JsonKey(name: 'airport_code') String? airportCode,
    @JsonKey(name: 'city') String? city,
  }) = _DepartureArrivalModel;

  factory DepartureArrivalModel.fromJson(Map<String, dynamic> json) =>
      _$DepartureArrivalModelFromJson(json);
}
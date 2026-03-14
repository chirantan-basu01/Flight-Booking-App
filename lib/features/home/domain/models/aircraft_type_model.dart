import 'package:freezed_annotation/freezed_annotation.dart';

part 'aircraft_type_model.freezed.dart';
part 'aircraft_type_model.g.dart';

@freezed
class AircraftTypeModel with _$AircraftTypeModel {
  const factory AircraftTypeModel({
    @JsonKey(name: 'aircraft') String? aircraft,
  }) = _AircraftTypeModel;

  factory AircraftTypeModel.fromJson(Map<String, dynamic> json) =>
      _$AircraftTypeModelFromJson(json);
}
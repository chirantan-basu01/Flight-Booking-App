import 'package:freezed_annotation/freezed_annotation.dart';
import 'departure_arrival_model.dart';
import 'price_model.dart';

part 'flight_model.freezed.dart';
part 'flight_model.g.dart';

@freezed
class FlightModel with _$FlightModel {
  const factory FlightModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'airline_name') String? airlineName,
    @JsonKey(name: 'airline_logo') String? airlineLogo,
    @JsonKey(name: 'flight_number') String? flightNumber,
    @JsonKey(name: 'departure') DepartureArrivalModel? departure,
    @JsonKey(name: 'arrival') DepartureArrivalModel? arrival,
    @JsonKey(name: 'duration') String? duration,
    @JsonKey(name: 'price') PriceModel? price,
    @JsonKey(name: 'aircraft_type') String? aircraftType,
    @JsonKey(name: 'stops') int? stops,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _FlightModel;

  factory FlightModel.fromJson(Map<String, dynamic> json) =>
      _$FlightModelFromJson(json);
}
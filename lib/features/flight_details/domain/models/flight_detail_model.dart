import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flight_booking_app/features/flight_search/domain/models/departure_arrival_model.dart';

part 'flight_detail_model.freezed.dart';
part 'flight_detail_model.g.dart';

@freezed
class FlightDetailModel with _$FlightDetailModel {
  const factory FlightDetailModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'airline_name') String? airlineName,
    @JsonKey(name: 'airline_logo') String? airlineLogo,
    @JsonKey(name: 'flight_id') String? flightId,
    @JsonKey(name: 'flight_number') String? flightNumber,
    @JsonKey(name: 'departure') DepartureArrivalModel? departure,
    @JsonKey(name: 'arrival') DepartureArrivalModel? arrival,
    @JsonKey(name: 'duration') String? duration,
    @JsonKey(name: 'aircraft_type') String? aircraftType,
    @JsonKey(name: 'stops') int? stops,
    @JsonKey(name: 'terminal') String? terminal,
    @JsonKey(name: 'gate') String? gate,
    @JsonKey(name: 'class') String? flightClass,
  }) = _FlightDetailModel;

  factory FlightDetailModel.fromJson(Map<String, dynamic> json) =>
      _$FlightDetailModelFromJson(json);
}
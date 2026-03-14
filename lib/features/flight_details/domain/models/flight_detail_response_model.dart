import 'package:freezed_annotation/freezed_annotation.dart';
import 'flight_detail_model.dart';
import 'passenger_model.dart';
import 'booking_info_model.dart';

part 'flight_detail_response_model.freezed.dart';
part 'flight_detail_response_model.g.dart';

@freezed
class FlightDetailResponseModel with _$FlightDetailResponseModel {
  const factory FlightDetailResponseModel({
    @JsonKey(name: 'flight_details') FlightDetailModel? flightDetails,
    @JsonKey(name: 'passengers') List<PassengerModel>? passengers,
    @JsonKey(name: 'booking_info') BookingInfoModel? bookingInfo,
  }) = _FlightDetailResponseModel;

  factory FlightDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FlightDetailResponseModelFromJson(json);
}
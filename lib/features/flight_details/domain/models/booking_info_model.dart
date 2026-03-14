import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_info_model.freezed.dart';
part 'booking_info_model.g.dart';

@freezed
class BookingInfoModel with _$BookingInfoModel {
  const factory BookingInfoModel({
    @JsonKey(name: 'total_passengers') int? totalPassengers,
    @JsonKey(name: 'booking_reference') String? bookingReference,
    @JsonKey(name: 'booking_date') String? bookingDate,
    @JsonKey(name: 'barcode') String? barcode,
  }) = _BookingInfoModel;

  factory BookingInfoModel.fromJson(Map<String, dynamic> json) =>
      _$BookingInfoModelFromJson(json);
}
import 'package:freezed_annotation/freezed_annotation.dart';

part 'passenger_model.freezed.dart';
part 'passenger_model.g.dart';

@freezed
class PassengerModel with _$PassengerModel {
  const factory PassengerModel({
    @JsonKey(name: 'passenger_number') int? passengerNumber,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'seat') String? seat,
    @JsonKey(name: 'profile_picture') String? profilePicture,
  }) = _PassengerModel;

  factory PassengerModel.fromJson(Map<String, dynamic> json) =>
      _$PassengerModelFromJson(json);
}

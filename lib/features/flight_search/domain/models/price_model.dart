import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_model.freezed.dart';
part 'price_model.g.dart';

@freezed
class PriceModel with _$PriceModel {
  const factory PriceModel({
    @JsonKey(name: 'amount') double? amount,
    @JsonKey(name: 'currency') String? currency,
  }) = _PriceModel;

  factory PriceModel.fromJson(Map<String, dynamic> json) =>
      _$PriceModelFromJson(json);
}
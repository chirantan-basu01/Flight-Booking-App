import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_model.freezed.dart';
part 'pagination_model.g.dart';

@freezed
class PaginationModel with _$PaginationModel {
  const factory PaginationModel({
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'totalPages') int? totalPages,
    @JsonKey(name: 'currentPage') int? currentPage,
    @JsonKey(name: 'limit') int? limit,
    @JsonKey(name: 'hasNextPage') bool? hasNextPage,
    @JsonKey(name: 'hasPrevPage') bool? hasPrevPage,
  }) = _PaginationModel;

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
}
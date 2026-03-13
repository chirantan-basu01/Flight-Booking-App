import 'package:dio/dio.dart';
import 'package:flight_booking_app/core/network/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(DioRef ref) {
  return DioClient().dio;
}
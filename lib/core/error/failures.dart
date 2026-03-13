import 'package:flight_booking_app/core/l10n/app_strings.dart';

abstract class Failure {
  String get localizedMessage;
}

class ServerFailure extends Failure {
  final int? statusCode;
  final String? message;

  ServerFailure({this.statusCode, this.message});

  @override
  String get localizedMessage {
    if (message != null && message!.isNotEmpty) {
      return message!;
    }
    if (statusCode == 429) return AppStrings.get('error_rate_limit');
    if (statusCode == 404) return AppStrings.get('error_not_found');
    if (statusCode == 400) return AppStrings.get('error_bad_request');
    return AppStrings.get('error_server');
  }
}

class NetworkFailure extends Failure {
  @override
  String get localizedMessage => AppStrings.get('error_no_internet');
}

class TimeoutFailure extends Failure {
  @override
  String get localizedMessage => AppStrings.get('error_timeout');
}

class CacheFailure extends Failure {
  @override
  String get localizedMessage => AppStrings.get('error_cache');
}

class UnknownFailure extends Failure {
  final String? message;

  UnknownFailure({this.message});

  @override
  String get localizedMessage =>
      message ?? AppStrings.get('error_unknown');
}
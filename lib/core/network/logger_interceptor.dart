import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌───────────────────────────────────────────────────────');
      debugPrint('│ REQUEST: ${options.method} ${options.uri}');
      debugPrint('│ Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('│ Body: ${options.data}');
      }
      debugPrint('└───────────────────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌───────────────────────────────────────────────────────');
      debugPrint(
          '│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('│ Data: ${_truncateData(response.data)}');
      debugPrint('└───────────────────────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌───────────────────────────────────────────────────────');
      debugPrint('│ ERROR: ${err.type} ${err.requestOptions.uri}');
      debugPrint('│ Message: ${err.message}');
      if (err.error != null) {
        debugPrint('│ Error: ${err.error}');
        debugPrint('│ Error Type: ${err.error.runtimeType}');
      }
      if (err.response?.data != null) {
        debugPrint('│ Response: ${err.response?.data}');
      }
      if (err.stackTrace != null) {
        debugPrint('│ StackTrace: ${err.stackTrace.toString().split('\n').take(5).join('\n')}');
      }
      debugPrint('└───────────────────────────────────────────────────────');
    }
    handler.next(err);
  }

  String _truncateData(dynamic data) {
    final str = data.toString();
    if (str.length > 500) {
      return '${str.substring(0, 500)}... (truncated)';
    }
    return str;
  }
}
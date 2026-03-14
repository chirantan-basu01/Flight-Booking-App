import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggerInterceptor extends Interceptor {
  /// Set to true to show full response, false to truncate
  final bool showFullResponse;

  /// Maximum length before truncating (only used if showFullResponse is false)
  final int maxLength;

  LoggerInterceptor({
    this.showFullResponse = true,
    this.maxLength = 2000,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌───────────────────────────────────────────────────────');
      debugPrint('│ REQUEST: ${options.method} ${options.uri}');
      debugPrint('│ Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('│ Body:');
        _printPrettyJson(options.data);
      }
      debugPrint('└───────────────────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌───────────────────────────────────────────────────────');
      debugPrint('│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('│ Data:');
      _printPrettyJson(response.data);
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
        debugPrint('│ Response:');
        _printPrettyJson(err.response?.data);
      }
      debugPrint('│ StackTrace: ${err.stackTrace.toString().split('\n').take(5).join('\n')}');
      debugPrint('└───────────────────────────────────────────────────────');
    }
    handler.next(err);
  }

  void _printPrettyJson(dynamic data) {
    try {
      String prettyJson;
      if (data is Map || data is List) {
        const encoder = JsonEncoder.withIndent('  ');
        prettyJson = encoder.convert(data);
      } else {
        prettyJson = data.toString();
      }

      // Apply truncation if needed
      if (!showFullResponse && prettyJson.length > maxLength) {
        prettyJson = '${prettyJson.substring(0, maxLength)}\n... (truncated, ${prettyJson.length} total chars)';
      }

      // Print line by line to avoid debugPrint truncation
      for (final line in prettyJson.split('\n')) {
        debugPrint('│   $line');
      }
    } catch (e) {
      debugPrint('│   ${data.toString()}');
    }
  }
}
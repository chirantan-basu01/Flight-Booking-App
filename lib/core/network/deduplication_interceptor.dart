import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor that prevents duplicate concurrent requests
/// If the same request is made while one is in progress, it waits for the first to complete
class DeduplicationInterceptor extends Interceptor {
  final Map<String, Completer<Response>> _pendingRequests = {};

  String _generateKey(RequestOptions options) {
    return '${options.method}:${options.uri}:${options.data?.toString() ?? ''}';
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final key = _generateKey(options);

    // Check if this request is already in progress
    if (_pendingRequests.containsKey(key)) {
      debugPrint('Dedup: Waiting for existing request: $key');
      try {
        final response = await _pendingRequests[key]!.future;
        // Return cached response for duplicate request
        handler.resolve(Response(
          requestOptions: options,
          data: response.data,
          statusCode: response.statusCode,
          headers: response.headers,
        ));
        return;
      } catch (e) {
        // If original request failed, let this one proceed
        handler.next(options);
        return;
      }
    }

    // Mark this request as in progress
    _pendingRequests[key] = Completer<Response>();
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final key = _generateKey(response.requestOptions);

    // Complete the pending request
    if (_pendingRequests.containsKey(key)) {
      if (!_pendingRequests[key]!.isCompleted) {
        _pendingRequests[key]!.complete(response);
      }
      _pendingRequests.remove(key);
    }

    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final key = _generateKey(err.requestOptions);

    // Complete with error
    if (_pendingRequests.containsKey(key)) {
      if (!_pendingRequests[key]!.isCompleted) {
        _pendingRequests[key]!.completeError(err);
      }
      _pendingRequests.remove(key);
    }

    handler.next(err);
  }

  /// Clear all pending requests
  void clear() {
    _pendingRequests.clear();
  }
}
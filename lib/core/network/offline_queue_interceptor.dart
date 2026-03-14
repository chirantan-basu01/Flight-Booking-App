import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Represents a queued request for offline scenarios
class QueuedRequest {
  final String method;
  final String path;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? queryParameters;
  final DateTime timestamp;

  QueuedRequest({
    required this.method,
    required this.path,
    this.data,
    this.queryParameters,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'method': method,
        'path': path,
        'data': data,
        'queryParameters': queryParameters,
        'timestamp': timestamp.toIso8601String(),
      };

  factory QueuedRequest.fromJson(Map<String, dynamic> json) => QueuedRequest(
        method: json['method'],
        path: json['path'],
        data: json['data'],
        queryParameters: json['queryParameters'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

/// Interceptor that queues requests when offline and replays them when online
class OfflineQueueInterceptor extends Interceptor {
  static const String _queueKey = 'offline_request_queue';
  final Dio dio;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;
  bool _isOnline = true;

  OfflineQueueInterceptor({required this.dio}) {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      final wasOffline = !_isOnline;
      _isOnline = _isConnectedFromResults(results);

      // If we just came online, process the queue
      if (wasOffline && _isOnline) {
        debugPrint('OfflineQueue: Back online, processing queued requests');
        _processQueue();
      }
    });

    // Check initial connectivity
    _connectivity.checkConnectivity().then((results) {
      _isOnline = _isConnectedFromResults(results);
    });
  }

  /// Check if connected from connectivity results (handles both old and new API)
  bool _isConnectedFromResults(dynamic results) {
    if (results is List<ConnectivityResult>) {
      return results.isNotEmpty && !results.contains(ConnectivityResult.none);
    } else if (results is ConnectivityResult) {
      return results != ConnectivityResult.none;
    }
    return false;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if this is a network error
    if (_isNetworkError(err)) {
      // Only queue write operations (POST with specific endpoints that modify data)
      // For read operations, just fail - they should use cached data
      if (err.requestOptions.method == 'POST' && _shouldQueue(err.requestOptions)) {
        await _addToQueue(err.requestOptions);
        debugPrint('OfflineQueue: Request queued for later: ${err.requestOptions.path}');
      }
    }
    handler.next(err);
  }

  bool _isNetworkError(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        (err.type == DioExceptionType.unknown && err.error != null);
  }

  bool _shouldQueue(RequestOptions options) {
    // Only queue specific endpoints that are safe to retry
    // For this app, all endpoints are read-only searches, so we don't queue them
    // This is a placeholder for future write operations (booking, etc.)
    final queueableEndpoints = <String>[
      // Add endpoints here when booking/write operations are added
      // '/booking',
      // '/payment',
    ];
    return queueableEndpoints.any((endpoint) => options.path.contains(endpoint));
  }

  Future<void> _addToQueue(RequestOptions options) async {
    final prefs = await SharedPreferences.getInstance();
    final queue = await _getQueue();

    queue.add(QueuedRequest(
      method: options.method,
      path: options.path,
      data: options.data is Map ? options.data : null,
      queryParameters: options.queryParameters,
      timestamp: DateTime.now(),
    ));

    // Keep only last 50 requests and requests from last 24 hours
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    final filteredQueue = queue
        .where((r) => r.timestamp.isAfter(cutoff))
        .toList()
        .reversed
        .take(50)
        .toList()
        .reversed
        .toList();

    await prefs.setString(
      _queueKey,
      jsonEncode(filteredQueue.map((r) => r.toJson()).toList()),
    );
  }

  Future<List<QueuedRequest>> _getQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final queueJson = prefs.getString(_queueKey);
    if (queueJson == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(queueJson);
      return decoded.map((json) => QueuedRequest.fromJson(json)).toList();
    } catch (e) {
      debugPrint('OfflineQueue: Error parsing queue: $e');
      return [];
    }
  }

  Future<void> _processQueue() async {
    final queue = await _getQueue();
    if (queue.isEmpty) return;

    debugPrint('OfflineQueue: Processing ${queue.length} queued requests');

    final prefs = await SharedPreferences.getInstance();
    final successfulRequests = <QueuedRequest>[];

    for (final request in queue) {
      try {
        await dio.request(
          request.path,
          data: request.data,
          queryParameters: request.queryParameters,
          options: Options(method: request.method),
        );
        successfulRequests.add(request);
        debugPrint('OfflineQueue: Successfully processed: ${request.path}');
      } catch (e) {
        debugPrint('OfflineQueue: Failed to process: ${request.path} - $e');
        // Keep failed requests in queue for next attempt
      }
    }

    // Remove successful requests from queue
    final remainingQueue = queue.where((r) => !successfulRequests.contains(r)).toList();
    await prefs.setString(
      _queueKey,
      jsonEncode(remainingQueue.map((r) => r.toJson()).toList()),
    );
  }

  /// Get count of queued requests
  Future<int> getQueueCount() async {
    final queue = await _getQueue();
    return queue.length;
  }

  /// Clear the queue
  Future<void> clearQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_queueKey);
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flight_booking_app/core/constants/api_constants.dart';
import 'package:flight_booking_app/core/network/cache_config.dart';
import 'package:flight_booking_app/core/network/logger_interceptor.dart';
import 'package:flight_booking_app/core/network/retry_interceptor.dart';
import 'package:flight_booking_app/core/network/deduplication_interceptor.dart';
import 'package:flight_booking_app/core/network/offline_queue_interceptor.dart';

class DioClient {
  late final Dio _dio;
  late final DioCacheInterceptor _cacheInterceptor;
  late final DeduplicationInterceptor _deduplicationInterceptor;
  late final OfflineQueueInterceptor _offlineQueueInterceptor;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Initialize interceptors
    _cacheInterceptor = DioCacheInterceptor(options: CacheConfig.defaultOptions);
    _deduplicationInterceptor = DeduplicationInterceptor();
    _offlineQueueInterceptor = OfflineQueueInterceptor(dio: _dio);

    // Order matters:
    // 1. Deduplication - prevent duplicate concurrent requests
    // 2. Cache - check cache before making request
    // 3. Logger - log requests for debugging
    // 4. Retry - retry failed requests
    // 5. Offline Queue - queue failed requests for later
    _dio.interceptors.addAll([
      _deduplicationInterceptor,
      _cacheInterceptor,
      LoggerInterceptor(),
      RetryInterceptor(maxRetries: 3, dio: _dio),
      _offlineQueueInterceptor,
    ]);
  }

  Dio get dio => _dio;

  /// Clear all cached responses
  Future<void> clearCache() async {
    await CacheConfig.clearCache();
  }

  /// Get the number of queued offline requests
  Future<int> getOfflineQueueCount() async {
    return _offlineQueueInterceptor.getQueueCount();
  }

  /// Clear the offline request queue
  Future<void> clearOfflineQueue() async {
    await _offlineQueueInterceptor.clearQueue();
  }

  /// Dispose resources
  void dispose() {
    _offlineQueueInterceptor.dispose();
    _deduplicationInterceptor.clear();
  }
}
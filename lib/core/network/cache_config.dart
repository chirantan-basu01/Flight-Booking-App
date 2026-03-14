import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';

/// Cache configuration for API responses
class CacheConfig {
  static CacheOptions? _cacheOptions;
  static HiveCacheStore? _cacheStore;

  /// Initialize cache store - call this before using DioClient
  static Future<void> initialize() async {
    if (_cacheStore != null) return;

    final dir = await getApplicationDocumentsDirectory();
    _cacheStore = HiveCacheStore(
      '${dir.path}/api_cache',
      hiveBoxName: 'flight_api_cache',
    );

    _cacheOptions = CacheOptions(
      store: _cacheStore!,
      // Use request policy: fetch from network when available, fallback to cache when offline
      policy: CachePolicy.request,
      priority: CachePriority.normal,
      maxStale: const Duration(days: 1),
      // When network fails, use cache (except for auth errors)
      hitCacheOnErrorExcept: [401, 403],
      // Custom key builder that includes POST body for unique cache keys
      keyBuilder: _buildCacheKey,
      allowPostMethod: true,
    );
  }

  /// Custom cache key builder that includes request body for POST requests
  static String _buildCacheKey(RequestOptions request) {
    String key = '${request.method}:${request.uri}';

    // Include request body in cache key for POST requests
    if (request.method == 'POST' && request.data != null) {
      try {
        final bodyString = request.data is String
            ? request.data
            : jsonEncode(request.data);
        key = '$key:$bodyString';
      } catch (_) {
        // If body can't be serialized, just use URL
      }
    }

    return key;
  }

  /// Get cache options for general API calls
  static CacheOptions get defaultOptions {
    return _cacheOptions ?? CacheOptions(store: MemCacheStore());
  }

  /// Get cache options for search results (shorter cache time)
  static CacheOptions get searchOptions {
    return defaultOptions.copyWith(
      maxStale: const Nullable(Duration(minutes: 5)),
    );
  }

  /// Get cache options for static data (airports, airlines - longer cache)
  static CacheOptions get staticDataOptions {
    return defaultOptions.copyWith(
      maxStale: const Nullable(Duration(days: 7)),
    );
  }

  /// Get cache options for flight details
  static CacheOptions get flightDetailsOptions {
    return defaultOptions.copyWith(
      maxStale: const Nullable(Duration(minutes: 15)),
    );
  }

  /// Force refresh - bypass cache and update it
  static CacheOptions get refreshOptions {
    return defaultOptions.copyWith(
      policy: CachePolicy.refreshForceCache,
    );
  }

  /// Network only - no cache
  static CacheOptions get noCache {
    return defaultOptions.copyWith(
      policy: CachePolicy.noCache,
    );
  }

  /// Clear all cached data
  static Future<void> clearCache() async {
    await _cacheStore?.clean();
  }

  /// Close cache store
  static Future<void> close() async {
    await _cacheStore?.close();
  }
}
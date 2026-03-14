import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

/// Helper to check connectivity from results (handles both old and new API)
bool _isConnectedFromResults(dynamic results) {
  if (results is List<ConnectivityResult>) {
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  } else if (results is ConnectivityResult) {
    return results != ConnectivityResult.none;
  }
  return false;
}

/// Provider that emits connectivity status changes
@riverpod
Stream<bool> connectivityStream(ConnectivityStreamRef ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    return _isConnectedFromResults(results);
  });
}

/// Provider that checks current connectivity and watches for changes
@riverpod
Future<bool> connectivityService(ConnectivityServiceRef ref) async {
  // Watch the stream for updates
  ref.listen(connectivityStreamProvider, (previous, next) {
    next.whenData((isConnected) {
      ref.invalidateSelf();
    });
  });

  final results = await Connectivity().checkConnectivity();
  return _isConnectedFromResults(results);
}

/// Simple check for current connectivity status
@riverpod
Future<bool> isConnected(IsConnectedRef ref) async {
  final results = await Connectivity().checkConnectivity();
  return _isConnectedFromResults(results);
}
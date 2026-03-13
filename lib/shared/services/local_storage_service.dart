import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage_service.g.dart';

class LocalStorageService {
  static const String _lastSearchKey = 'last_search';
  static const String _savedTripsKey = 'saved_trips';
  static const String _localeKey = 'locale';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // Last Search
  Future<void> saveLastSearch(Map<String, dynamic> searchParams) async {
    await _prefs.setString(_lastSearchKey, jsonEncode(searchParams));
  }

  Map<String, dynamic>? getLastSearch() {
    final json = _prefs.getString(_lastSearchKey);
    if (json != null) {
      return jsonDecode(json) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> clearLastSearch() async {
    await _prefs.remove(_lastSearchKey);
  }

  // Saved Trips
  Future<void> saveSavedTrips(List<Map<String, dynamic>> trips) async {
    final jsonList = trips.map((trip) => jsonEncode(trip)).toList();
    await _prefs.setStringList(_savedTripsKey, jsonList);
  }

  List<Map<String, dynamic>> getSavedTrips() {
    final jsonList = _prefs.getStringList(_savedTripsKey) ?? [];
    return jsonList
        .map((json) => jsonDecode(json) as Map<String, dynamic>)
        .toList();
  }

  Future<void> addSavedTrip(Map<String, dynamic> trip) async {
    final trips = getSavedTrips();
    trips.add(trip);
    await saveSavedTrips(trips);
  }

  Future<void> removeSavedTrip(int index) async {
    final trips = getSavedTrips();
    if (index >= 0 && index < trips.length) {
      trips.removeAt(index);
      await saveSavedTrips(trips);
    }
  }

  Future<void> clearSavedTrips() async {
    await _prefs.remove(_savedTripsKey);
  }

  // Locale
  Future<void> saveLocale(String locale) async {
    await _prefs.setString(_localeKey, locale);
  }

  String getLocale() {
    return _prefs.getString(_localeKey) ?? 'en';
  }
}

@riverpod
Future<LocalStorageService> localStorageService(
    LocalStorageServiceRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  return LocalStorageService(prefs);
}
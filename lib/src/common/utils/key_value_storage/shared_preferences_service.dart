import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save methods
  Future<void> saveInt(String key, int value) async => await _prefs.setInt(key, value);

  Future<void> saveBool(String key, bool value) async => await _prefs.setBool(key, value);

  Future<void> saveDouble(String key, double value) async => await _prefs.setDouble(key, value);

  Future<void> saveString(String key, String value) async => await _prefs.setString(key, value);

  /// Get methods
  int? getInt(String key) => _prefs.getInt(key);

  bool? getBool(String key) => _prefs.getBool(key);

  double? getDouble(String key) => _prefs.getDouble(key);

  String? getString(String key) => _prefs.getString(key);

  /// Remove a specific key
  Future<void> remove(String key) async => await _prefs.remove(key);

  /// Clear all preferences
  Future<void> clear() async => await _prefs.clear();
}

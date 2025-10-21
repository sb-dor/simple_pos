// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class SecureStorageService {
//   SecureStorageService(this._storage);
//
//   final FlutterSecureStorage _storage;
//
//   Future<void> saveString(String key, String value) async {
//     await _storage.write(key: key, value: value);
//   }
//
//   Future<String?> getString(String key) async {
//     return await _storage.read(key: key);
//   }
//
//   Future<void> saveInt(String key, int value) async {
//     await _storage.write(key: key, value: value.toString());
//   }
//
//   Future<int?> getInt(String key) async {
//     final value = await _storage.read(key: key);
//     return value != null ? int.tryParse(value) : null;
//   }
//
//   Future<void> saveBool(String key, bool value) async {
//     await _storage.write(key: key, value: value.toString());
//   }
//
//   Future<bool?> getBool(String key) async {
//     final value = await _storage.read(key: key);
//     return value != null ? value.toLowerCase() == 'true' : null;
//   }
//
//   Future<void> saveDouble(String key, double value) async {
//     await _storage.write(key: key, value: value.toString());
//   }
//
//   Future<double?> getDouble(String key) async {
//     final value = await _storage.read(key: key);
//     return value != null ? double.tryParse(value) : null;
//   }
//
//   Future<void> delete(String key) async {
//     await _storage.delete(key: key);
//   }
//
//   Future<void> deleteAll() async {
//     await _storage.deleteAll();
//   }
// }

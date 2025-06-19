import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PersistData {
  static const _secureStorage = FlutterSecureStorage();

  static Future<void> writeData(String key, dynamic value) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> readData(String key) async {
    final String? value = await _secureStorage.read(key: key);
    return value;
  }

  static Future<void> deleteDataByKey(String key) async {
    await _secureStorage.delete(key: key);
  }

  static Future<void> deleteAllData() async {
    await _secureStorage.deleteAll();
  }

  static Future<void> deleteData() async {
    await _secureStorage.delete(key: 'x-auth-token');
    await _secureStorage.delete(key: 'id');
  }

  static Future<void> persistData(String token, num id) async {
    await _secureStorage.write(key: 'x-auth-token', value: token);
    await _secureStorage.write(key: 'id', value: id.toString());
  }

  static Future<void> getStarted() async {
    await _secureStorage.write(key: 'getStarted', value: 'true');
  }

  static Future<String?> readGetStarted() async {
    final String? getStarted = await _secureStorage.read(key: 'getStarted');
    return getStarted;
  }

  static Future<bool> get isNew async =>
      await readGetStarted() == 'true' ? false : true;

  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'x-auth-token');
  }

  static Future<String?> getId() async {
    final id = await _secureStorage.read(key: 'id');
    return id.toString();
  }

  static Future<bool> get isAuth async {
    final token = await _secureStorage.read(key: 'x-auth-token');
    if (token == null) {
      return false;
    }
    return true;
  }

  static Future<String?> get id async => await getId();
  static Future<String?> get token async => await getToken();
}

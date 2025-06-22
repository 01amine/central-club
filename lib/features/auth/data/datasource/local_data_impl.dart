import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import 'local_data.dart';


class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  static const String CACHED_AUTH_TOKEN = 'CACHED_AUTH_TOKEN';

  @override
  Future<void> saveToken(String token) {
    return sharedPreferences.setString(CACHED_AUTH_TOKEN, token);
  }

  @override
  Future<String?> getToken() {
    try {
      final token = sharedPreferences.getString(CACHED_AUTH_TOKEN);
      return Future.value(token);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearToken() {
    return sharedPreferences.remove(CACHED_AUTH_TOKEN);
  }
}
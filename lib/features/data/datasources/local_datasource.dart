import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _ACCESS_TOKEN = 'access_token';
const String _USER_TYPE = 'user_type';

class LocalDatasource {
  FlutterSecureStorage? secureStorage;
  SharedPreferences? prefs;

  LocalDatasource({
    FlutterSecureStorage? securePreferences,
    SharedPreferences? sharedPreferences,
  }) {
    secureStorage = securePreferences;
    prefs = sharedPreferences;
  }

  Future<void> setAccessToken(String value) async {
    secureStorage!.write(key: _ACCESS_TOKEN, value: value);
  }

  Future<String?> getAccessToken() async {
    return secureStorage!.read(key: _ACCESS_TOKEN);
  }

  void clearAccessToken() {
    secureStorage!.delete(key: _ACCESS_TOKEN);
  }

// USER TYPE Methods
  Future<void> setUserType(String userType) async {
    await prefs!.setString(_USER_TYPE, userType);
  }

  String? getUserType() {
    return prefs!.getString(_USER_TYPE);
  }

  Future<void> clearUserType() async {
    await prefs!.remove(_USER_TYPE);
  }
}

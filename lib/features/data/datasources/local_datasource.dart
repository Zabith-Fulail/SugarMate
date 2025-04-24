import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _ACCESS_TOKEN = 'access_token';

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

}

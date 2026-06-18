import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class LocalStorage {
  late SharedPreferences _prefs;
  final Logger _logger = Logger();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _logger.i('LocalStorage initialized');
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
    _logger.i('Token saved');
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  Future<void> saveUserData(String userJson) async {
    await _prefs.setString(_userKey, userJson);
    _logger.i('User data saved');
  }

  String? getUserData() {
    return _prefs.getString(_userKey);
  }

  Future<void> clearAuthData() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userKey);
    _logger.i('Auth data cleared');
  }

  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
    _logger.i('All local data cleared');
  }
}

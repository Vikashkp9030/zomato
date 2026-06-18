import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();
  factory FFAppState() => _instance;
  FFAppState._internal();
  static void reset() => _instance = FFAppState._internal();

  Future<void> initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() => _authToken = prefs.getString('ff_authToken') ?? _authToken);
    _safeInit(() => _currentUserID = prefs.getInt('ff_currentUserID') ?? _currentUserID);
    _safeInit(() => _currentUserName = prefs.getString('ff_currentUserName') ?? _currentUserName);
    _safeInit(() => _currentUserEmail = prefs.getString('ff_currentUserEmail') ?? _currentUserEmail);
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _authToken = '';
  String get authToken => _authToken;
  set authToken(String value) {
    _authToken = value;
    prefs.setString('ff_authToken', value);
  }

  int _currentUserID = 0;
  int get currentUserID => _currentUserID;
  set currentUserID(int value) {
    _currentUserID = value;
    prefs.setInt('ff_currentUserID', value);
  }

  String _currentUserName = '';
  String get currentUserName => _currentUserName;
  set currentUserName(String value) {
    _currentUserName = value;
    prefs.setString('ff_currentUserName', value);
  }

  String _currentUserEmail = '';
  String get currentUserEmail => _currentUserEmail;
  set currentUserEmail(String value) {
    _currentUserEmail = value;
    prefs.setString('ff_currentUserEmail', value);
  }

  bool get isLoggedIn => _authToken.isNotEmpty;

  void clearAuth() {
    authToken = '';
    currentUserID = 0;
    currentUserName = '';
    currentUserEmail = '';
  }
}

void _safeInit(Function() fn) {
  try {
    fn();
  } catch (_) {}
}

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';

/// Service for handling local storage operations
class LocalStorageService {
  final SharedPreferences _prefs;
  
  const LocalStorageService(this._prefs);
  
  /// Save user token
  Future<void> saveUserToken(String token) async {
    try {
      await _prefs.setString(AppConstants.userTokenKey, token);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save user token: $e',
        code: ErrorCodes.cacheWriteError,
      );
    }
  }
  
  /// Get user token
  String? getUserToken() {
    try {
      return _prefs.getString(AppConstants.userTokenKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get user token: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Remove user token
  Future<void> removeUserToken() async {
    try {
      await _prefs.remove(AppConstants.userTokenKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to remove user token: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Save user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final jsonString = jsonEncode(userData);
      await _prefs.setString(AppConstants.userDataKey, jsonString);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save user data: $e',
        code: ErrorCodes.cacheWriteError,
      );
    }
  }
  
  /// Get user data
  Map<String, dynamic>? getUserData() {
    try {
      final jsonString = _prefs.getString(AppConstants.userDataKey);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get user data: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Remove user data
  Future<void> removeUserData() async {
    try {
      await _prefs.remove(AppConstants.userDataKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to remove user data: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Save theme mode
  Future<void> saveThemeMode(String themeMode) async {
    try {
      await _prefs.setString(AppConstants.themeKey, themeMode);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save theme mode: $e',
        code: ErrorCodes.cacheWriteError,
      );
    }
  }
  
  /// Get theme mode
  String? getThemeMode() {
    try {
      return _prefs.getString(AppConstants.themeKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get theme mode: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Save language
  Future<void> saveLanguage(String language) async {
    try {
      await _prefs.setString(AppConstants.languageKey, language);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save language: $e',
        code: ErrorCodes.cacheWriteError,
      );
    }
  }
  
  /// Get language
  String? getLanguage() {
    try {
      return _prefs.getString(AppConstants.languageKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get language: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Save generic string value
  Future<void> saveString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save string: $e',
        code: ErrorCodes.cacheWriteError,
      );
    }
  }
  
  /// Get generic string value
  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get string: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Save generic boolean value
  Future<void> saveBool(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save boolean: $e',
        code: ErrorCodes.cacheWriteError,
      );
    }
  }
  
  /// Get generic boolean value
  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get boolean: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Save generic integer value
  Future<void> saveInt(String key, int value) async {
    try {
      await _prefs.setInt(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save integer: $e',
        code: ErrorCodes.cacheWriteError,
      );
    }
  }
  
  /// Get generic integer value
  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get integer: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Save generic double value
  Future<void> saveDouble(String key, double value) async {
    try {
      await _prefs.setDouble(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save double: $e',
        code: ErrorCodes.cacheWriteError,
      );
    }
  }
  
  /// Get generic double value
  double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get double: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Save generic list of strings
  Future<void> saveStringList(String key, List<String> value) async {
    try {
      await _prefs.setStringList(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save string list: $e',
        code: ErrorCodes.cacheWriteError,
      );
    }
  }
  
  /// Get generic list of strings
  List<String>? getStringList(String key) {
    try {
      return _prefs.getStringList(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get string list: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Save generic JSON object
  Future<void> saveJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      await _prefs.setString(key, jsonString);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save JSON: $e',
        code: ErrorCodes.cacheWriteError,
      );
    }
  }
  
  /// Get generic JSON object
  Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get JSON: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Remove value by key
  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to remove value: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Clear all stored data
  Future<void> clear() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear storage: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Check if key exists
  bool containsKey(String key) {
    try {
      return _prefs.containsKey(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to check key existence: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Get all keys
  Set<String> getKeys() {
    try {
      return _prefs.getKeys();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get keys: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
  
  /// Check if user is logged in
  bool get isLoggedIn {
    try {
      return getUserToken() != null && getUserData() != null;
    } catch (e) {
      return false;
    }
  }
  
  /// Logout user (clear all auth data)
  Future<void> logout() async {
    try {
      await removeUserToken();
      await removeUserData();
    } catch (e) {
      throw CacheException(
        message: 'Failed to logout: $e',
        code: ErrorCodes.cacheError,
      );
    }
  }
}

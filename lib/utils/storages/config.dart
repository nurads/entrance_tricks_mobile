import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

class ConfigPreference {
  // Prevent instantiation
  ConfigPreference._();

  static const String _preferencesBox = 'preferences';
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';
  static const String _isFirstLaunchKey = 'is_first_launch';
  static const String _accessTokenKey = 'access_token';

  // Initialize Hive
  static Future<void> init() async {
    await Hive.openBox<dynamic>(_preferencesBox);
  }

  // Get Hive box
  static Box<dynamic> _getBox() {
    return Hive.box(_preferencesBox);
  }

  // Set theme to light/dark
  static Future<void> setThemeIsLight(bool lightTheme) async {
    await _getBox().put(_lightThemeKey, lightTheme);
  }

  // Get current theme (light or dark)
  static bool getThemeIsLight() {
    return _getBox().get(_lightThemeKey, defaultValue: true) as bool;
  }

  // Save current language
  static Future<void> setCurrentLanguage(String languageCode) async {
    await _getBox().put(_currentLocalKey, languageCode);
  }

  // Get current language
  static Locale getCurrentLocal() {
    String? langCode = _getBox().get(_currentLocalKey) as String?;
    return langCode == null ? const Locale('en') : Locale(langCode);
  }

  // Check if it's the first launch
  static bool isFirstLaunch() {
    return _getBox().get(_isFirstLaunchKey, defaultValue: true) as bool;
  }

  // Mark the app as launched
  static Future<void> markAppLaunched() async {
    await _getBox().put(_isFirstLaunchKey, false);
  }

  // Store access token
  static Future<void> storeAccessToken(String accessToken) async {
    await _getBox().put(_accessTokenKey, accessToken);
  }

  // Get access token
  static String? getAccessToken() {
    return _getBox().get(_accessTokenKey) as String?;
  }

  // Clear all stored data
  static Future<void> clear() async {
    await _getBox().clear();
  }
}

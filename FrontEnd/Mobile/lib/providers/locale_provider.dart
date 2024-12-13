import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  static const String _localeKey = 'selected_locale';

  Locale get locale => _locale ?? Locale(ui.window.locale.languageCode);

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey);
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    }
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, languageCode);
    notifyListeners();
  }

  String getCurrentLanguageCode() {
    return _locale?.languageCode ?? ui.window.locale.languageCode;
  }
}

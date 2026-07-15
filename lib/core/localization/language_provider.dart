import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  static final LanguageProvider _instance = LanguageProvider._internal();
  factory LanguageProvider() => _instance;
  LanguageProvider._internal();

  Locale _currentLocale = const Locale('en');
  Locale get currentLocale => _currentLocale;

  bool get isEnglish => _currentLocale.languageCode == 'en';

  void toggleLanguage() {
    _currentLocale = isEnglish ? const Locale('ml') : const Locale('en');
    notifyListeners();
  }

  // Helper to translate strings
  String translate(String enText, String mlText) {
    return isEnglish ? enText : mlText;
  }
}

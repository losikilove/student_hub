import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  String _languageCode = 'en';

  String get languageCode => _languageCode;

  void changeLanguage(String languageCode) {
    _languageCode = languageCode;
    notifyListeners();
  }
}
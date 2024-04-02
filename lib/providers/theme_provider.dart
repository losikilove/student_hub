import 'package:flutter/material.dart';
import 'package:student_hub/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  bool _isDark = false;
  // ThemeData _themeData = darkMode;
  // bool _isDark = true;

  ThemeData get themeData => _themeData;
  bool get isDark => _isDark;

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
      _isDark = true;
    } else {
      _themeData = lightMode;
      _isDark = false;
    }

    notifyListeners();
  }
}

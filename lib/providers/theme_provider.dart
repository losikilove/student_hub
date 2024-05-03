import 'package:flutter/material.dart';
import 'package:student_hub/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  bool _isDark = false;
  // ThemeData _themeData = darkMode;
  // bool _isDark = true;

  ThemeData get themeData => _themeData;
  bool get isDark => _isDark;

  ThemeProvider() {
    loadTheme();
  }
  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
      _isDark = true;
    } else {
      _themeData = lightMode;
      _isDark = false;
    }
    saveTheme(_isDark);
    notifyListeners();
  }
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? true;
    _themeData = _isDark ? darkMode : lightMode;
    notifyListeners();
  }
  Future<void> saveTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }
}

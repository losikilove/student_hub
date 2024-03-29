import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color.fromRGBO(162, 216, 255, 1),
    primary: Color.fromARGB(255, 100, 181, 246),
    secondary: Color.fromARGB(255, 21, 101, 192),
    onBackground: Colors.white, // immutable
    onPrimary: Colors.black, // for text color
    onSecondary: Colors.white, // for background of option
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade800,
    primary: Colors.grey.shade900,
    secondary: Colors.black,
    onBackground: Colors.white, // immutable
    onPrimary: Colors.white, // for text color
    onSecondary: Colors.black, // for background of option
  ),
);

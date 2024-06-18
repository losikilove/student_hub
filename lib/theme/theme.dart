import 'package:flutter/material.dart';


ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Colors.white,
    primary: Color.fromRGBO(2, 153, 164, 1),
    secondary: Color.fromRGBO(5, 185, 161, 1),
    onBackground: Colors.white, // immutable
    onPrimary: Colors.black, // for text color
    onSecondary: Colors.white, // for background of option
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade800 ,
    primary: Colors.grey.shade700,
    secondary: Colors.black,
    onBackground: Colors.white, // immutable
    onPrimary: Colors.white, // for text color
    onSecondary: Colors.black45, // for background of option
  ),
);

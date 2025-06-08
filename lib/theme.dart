import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white, // Hardcoded Light Background
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 55, 57, 59),
    onPrimary: Colors.white,
    surface: Colors.white, // Ensure background is white
    onSurface: Color.fromARGB(255, 23, 22, 22),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 132, 142, 151),
  scaffoldBackgroundColor: const Color.fromARGB(255, 46, 45, 45), // Hardcoded Dark Background
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: Color.fromARGB(255, 100, 104, 108),
    onPrimary: Color.fromARGB(255, 141, 140, 140),
    surface: Color.fromARGB(255, 57, 57, 57), // Ensure background is grey
    onSurface: Colors.white,
  ),
);  

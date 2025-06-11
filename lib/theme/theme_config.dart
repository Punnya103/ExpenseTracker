
import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 234, 233, 233),
  colorScheme: ColorScheme.light(
    background: const Color.fromARGB(255, 255, 255, 255),
    onBackground: Colors.black,
      primary: const Color.fromARGB(255, 121, 218, 86),
    secondary: const Color.fromARGB(255, 6, 33, 16),
    tertiary: const Color.fromARGB(233, 0, 132, 71),
    outline: const Color.fromARGB(255, 0, 0, 0),
    outlineVariant: const Color.fromARGB(255, 220, 217, 217),
    onSurface: const Color.fromARGB(255, 237, 234, 234),
  ),
);

final darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 42, 42, 42),
  colorScheme: ColorScheme.dark(
    background: const Color.fromARGB(255, 64, 64, 64),
    onBackground: Colors.white,
    primary: const Color.fromARGB(255, 121, 218, 86),
    secondary: const Color.fromARGB(255, 43, 154, 85),
    tertiary: const Color.fromARGB(233, 0, 132, 71),
    outline: Colors.grey.shade400,
    outlineVariant: const Color.fromARGB(255, 255, 255, 255),
        onSurface: const Color.fromARGB(255, 195, 192, 192),
  ),
);


    // primary: Color(0xFF4A00E0),
    // secondary: Color(0xFF8E2DE2),
    // tertiary:  Color(0xFFDA4453),
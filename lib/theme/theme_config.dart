
import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 234, 233, 233),
  colorScheme: ColorScheme.light(
    background: const Color.fromARGB(255, 222, 221, 221),
    onBackground: Colors.black,
      primary: const Color.fromARGB(255, 25, 94, 0),
    secondary: const Color.fromARGB(255, 24, 127, 13),
    tertiary: const Color.fromARGB(233, 95, 197, 40),
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
      primary: const Color.fromARGB(255, 14, 49, 1),
    secondary: const Color.fromARGB(255, 9, 80, 1),
    tertiary: const Color.fromARGB(233, 37, 98, 4),
    outline: Colors.grey.shade400,
    outlineVariant: const Color.fromARGB(255, 255, 255, 255),
        onSurface: const Color.fromARGB(255, 195, 192, 192),
  ),
);


    // primary: Color(0xFF4A00E0),
    // secondary: Color(0xFF8E2DE2),
    // tertiary:  Color(0xFFDA4453),
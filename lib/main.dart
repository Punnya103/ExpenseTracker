// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_view.dart';
import 'theme/theme_controller.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyAppView(),
    ),
  );
}



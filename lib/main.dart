import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_controller.dart';
import 'theme/theme_config.dart';
import 'app_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyAppView(),
    ),
  );
}


import 'package:expensetracker/screens/SplashScreen/view/splash_screen.dart';

import 'package:expensetracker/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_controller.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}


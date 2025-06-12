import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app_view.dart';
import 'theme/theme_controller.dart';
import 'firebase_options.dart';
import 'firebase/firebase_api.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyAppView(),
    ),
  );
}

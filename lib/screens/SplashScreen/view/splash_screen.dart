import 'package:expensetracker/screens/auth/login/views/login_screen.dart';
import 'package:expensetracker/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<bool> checkLoginStatus() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    return token != null;
  }

  void handleStart(BuildContext context) async {
    final isLoggedIn = await checkLoginStatus();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.primary, theme.secondary, theme.tertiary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Lottie animation
              Lottie.network(
                'https://assets4.lottiefiles.com/packages/lf20_w51pcehl.json',
                height: 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),

              /// App Title
              const Text(
                'Always track control',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'of your Finances',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

           
              GestureDetector(
                onTap: () => handleStart(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.primary, theme.secondary, theme.tertiary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Let\'s Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

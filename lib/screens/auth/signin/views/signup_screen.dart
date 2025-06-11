import 'dart:math';
import 'dart:ui';

import 'package:expensetracker/screens/auth/login/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import '../blocs/signup_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(authRepository: AuthRepository()),
      child: Scaffold(
        body: BlocListener<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration successful! Please log in.')),
              );
              Navigator.pop(context);
            } else if (state is SignupFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.tertiary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary,
                ],
                transform: const GradientRotation(pi / 30),
              ),
            ),
            child: Stack(
              children: [
                // ✅ Top-left logo + woxtrack text
                Positioned(
                  top: 60,
                  left: 20,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images-removebg-preview.png',
                        height: 50,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'woxtrack',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 5, 151, 56),
                        ),
                      ),
                    ],
                  ),
                ),

                // ✅ Center sign up form
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: SingleChildScrollView(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  TextFormField(
                                    controller: _fullNameController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      labelText: "Full Name",
                                      labelStyle: TextStyle(color: Colors.white70),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white70),
                                      ),
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty ? 'Enter full name' : null,
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: _userNameController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      labelText: "Username",
                                      labelStyle: TextStyle(color: Colors.white70),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white70),
                                      ),
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty ? 'Enter username' : null,
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      labelText: "Email",
                                      labelStyle: TextStyle(color: Colors.white70),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white70),
                                      ),
                                    ),
                                    validator: (value) => value == null || !value.contains('@')
                                        ? 'Enter valid email'
                                        : null,
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      labelText: "Password",
                                      labelStyle: TextStyle(color: Colors.white70),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white70),
                                      ),
                                    ),
                                    validator: (value) => value == null || value.length < 6
                                        ? 'Password must be at least 6 characters'
                                        : null,
                                  ),
                                  const SizedBox(height: 30),
                                  BlocBuilder<SignupBloc, SignupState>(
                                    builder: (context, state) {
                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Theme.of(context).primaryColor,
                                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        onPressed: state is SignupLoading
                                            ? null
                                            : () {
                                                if (_formKey.currentState!.validate()) {
                                                  context.read<SignupBloc>().add(
                                                        SignupSubmitted(
                                                          fullName:
                                                              _fullNameController.text.trim(),
                                                          userName:
                                                              _userNameController.text.trim(),
                                                          email: _emailController.text.trim(),
                                                          password:
                                                              _passwordController.text.trim(),
                                                        ),
                                                      );
                                                }
                                              },
                                        child: state is SignupLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.green,
                                              )
                                            : const Text("Sign Up"),
                                      );
                                    },
                                  ),
                                       const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don't have an account? ",
                                      style:
                                          TextStyle(color: Colors.white70),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Sign In",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

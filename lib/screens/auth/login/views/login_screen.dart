import 'dart:math';
import 'dart:ui';
import 'package:expensetracker/screens/auth/repositories/auth_repository.dart';
import 'package:expensetracker/screens/auth/login/blocs/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expensetracker/screens/auth/signin/views/signup_screen.dart';
import 'package:expensetracker/screens/home/views/home_screen.dart';
import 'package:expensetracker/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(authRepository: AuthRepository()),
      child: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
            LoginSubmitted(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
           
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.secondary,
          
              ],
              transform: const GradientRotation(pi / 30),
            ),
          ),
          child: Stack(
            children: [
              
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
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                TextFormField(
                                  controller: _emailController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    labelStyle:
                                        TextStyle(color: Colors.white70),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white70),
                                    ),
                                  ),
                                  validator: (value) => value == null ||
                                          !value.contains('@')
                                      ? 'Enter valid email'
                                      : null,
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    labelStyle:
                                        TextStyle(color: Colors.white70),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white70),
                                    ),
                                  ),
                                  validator: (value) => value == null ||
                                          value.length < 6
                                      ? 'Password too short'
                                      : null,
                                ),
                                const SizedBox(height: 30),
                                BlocBuilder<LoginBloc, LoginState>(
                                  builder: (context, state) {
                                    return PrimaryButton(
                                      onPressed: _onLoginPressed,
                                      label: 'Login',
                                      isLoading: state is LoginLoading,
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
                                                const SignUpScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Sign Up",
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
    );
  }
}
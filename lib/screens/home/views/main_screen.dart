import 'dart:convert';
import 'dart:math';

import 'package:expensetracker/screens/auth/login/views/login_screen.dart';
import 'package:expensetracker/screens/profile/view/profile_screen.dart';
import 'package:expensetracker/theme/theme_controller.dart';
import 'package:expensetracker/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? userName;

  List<Map<String, dynamic>> expenses = [];
  bool isLoading = true;
  String? error;

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day.toString().padLeft(2, '0')} '
          '${_monthName(date.month)} ${date.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
    fetchExpenses();
  }

  Future<void> _loadUsername() async {
    final storedName = await _storage.read(key: 'username');
    setState(() {
      userName = storedName ?? 'User';
    });
  }

  Future<void> fetchExpenses() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        setState(() {
          error = 'No token found';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://expense-tracker-mean.onrender.com/expense/get-expense',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        setState(() {
          expenses = List<Map<String, dynamic>>.from(data['data']['expenses']);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load expenses';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              label: "Log out",
              onPressed: () async {
                Navigator.pop(context);
                await _storage.deleteAll();
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.1, vertical: 10),
        child: Column(
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'profile') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        } else if (value == 'logout') {
                          showLogoutConfirmation();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'profile',
                          child: Text('Profile'),
                        ),
                        const PopupMenuItem(
                          value: 'logout',
                          child: Text('Logout'),
                        ),
                      ],
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow[700],
                            ),
                          ),
                          Icon(
                            CupertinoIcons.person_fill,
                            color: Colors.yellow[900],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        Text(
                          'Welcome, ${userName ?? '...'}!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: IconButton(
                    onPressed: () =>
                        context.read<ThemeController>().toggleTheme(),
                    icon: Icon(
                      context.watch<ThemeController>().isDarkMode
                          ? CupertinoIcons.sun_max_fill
                          : CupertinoIcons.moon_fill,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            /// Banner / Balance Card
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2,
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                  transform: const GradientRotation(pi / 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '\$ 4800.00',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(
                                  context,
                                ).colorScheme.outlineVariant.withOpacity(0.2),
                              ),
                              child: const Icon(
                                CupertinoIcons.arrow_up,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Income',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '\$ 2.500',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(
                                  context,
                                ).colorScheme.outlineVariant.withOpacity(0.2),
                              ),
                              child: const Icon(
                                CupertinoIcons.arrow_down,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expenses',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '\$ 2.500',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),


            const SizedBox(height: 20),

             
            // const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            
          Expanded(
  child: isLoading
      ? const Center(child: CircularProgressIndicator())
      : error != null
          ? Center(
              child: Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, i) {
                final expense = expenses[i];
                final isDark = context.watch<ThemeController>().isDarkMode;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color.fromRGBO(220, 217, 217, 0.1)
                          : const Color.fromRGBO(255, 255, 255, 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                       
                          Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 50, 245, 56).withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const Icon(Icons.receipt_long)
                                ],
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    expense['name'] ?? 'No Name',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 165, 165, 165),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${expense['category']} • ${expense['paymentType']}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.outline,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                         
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '- ₹${expense['amount']}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(expense['expenseDate']),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
),

          ],
        ),
      ),
    );
  }
}


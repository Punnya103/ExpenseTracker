import 'dart:convert';
import 'package:expensetracker/screens/auth/login/views/login_screen.dart';
import 'package:expensetracker/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Map<String, dynamic>? user;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        setState(() {
          error = 'Token not found';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://expense-tracker-mean.onrender.com/auth/check-auth'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          user = data['data']['user'];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load profile';
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

  Future<void> updateUsername(String newUsername) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) return;
    print(token);
    try {
      final response = await http.post(
        Uri.parse('https://expense-tracker-mean.onrender.com/auth/update-user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"userName": newUsername}),
      );

      if (response.statusCode == 200) {
        fetchProfile();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username updated successfully")),
        );
      } else {
        final err = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Update failed: ${err['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating: $e")));
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
              Navigator.pop(context); // Close the dialog
              await _storage.deleteAll(); // Remove token
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


  void showEditDialog() {
    final TextEditingController controller = TextEditingController(
      text: user?['userName'],
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Username"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "New Username"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Update"),
              onPressed: () {
                final newUsername = controller.text.trim();
                if (newUsername.isNotEmpty) {
                  Navigator.pop(context);
                  updateUsername(newUsername);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildProfileCard({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onEdit,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: colorScheme.secondary),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.tertiary,
              ),
            ),
            if (onEdit != null)
              IconButton(
                icon: Icon(Icons.edit, size: 20, color: colorScheme.primary),
                onPressed: onEdit,
              ),
          ],
        ),
        subtitle: Text(value, style: TextStyle(color: colorScheme.onSurface)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.1),
        // title: const Text('Profile', style: TextStyle(color: Colors.black)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : error != null
          ? Center(
              child: Text(error!, style: TextStyle(color: colorScheme.error)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.primary,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildProfileCard(
                    icon: Icons.account_circle,
                    label: 'Username',
                    value: user?['userName'] ?? '',
                    onEdit: showEditDialog,
                  ),
                  buildProfileCard(
                    icon: Icons.person,
                    label: 'Full Name',
                    value: user?['fullName'] ?? '',
                  ),
                  buildProfileCard(
                    icon: Icons.email,
                    label: 'Email',
                    value: user?['email'] ?? '',
                  ),
                     const SizedBox(height: 20),
               SizedBox(
  width: MediaQuery.of(context).size.width, 
  
  child: PrimaryButton(
    label: "Log out",
    onPressed: showLogoutConfirmation,
  ),
),

                ],
              ),
            ),
    );
  }
}

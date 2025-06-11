import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:expensetracker/widgets/category_picker_field.dart';
import 'package:expensetracker/widgets/custom_text_field.dart';
import 'package:expensetracker/widgets/date_picker_field.dart';
import 'package:expensetracker/widgets/payment_method_picker_field.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final storage = const FlutterSecureStorage();
  DateTime? selectedDate;
  bool isCategoryDropdownOpen = false;
  bool isLoadingCategories = false;
  bool isPaymentDropdownOpen = false;

  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final paymentMethodController = TextEditingController();
  final noteController = TextEditingController();
  final newCategoryController = TextEditingController();
  List<String> categories = [];

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    categoryController.dispose();
    paymentMethodController.dispose();
    noteController.dispose();
    newCategoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Category"),
        content: TextField(
          controller: newCategoryController,
          decoration: const InputDecoration(hintText: "Category Name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              newCategoryController.clear();
              Navigator.pop(ctx);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () async {
              final newCat = newCategoryController.text.trim();

              if (newCat.isEmpty || categories.contains(newCat)) {
                Navigator.pop(ctx);
                return;
              }

              try {
                final token = await storage.read(key: 'auth_token');
                if (token == null) throw Exception("No token found");

                final uri = Uri.parse(
                    'https://expense-tracker-mean.onrender.com/category/add-category');

                final response = await http.post(
                  uri,
                  headers: {
                    'Authorization': 'Bearer $token',
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    "categoryText": [newCat],
                  }),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    categories.add(newCat);
                    categoryController.text = newCat;
                  });
                } else {
                  throw Exception(
                      'Failed to add category: ${response.statusCode} ${response.body}');
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }

              newCategoryController.clear();
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _toggleCategoryDropdown() async {
    setState(() {
      isCategoryDropdownOpen = !isCategoryDropdownOpen;
      isLoadingCategories = true;
    });

    try {
      final token = await storage.read(key: 'auth_token');
      if (token == null) throw Exception("No token found");

      final uri = Uri.parse(
          'https://expense-tracker-mean.onrender.com/category/get-category');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List<dynamic>;
        setState(() {
          categories = data.map((e) => e.toString()).toList();
        });
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to fetch categories: ${e.toString()}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => isLoadingCategories = false);
    }
  }

Future<void> _saveExpense() async {
  final name = nameController.text.trim();
  final amount = double.tryParse(amountController.text.trim());
  final category = categoryController.text.trim();
  final paymentMethod = paymentMethodController.text.trim();
  final note = noteController.text.trim();

  // Validate fields
  if (name.isEmpty ||
      amount == null ||
      selectedDate == null ||
      category.isEmpty ||
      paymentMethod.isEmpty ||
      note.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all required fields")),
    );
    return;
  }

  try {
    final token = await storage.read(key: 'auth_token');
    if (token == null) throw Exception("No token found");

    final uri = Uri.parse("https://expense-tracker-mean.onrender.com/expense/add-expense");
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": name,
        "amount": amount,
        "expenseDate": selectedDate!.toIso8601String().split("T")[0],
        "category": category,
        "paymentType": paymentMethod,
        "notes": note,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {

  nameController.clear();
  amountController.clear();
  categoryController.clear();
  paymentMethodController.clear();
  noteController.clear();
  setState(() => selectedDate = null);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Expense Saved Successfully")),
  );
} else {
  throw Exception("Failed to save expense: ${response.statusCode} ${response.body}");
}

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          isCategoryDropdownOpen = false;
          isPaymentDropdownOpen = false;
        });
      },
      child: Scaffold(
        body: Container(
         color: Theme.of(context).colorScheme.background,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Add New Expense",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:  Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hint: 'Expense Name',
                      icon: Icons.label,
                      controller: nameController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'Expense Amount',
                      icon: Icons.attach_money,
                      controller: amountController,
                    ),
                    const SizedBox(height: 12),
                    DatePickerField(
                      selectedDate: selectedDate,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 12),
                    CategoryPickerField(
                      controller: categoryController,
                      categories: categories,
                      isDropdownOpen: isCategoryDropdownOpen,
                      onToggleDropdown: _toggleCategoryDropdown,
                      onAddCategory: _showAddCategoryDialog,
                      onSelectCategory: (cat) {
                        setState(() {
                          categoryController.text = cat;
                          isCategoryDropdownOpen = false;
                        });
                      },
                      isLoading: isLoadingCategories,
                    ),
                    const SizedBox(height: 12),
                    PaymentMethodPickerField(
                      controller: paymentMethodController,
                      isDropdownOpen: isPaymentDropdownOpen,
                      onToggleDropdown: () {
                        setState(() {
                          isPaymentDropdownOpen = !isPaymentDropdownOpen;
                        });
                      },
                      onSelect: (method) {
                        setState(() {
                          paymentMethodController.text = method;
                          isPaymentDropdownOpen = false;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'Note',
                      icon: Icons.note,
                      controller: noteController,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor:  const Color.fromARGB(255, 242, 239, 239),
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _saveExpense,
                        child: const Text("Save Expense"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

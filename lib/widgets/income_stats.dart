import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class IncomeStatsWidget extends StatefulWidget {
  const IncomeStatsWidget({super.key});

  @override
  State<IncomeStatsWidget> createState() => _IncomeStatsWidgetState();
}

class _IncomeStatsWidgetState extends State<IncomeStatsWidget> {
  final List<String> months = const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  final TextEditingController incomeController = TextEditingController();
  String? selectedMonth;
  List<Map<String, dynamic>> incomeData = [];

  @override
  void initState() {
    super.initState();
    _loadData(); 
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/data.json';
  }

  Future<void> _loadData() async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    if (await file.exists()) {
      final contents = await file.readAsString();
      try {
        final decoded = jsonDecode(contents);
        if (decoded is List) {
          setState(() {
            incomeData = List<Map<String, dynamic>>.from(decoded);
          });
        }
      } catch (e) {
        print("Error reading file: $e");
      }
    }
  }

  Future<void> _saveData() async {
    final income = incomeController.text.trim();
    if (income.isEmpty || selectedMonth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter income and select month')),
      );
      return;
    }

    final Map<String, dynamic> newEntry = {
      'month': selectedMonth,
      'income': double.tryParse(income) ?? 0.0,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final filePath = await _getFilePath();
    final file = File(filePath);

    List<Map<String, dynamic>> allData = [];

    if (await file.exists()) {
      final contents = await file.readAsString();
      try {
        final decoded = jsonDecode(contents);
        if (decoded is List) {
          allData = List<Map<String, dynamic>>.from(decoded);
        }
      } catch (_) {}
    }

    allData.add(newEntry);
    await file.writeAsString(jsonEncode(allData), flush: true);

    setState(() {
      incomeData = allData;
      incomeController.clear();
      selectedMonth = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Income saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Income',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: incomeController,
                        decoration: const InputDecoration(
                          labelText: 'Income Amount',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Month',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        value: selectedMonth,
                        items: months
                            .map((month) => DropdownMenuItem(
                                  value: month,
                                  child: Text(month),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMonth = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Save Income'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (incomeData.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Income Data',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...incomeData.reversed.map((item) => ListTile(
                        leading: const Icon(Icons.money),
                        title: Text('${item['income']}'),
                        // subtitle: Text('${item['month']} - ${item['timestamp'].toString().split('T').first}'),
                        subtitle: Text('${item['month']}'),

                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

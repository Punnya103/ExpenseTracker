import 'dart:convert';
import 'package:expensetracker/theme/theme_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<PieChartSample2> createState() => _PieChartSample2State();
}

class _PieChartSample2State extends State<PieChartSample2> {
  int touchedIndex = -1;
  bool isLoading = true;
  String? error;

  List<Map<String, dynamic>> categories = [];
  final storage = const FlutterSecureStorage();

  // Colors for pie slices
  final List<Color> pieColors = [
    const Color.fromARGB(255, 5, 100, 30),
    const Color.fromARGB(255, 92, 165, 2),
    const Color.fromARGB(255, 188, 207, 16),
    Colors.green,
    Colors.orange,
    const Color.fromARGB(255, 203, 157, 18),
    const Color.fromARGB(255, 141, 168, 92),
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    fetchPieData();
  }

  Future<void> fetchPieData() async {
    try {
      final token = await storage.read(key: 'auth_token');
      if (token == null) {
        setState(() {
          error = 'Token not found';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://expense-tracker-mean.onrender.com/expense/summary/category'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        setState(() {
          categories = List<Map<String, dynamic>>.from(data['categories']);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to fetch pie chart data';
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text(error!, style: const TextStyle(color: Colors.red)));

    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(height: 18),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(categories.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: pieColors[i % pieColors.length],
                    ),
                    const SizedBox(width: 6),
                    Text(categories[i]['name'], style:  TextStyle(fontSize: 14 ,color: context.watch<ThemeController>().isDarkMode
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : const Color.fromARGB(204, 0, 0, 0),)),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

List<PieChartSectionData> showingSections() {
  final total = categories.fold<double>(0, (sum, item) => sum + (item['total'] as num).toDouble());

  return List.generate(categories.length, (i) {
    final isTouched = i == touchedIndex;
    final radius = isTouched ? 60.0 : 50.0;

    final value = (categories[i]['total'] as num).toDouble();

    return PieChartSectionData(
      color: pieColors[i % pieColors.length],
      value: value,
      title: '',
      radius: radius,
      titleStyle: const TextStyle(
        fontSize: 0,
      ),
    );
  });
}

}

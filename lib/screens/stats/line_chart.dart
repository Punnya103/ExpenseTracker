// import 'dart:convert';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;

// class LineChartSample2 extends StatefulWidget {
//   const LineChartSample2({super.key});

//   @override
//   State<LineChartSample2> createState() => _LineChartSample2State();
// }

// class _LineChartSample2State extends State<LineChartSample2> {
//   final List<Color> gradientColors = [
//     const Color(0xff23b6e6),
//     const Color(0xff02d39a),
//   ];

//   final storage = FlutterSecureStorage();
//   List<FlSpot> spots = [];
//   double maxY = 0;

//   final List<String> monthLabels = [
//     'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
//     'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
//   ];

//   final Map<String, int> monthIndexMap = {
//     'January': 0, 'February': 1, 'March': 2,
//     'April': 3, 'May': 4, 'June': 5,
//     'July': 6, 'August': 7, 'September': 8,
//     'October': 9, 'November': 10, 'December': 11
//   };

//   @override
//   void initState() {
//     super.initState();
//     fetchChartData();
//   }

//   Future<void> fetchChartData() async {
//     final token = await storage.read(key: 'token');
//     if (token == null) return;

//     final response = await http.get(
//       Uri.parse('https://expense-tracker-mean.onrender.com/expense/summary/monthly'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List<dynamic> months = data['months'];

//       List<FlSpot> tempSpots = [];

//       for (var item in months) {
//         final String month = item['month'];
//         final double total = (item['total'] as num).toDouble();
//         final int x = monthIndexMap[month] ?? -1;
//         if (x >= 0) {
//           tempSpots.add(FlSpot(x.toDouble(), total / 1000));
//           if (total > maxY) maxY = total;
//         }
//       }

//       setState(() {
//         spots = tempSpots..sort((a, b) => a.x.compareTo(b.x));
//         maxY = (maxY / 1000).ceilToDouble();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return spots.isEmpty
//         ? const Center(child: CircularProgressIndicator())
//         : AspectRatio(
//             aspectRatio: 1.70,
//             child: Padding(
//               padding: const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12),
//               child: LineChart(
//                 LineChartData(
//                   gridData: FlGridData(
//                     show: true,
//                     drawVerticalLine: true,
//                     getDrawingHorizontalLine: (_) => const FlLine(color: Colors.grey, strokeWidth: 0.5),
//                     getDrawingVerticalLine: (_) => const FlLine(color: Colors.grey, strokeWidth: 0.5),
//                   ),
//                   titlesData: FlTitlesData(
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         reservedSize: 40,
//                         interval: 5,
//                         getTitlesWidget: (value, meta) => Text('${(value).toInt()}k', style: const TextStyle(fontSize: 12)),
//                       ),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         interval: 1,
//                         reservedSize: 30,
//                         getTitlesWidget: (value, meta) {
//                           final index = value.toInt();
//                           final label = (index >= 0 && index < 12) ? monthLabels[index] : '';
//                           return Text(label, style: const TextStyle(fontSize: 12));
//                         },
//                       ),
//                     ),
//                     topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   ),
//                   borderData: FlBorderData(
//                     show: true,
//                     border: Border.all(color: const Color(0xff37434d)),
//                   ),
//                   minX: 0,
//                   maxX: 11,
//                   minY: 0,
//                   maxY: maxY,
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: spots,
//                       isCurved: true,
//                       gradient: LinearGradient(colors: gradientColors),
//                       barWidth: 4,
//                       isStrokeCapRound: true,
//                       dotData: const FlDotData(show: false),
//                       belowBarData: BarAreaData(
//                         show: true,
//                         gradient: LinearGradient(
//                           colors: gradientColors.map((c) => c.withOpacity(0.3)).toList(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//   }
// }

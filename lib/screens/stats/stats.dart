
import 'package:expensetracker/screens/stats/chart.dart';
import 'package:expensetracker/theme/theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  int selectedIndex = 0; 

  @override
  Widget build(BuildContext context) {
    final outlineColor = Theme.of(context).colorScheme.outline;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with back button and title + settings icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:    Theme.of(context).colorScheme.background,
                        // border: Border.all(
                        //   color: Colors.grey.shade300,
                        //   width: 1.5,
                        // ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.back),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Transactions",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.outline,

                      ),
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

            const SizedBox(height: 20),

            Container(
              width: double.infinity,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:   Theme.of(context).colorScheme.background,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Row(
                children: List.generate(2, (index) {
                  final isSelected = index == selectedIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                    Theme.of(context).colorScheme.tertiary,
                                  ],
                                  transform: const GradientRotation(pi / 20),
                                )
                              : null,
                          color: isSelected ? null :  Theme.of(context).colorScheme.background,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          index == 0 ? 'Income' : 'Expenses',
                          style: TextStyle(
                            color: isSelected ?  Theme.of(context).colorScheme.outlineVariant : outlineColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: PieChartSample2(),
            ),
          ],
        ),
      ),
    );
  }
}

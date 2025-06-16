import 'package:expensetracker/screens/add_expense/view/add_expense.dart';
import 'package:expensetracker/screens/stats/stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> widgetList = [MainScreen(), StatScreen()];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 3,
            currentIndex: index,
            onTap: (int i) {
              setState(() {
                index = i;
              });
            },
            iconSize: 30,
            selectedItemColor: Theme.of(context).colorScheme.outline,
            unselectedItemColor: Theme.of(context).colorScheme.outline,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.graph_square_fill),
                label: 'Stats',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
       Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const AddExpense(),
            ),
          );
        },
        shape: const CircleBorder(),
        elevation: 3,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary,
              ],
              transform: const GradientRotation(pi / 4),
            ),
          ),
          child:  Icon(CupertinoIcons.add, color:  Theme.of(context).colorScheme.outlineVariant,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: widgetList[index],
    );
  }
}

import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = selectedDate == null
        ? 'Select Date'
        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';

    final displayStyle = TextStyle(
      color: selectedDate == null
          ? Colors.grey[400]
          : Colors.black, 
      fontSize: 16,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
         color:  const Color.fromARGB(255, 242, 239, 239),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color:   Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.grey),
            const SizedBox(width: 12),
            Text(displayText, style: displayStyle),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PaymentMethodPickerField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDropdownOpen;
  final VoidCallback onToggleDropdown;
  final Function(String) onSelect;

  const PaymentMethodPickerField({
    super.key,
    required this.controller,
    required this.isDropdownOpen,
    required this.onToggleDropdown,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> paymentMethods = [
      "Cash",
      "Credit Card",
      "UPI",
      "Net Banking",
      "Others",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggleDropdown,
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Select Payment Method',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.payment, color: Colors.grey),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                filled: true,
                fillColor:  const Color.fromARGB(255, 242, 239, 239),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        if (isDropdownOpen)
          Container(
            decoration: BoxDecoration(
              color:  const Color.fromARGB(255, 242, 239, 239),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
            ),
            child: Column(
              children: paymentMethods.map((method) {
                return ListTile(
                  title: Text(method),
                  onTap: () => onSelect(method),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class CategoryPickerField extends StatelessWidget {
  final TextEditingController controller;
  final List<String> categories;
  final bool isDropdownOpen;
  final VoidCallback onToggleDropdown;
  final VoidCallback onAddCategory;
  final void Function(String) onSelectCategory;
  final bool isLoading;

  const CategoryPickerField({
    super.key,
    required this.controller,
    required this.categories,
    required this.isDropdownOpen,
    required this.onToggleDropdown,
    required this.onAddCategory,
    required this.onSelectCategory,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggleDropdown,
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Select Category",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.category, color: Colors.grey),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                filled: true,
                fillColor: const Color.fromARGB(255, 242, 239, 239),
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
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    children: [
                      ...categories.map(
                        (cat) => ListTile(
                          title: Text(cat),
                          onTap: () => onSelectCategory(cat),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text("Add new category"),
                        onTap: onAddCategory,
                      ),
                    ],
                  ),
          ),
      ],
    );
  }
}

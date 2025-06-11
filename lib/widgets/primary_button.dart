import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {

  final VoidCallback onPressed;

  final String label;

  final bool isLoading;

  final EdgeInsetsGeometry? padding;

  final OutlinedBorder? shape;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.padding,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: isLoading
          ? SizedBox(
            
              width: 20, height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color:   Theme.of(context).colorScheme.outlineVariant,
              ),
            )
          : Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
    );
  }
}

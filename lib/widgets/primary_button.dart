import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  final double? width;
  final TextStyle? labelStyle;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.padding,
    this.shape,
    this.width,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding:
              padding ?? const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          shape: shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor:
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              )
            : Text(
                label,
                style: labelStyle ?? const TextStyle(fontSize: 16), 
              ),
      ),
    );
  }
}

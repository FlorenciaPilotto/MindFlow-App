import 'package:flutter/material.dart';

/// A primary action button with consistent styling.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isOutlined;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(label)],
          )
        : Text(label);

    if (isOutlined) {
      return OutlinedButton(onPressed: onPressed, child: child);
    }
    return ElevatedButton(onPressed: onPressed, child: child);
  }
}

/// A styled text input field.
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.validator,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

/// A card with optional tap action and consistent padding.
class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const CustomCard({
    Key? key,
    required this.child,
    this.onTap,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}

/// A centered circular progress indicator.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// A centered empty-state placeholder with an icon and message.
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyStateWidget({
    Key? key,
    required this.message,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

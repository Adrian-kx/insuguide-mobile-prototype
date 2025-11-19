import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    colorSchemeSeed: const Color(0xFF2D6CDF),
    useMaterial3: true,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool filled;
  const PrimaryButton(
      {super.key, required this.text, required this.onPressed, this.filled = true});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: filled ? cs.primary : null,
          foregroundColor: filled ? cs.onPrimary : cs.primary,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
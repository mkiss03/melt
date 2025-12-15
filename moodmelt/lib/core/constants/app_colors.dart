import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF6B9BD1); // Soft Blue
  static const secondary = Color(0xFFFF9B85); // Warm Coral
  static const accent = Color(0xFFA8E6CF); // Mint Green

  static const background = Color(0xFFF5F7FA);
  static const surface = Colors.white;
  static const error = Color(0xFFE57373);

  static const textPrimary = Color(0xFF2D3748);
  static const textSecondary = Color(0xFF718096);
  static const textHint = Color(0xFFA0AEC0);

  // Mood colors
  static const moodGreat = Color(0xFF48BB78);
  static const moodGood = Color(0xFF81E6D9);
  static const moodOkay = Color(0xFFFBD38D);
  static const moodBad = Color(0xFFFFA07A);
  static const moodTerrible = Color(0xFFFC8181);

  // Gradients
  static const meltGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF64B6AC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

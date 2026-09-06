import 'package:flutter/material.dart';

/// Centralized color palette for Boarding House Finder.
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF00796B); // Deep Teal
  static const Color primaryLight = Color(0xFFE0F2F1);
  static const Color primaryDark = Color(0xFF004D40);

  // Secondary Accent Colors
  static const Color secondary = Color(0xFF0288D1); // Soft Blue
  static const Color secondaryLight = Color(0xFFE1F5FE);

  // Backgrounds and Surfaces
  static const Color background = Color(0xFFF8F9FA); // Off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  // Neutral / Text Colors
  static const Color textPrimary = Color(0xFF1E293B); // Slate 800
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color divider = Color(0xFFF1F5F9);

  // Semantic Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}

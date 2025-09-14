import 'package:flutter/material.dart';

/// Dairy shop friendly color palette
class AppColors {
  // Primary Colors - Soft cream and light green
  static const Color primaryCream = Color(0xFFF5F5DC); // Soft cream
  static const Color primaryGreen = Color(0xFF90EE90); // Light green
  static const Color primaryBlue = Color(0xFFB0E0E6); // Pastel blue
  
  // Secondary Colors
  static const Color secondaryGreen = Color(0xFF98FB98); // Pale green
  static const Color secondaryBlue = Color(0xFFE0F6FF); // Light blue
  static const Color accentOrange = Color(0xFFFFB366); // Warm orange
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color mediumGray = Color(0xFFE9ECEF);
  static const Color darkGray = Color(0xFF6C757D);
  static const Color black = Color(0xFF212529);
  
  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundCard = Color(0xFFFFFFFF);
  static const Color backgroundOverlay = Color(0x80000000);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFFADB5BD);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE9ECEF);
  static const Color borderMedium = Color(0xFFDEE2E6);
  static const Color borderDark = Color(0xFFCED4DA);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryCream, primaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [primaryBlue, secondaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [white, lightGray],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

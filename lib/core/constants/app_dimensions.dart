import 'package:flutter/material.dart';

/// Standard dimensions, spacings, and border radii across the application.
class AppDimensions {
  AppDimensions._();

  // Spacing Scale
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 20.0;
  static const double spacing2Xl = 24.0;
  static const double spacing3Xl = 32.0;

  // Border Radii
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusFull = 999.0;

  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));

  // Icon Sizes
  static const double iconSm = 18.0;
  static const double iconMd = 24.0;
  static const double iconLg = 28.0;
  static const double iconXl = 36.0;

  // Layout limits
  static const double maxContentWidth = 600.0;
}

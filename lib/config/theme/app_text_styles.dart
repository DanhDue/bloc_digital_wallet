// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';

/// Common text style constants used across light and dark themes
class AppTextStyles {
  AppTextStyles._();

  // Display styles
  static const displayLarge = TextStyle(
    fontFamily: 'SfCompactBold',
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  );

  static const displayMedium = TextStyle(
    fontFamily: 'SfCompactBold',
    fontSize: 45,
    fontWeight: FontWeight.w400,
  );

  static const displaySmall = TextStyle(
    fontFamily: 'SfCompactSemiBold',
    fontSize: 36,
    fontWeight: FontWeight.w400,
  );

  // Headline styles
  static const headlineLarge = TextStyle(
    fontFamily: 'SfCompactSemiBold',
    fontSize: 32,
    fontWeight: FontWeight.w400,
  );

  static const headlineMedium = TextStyle(
    fontFamily: 'SfCompactSemiBold',
    fontSize: 28,
    fontWeight: FontWeight.w400,
  );

  static const headlineSmall = TextStyle(
    fontFamily: 'SfCompactMedium',
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  // Title styles
  static const titleLarge = TextStyle(
    fontFamily: 'SfCompactMedium',
    fontSize: 22,
    fontWeight: FontWeight.w400,
  );

  static const titleMedium = TextStyle(
    fontFamily: 'SfCompactMedium',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

  static const titleSmall = TextStyle(
    fontFamily: 'SfCompactMedium',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // Body styles
  static const bodyLarge = TextStyle(
    fontFamily: 'SfCompactRegular',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static const bodyMedium = TextStyle(
    fontFamily: 'SfCompactRegular',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  static const bodySmall = TextStyle(
    fontFamily: 'SfCompactRegular',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // Label styles
  static const labelLarge = TextStyle(
    fontFamily: 'SfCompactMedium',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const labelMedium = TextStyle(
    fontFamily: 'SfCompactMedium',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const labelSmall = TextStyle(
    fontFamily: 'SfCompactMedium',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}

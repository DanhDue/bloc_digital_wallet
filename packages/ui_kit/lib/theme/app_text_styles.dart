// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';

/// Material 3 text style constants following the official spec
/// Font: Roboto (Material 3 default)
/// Reference: Material 3 Design Kit - Baseline & Emphasis styles
class AppTextStyles {
  AppTextStyles._();

  // ============================================================================
  // DISPLAY STYLES (Baseline)
  // ============================================================================

  /// Display Large - Roboto 57/64, Regular, -0.25 letter spacing
  static const displayLarge = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 57,
    height: 64 / 57, // line-height / font-size
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  );

  /// Display Medium - Roboto 45/52, Regular, 0 letter spacing
  static const displayMedium = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 45,
    height: 52 / 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Display Small - Roboto 36/44, Regular, 0 letter spacing
  static const displaySmall = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 36,
    height: 44 / 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // ============================================================================
  // HEADLINE STYLES (Baseline)
  // ============================================================================

  /// Headline Large - Roboto 32/40, Regular, 0 letter spacing
  static const headlineLarge = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Headline Medium - Roboto 28/36, Regular, 0 letter spacing
  static const headlineMedium = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Headline Small - Roboto 24/32, Regular, 0 letter spacing
  static const headlineSmall = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // ============================================================================
  // TITLE STYLES (Baseline)
  // ============================================================================

  /// Title Large - Roboto 22/28, Regular, 0 letter spacing
  static const titleLarge = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Title Medium - Roboto 16/24, Medium, +0.15 letter spacing
  static const titleMedium = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

  /// Title Small - Roboto 14/20, Medium, +0.1 letter spacing
  static const titleSmall = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // ============================================================================
  // LABEL STYLES (Baseline)
  // ============================================================================

  /// Label Large - Roboto 14/20, Medium, +0.1 letter spacing
  static const labelLarge = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  /// Label Medium - Roboto 12/16, Medium, +0.5 letter spacing
  static const labelMedium = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  /// Label Small - Roboto 11/16, Medium, +0.5 letter spacing
  static const labelSmall = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // ============================================================================
  // BODY STYLES (Baseline)
  // ============================================================================

  /// Body Large - Roboto 16/24, Regular, +0.5 letter spacing
  static const bodyLarge = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  /// Body Medium - Roboto 14/20, Regular, +0.25 letter spacing
  static const bodyMedium = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  /// Body Small - Roboto 12/16, Regular, +0.4 letter spacing
  static const bodySmall = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // ============================================================================
  // EMPHASIZED STYLES (Medium/SemiBold/Bold variants)
  // ============================================================================

  /// Display Large Emphasized - Roboto 57/64, Medium, -0.25 letter spacing
  static const displayLargeEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 57,
    height: 64 / 57,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.25,
  );

  /// Display Medium Emphasized - Roboto 45/52, Medium, 0 letter spacing
  static const displayMediumEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 45,
    height: 52 / 45,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  /// Display Small Emphasized - Roboto 36/44, Medium, 0 letter spacing
  static const displaySmallEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 36,
    height: 44 / 36,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  /// Headline Large Emphasized - Roboto 32/40, Medium, 0 letter spacing
  static const headlineLargeEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  /// Headline Medium Emphasized - Roboto 28/36, Medium, 0 letter spacing
  static const headlineMediumEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  /// Headline Small Emphasized - Roboto 24/32, Medium, 0 letter spacing
  static const headlineSmallEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  /// Title Large Emphasized - Roboto 22/28, Medium, 0 letter spacing
  static const titleLargeEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  /// Title Medium Emphasized - Roboto 16/24, SemiBold, +0.15 letter spacing
  static const titleMediumEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );

  /// Title Small Emphasized - Roboto 14/20, SemiBold, +0.1 letter spacing
  static const titleSmallEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  /// Label Large Emphasized - Roboto 14/20, SemiBold, +0.1 letter spacing
  static const labelLargeEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  /// Label Medium Emphasized - Roboto 12/16, SemiBold, +0.5 letter spacing
  static const labelMediumEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  /// Label Small Emphasized - Roboto 11/16, SemiBold, +0.5 letter spacing
  static const labelSmallEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  /// Body Large Emphasized - Roboto 16/24, Medium, +0.5 letter spacing
  static const bodyLargeEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  /// Body Medium Emphasized - Roboto 14/20, Medium, +0.25 letter spacing
  static const bodyMediumEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
  );

  /// Body Small Emphasized - Roboto 12/16, Medium, +0.4 letter spacing
  static const bodySmallEmphasized = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
  );
}

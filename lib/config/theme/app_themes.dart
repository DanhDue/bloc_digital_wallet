// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:bloc_digital_wallet/config/good_log.dart';
import 'package:bloc_digital_wallet/config/theme/app_text_styles.dart';
import 'package:bloc_digital_wallet/generated/colors.gen.dart';

part 'app_themes.tailor.dart';

@TailorMixin(themeGetter: ThemeGetter.onBuildContext)
@TailorMixinComponent()
class AppThemes extends ThemeExtension<AppThemes> with _$AppThemesTailorMixin {
  @override
  final Color primaryColor;
  @override
  final Color secondaryColor;
  @override
  final Color backgroundColor;
  @override
  final Color surfaceColor;
  @override
  final Color errorColor;
  @override
  final Color textPrimaryColor;
  @override
  final Color textSecondaryColor;
  @override
  final Color dividerColor;
  @override
  final Color shadowColor;

  // Authentication colors
  @override
  final Color authTextSecondary;
  @override
  final Color authBorderColor;
  @override
  final Color authShadowColor;
  @override
  final Color authTextPrimary;
  @override
  final Color scannerButtonColor;
  @override
  final Color scannerIconColor;
  @override
  final Color trueBlue0;
  @override
  final Color trueBlue5;
  @override
  final Color trueBlue10;
  @override
  final Color trueBlue15;
  @override
  final Color trueBlue20;
  @override
  final Color trueBlue40;
  @override
  final Color trueBlue60;
  @override
  final Color trueBlue80;
  @override
  final Color trueBlue100;
  @override
  final Color trueBlue;

  // Text styles from Material textTheme
  @override
  final TextStyle displayLarge;
  @override
  final TextStyle displayMedium;
  @override
  final TextStyle displaySmall;
  @override
  final TextStyle headlineLarge;
  @override
  final TextStyle headlineMedium;
  @override
  final TextStyle headlineSmall;
  @override
  final TextStyle titleLarge;
  @override
  final TextStyle titleMedium;
  @override
  final TextStyle titleSmall;
  @override
  final TextStyle bodyLarge;
  @override
  final TextStyle bodyMedium;
  @override
  final TextStyle bodySmall;
  @override
  final TextStyle labelLarge;
  @override
  final TextStyle labelMedium;
  @override
  final TextStyle labelSmall;

  const AppThemes({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.errorColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.dividerColor,
    required this.shadowColor,
    required this.authTextSecondary,
    required this.authBorderColor,
    required this.authShadowColor,
    required this.authTextPrimary,
    required this.scannerButtonColor,
    required this.scannerIconColor,
    required this.trueBlue0,
    required this.trueBlue5,
    required this.trueBlue10,
    required this.trueBlue15,
    required this.trueBlue20,
    required this.trueBlue40,
    required this.trueBlue60,
    required this.trueBlue80,
    required this.trueBlue100,
    required this.trueBlue,
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  @override
  AppThemes copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? errorColor,
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? dividerColor,
    Color? shadowColor,
    Color? authTextSecondary,
    Color? authBorderColor,
    Color? authShadowColor,
    Color? authTextPrimary,
    Color? scannerButtonColor,
    Color? scannerIconColor,
    Color? trueBlue0,
    Color? trueBlue5,
    Color? trueBlue10,
    Color? trueBlue15,
    Color? trueBlue20,
    Color? trueBlue40,
    Color? trueBlue60,
    Color? trueBlue80,
    Color? trueBlue100,
    Color? trueBlue,
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
  }) {
    return AppThemes(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      errorColor: errorColor ?? this.errorColor,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      dividerColor: dividerColor ?? this.dividerColor,
      shadowColor: shadowColor ?? this.shadowColor,
      authTextSecondary: authTextSecondary ?? this.authTextSecondary,
      authBorderColor: authBorderColor ?? this.authBorderColor,
      authShadowColor: authShadowColor ?? this.authShadowColor,
      authTextPrimary: authTextPrimary ?? this.authTextPrimary,
      scannerButtonColor: scannerButtonColor ?? this.scannerButtonColor,
      scannerIconColor: scannerIconColor ?? this.scannerIconColor,
      trueBlue0: trueBlue0 ?? this.trueBlue0,
      trueBlue5: trueBlue5 ?? this.trueBlue5,
      trueBlue10: trueBlue10 ?? this.trueBlue10,
      trueBlue15: trueBlue15 ?? this.trueBlue15,
      trueBlue20: trueBlue20 ?? this.trueBlue20,
      trueBlue40: trueBlue40 ?? this.trueBlue40,
      trueBlue60: trueBlue60 ?? this.trueBlue60,
      trueBlue80: trueBlue80 ?? this.trueBlue80,
      trueBlue100: trueBlue100 ?? this.trueBlue100,
      trueBlue: trueBlue ?? this.trueBlue,
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
    );
  }

  @override
  AppThemes lerp(ThemeExtension<AppThemes> other, double t) {
    if (other is! AppThemes) {
      return this;
    }
    return AppThemes(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t) ?? primaryColor,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t) ?? secondaryColor,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t) ?? backgroundColor,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t) ?? surfaceColor,
      errorColor: Color.lerp(errorColor, other.errorColor, t) ?? errorColor,
      textPrimaryColor:
          Color.lerp(textPrimaryColor, other.textPrimaryColor, t) ?? textPrimaryColor,
      textSecondaryColor:
          Color.lerp(textSecondaryColor, other.textSecondaryColor, t) ?? textSecondaryColor,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t) ?? dividerColor,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t) ?? shadowColor,
      authTextSecondary:
          Color.lerp(authTextSecondary, other.authTextSecondary, t) ?? authTextSecondary,
      authBorderColor: Color.lerp(authBorderColor, other.authBorderColor, t) ?? authBorderColor,
      authShadowColor: Color.lerp(authShadowColor, other.authShadowColor, t) ?? authShadowColor,
      authTextPrimary: Color.lerp(authTextPrimary, other.authTextPrimary, t) ?? authTextPrimary,
      scannerButtonColor:
          Color.lerp(scannerButtonColor, other.scannerButtonColor, t) ?? scannerButtonColor,
      scannerIconColor:
          Color.lerp(scannerIconColor, other.scannerIconColor, t) ?? scannerIconColor,
      trueBlue0: Color.lerp(trueBlue0, other.trueBlue0, t) ?? trueBlue0,
      trueBlue5: Color.lerp(trueBlue5, other.trueBlue5, t) ?? trueBlue5,
      trueBlue10: Color.lerp(trueBlue10, other.trueBlue10, t) ?? trueBlue10,
      trueBlue15: Color.lerp(trueBlue15, other.trueBlue15, t) ?? trueBlue15,
      trueBlue20: Color.lerp(trueBlue20, other.trueBlue20, t) ?? trueBlue20,
      trueBlue40: Color.lerp(trueBlue40, other.trueBlue40, t) ?? trueBlue40,
      trueBlue60: Color.lerp(trueBlue60, other.trueBlue60, t) ?? trueBlue60,
      trueBlue80: Color.lerp(trueBlue80, other.trueBlue80, t) ?? trueBlue80,
      trueBlue100: Color.lerp(trueBlue100, other.trueBlue100, t) ?? trueBlue100,
      trueBlue: Color.lerp(trueBlue, other.trueBlue, t) ?? trueBlue,
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t) ?? displayLarge,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t) ?? displayMedium,
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t) ?? displaySmall,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t) ?? headlineLarge,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t) ?? headlineMedium,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t) ?? headlineSmall,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t) ?? titleLarge,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t) ?? titleMedium,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t) ?? titleSmall,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t) ?? bodyLarge,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t) ?? bodyMedium,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t) ?? bodySmall,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t) ?? labelLarge,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t) ?? labelMedium,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t) ?? labelSmall,
    );
  }

  /// Light theme
  static final light = AppThemes(
    primaryColor: AppColors.themePrimary,
    secondaryColor: AppColors.themeSecondary,
    backgroundColor: AppColors.wildSand,
    surfaceColor: AppColors.white,
    errorColor: AppColors.themeErrorLight,
    textPrimaryColor: AppColors.black,
    textSecondaryColor: AppColors.textGrey,
    dividerColor: AppColors.themeDividerLight,
    shadowColor: Colors.black12,
    authTextSecondary: AppColors.authTextSecondary,
    authBorderColor: AppColors.authBorderColor,
    authShadowColor: AppColors.authShadowColor,
    authTextPrimary: AppColors.authTextPrimary,
    scannerButtonColor: AppColors.scannerBlue,
    scannerIconColor: AppColors.white,
    trueBlue0: AppColors.trueBlue0,
    trueBlue5: AppColors.trueBlue5,
    trueBlue10: AppColors.trueBlue10,
    trueBlue15: AppColors.trueBlue15,
    trueBlue20: AppColors.trueBlue20,
    trueBlue40: AppColors.trueBlue40,
    trueBlue60: AppColors.trueBlue60,
    trueBlue80: AppColors.trueBlue80,
    trueBlue100: AppColors.trueBlue100,
    trueBlue: AppColors.trueBlue,
    displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.black),
    displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.black),
    displaySmall: AppTextStyles.displaySmall.copyWith(color: AppColors.black),
    headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.black),
    headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.black),
    headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.black),
    titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.black),
    titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.black),
    titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.black),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.black),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.black),
    bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.black),
    labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.black),
    labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.black),
  );

  /// Dark theme
  static final dark = AppThemes(
    primaryColor: AppColors.themePrimary,
    secondaryColor: AppColors.themeSecondary,
    backgroundColor: AppColors.themeBackgroundDark,
    surfaceColor: AppColors.themeSurfaceDark,
    errorColor: AppColors.themeErrorDark,
    textPrimaryColor: AppColors.white,
    textSecondaryColor: AppColors.themeTextSecondaryDark,
    dividerColor: AppColors.themeDividerDark,
    shadowColor: Colors.black45,
    authTextSecondary: AppColors.themeTextSecondaryDark,
    authBorderColor: AppColors.themeDividerDark,
    authShadowColor: Colors.black26,
    authTextPrimary: AppColors.white,
    scannerButtonColor: AppColors.scannerBlue,
    scannerIconColor: AppColors.white,
    trueBlue0: AppColors.trueBlue0,
    trueBlue5: AppColors.trueBlue5,
    trueBlue10: AppColors.trueBlue10,
    trueBlue15: AppColors.trueBlue15,
    trueBlue20: AppColors.trueBlue20,
    trueBlue40: AppColors.trueBlue40,
    trueBlue60: AppColors.trueBlue60,
    trueBlue80: AppColors.trueBlue80,
    trueBlue100: AppColors.trueBlue100,
    trueBlue: AppColors.trueBlue,
    displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.white),
    displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.white),
    displaySmall: AppTextStyles.displaySmall.copyWith(color: AppColors.white),
    headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.white),
    headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
    headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.white),
    titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
    titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
    titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.white),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.white),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
    bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.themeTextSecondaryDark),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.white),
    labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
    labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
  );
}

final talkerTheme = TalkerScreenTheme(logColors: {GoodLog.getKey: AppColors.materialGreen500});

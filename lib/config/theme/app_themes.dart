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
  @override
  final Color greenVogue0;
  @override
  final Color greenVogue5;
  @override
  final Color greenVogue10;
  @override
  final Color greenVogue15;
  @override
  final Color greenVogue20;
  @override
  final Color greenVogue25;
  @override
  final Color greenVogue30;
  @override
  final Color greenVogue35;
  @override
  final Color greenVogue40;
  @override
  final Color greenVogue45;
  @override
  final Color greenVogue50;
  @override
  final Color greenVogue55;
  @override
  final Color greenVogue60;
  @override
  final Color greenVogue65;
  @override
  final Color greenVogue70;
  @override
  final Color greenVogue75;
  @override
  final Color greenVogue80;
  @override
  final Color greenVogue85;
  @override
  final Color greenVogue90;
  @override
  final Color greenVogue95;
  @override
  final Color greenVogue100;
  @override
  final Color greenVogue;
  @override
  final Color middleBlue;
  @override
  final Color pinkLady;
  @override
  final Color ink0;
  @override
  final Color ink5;
  @override
  final Color ink10;
  @override
  final Color ink20;
  @override
  final Color ink40;
  @override
  final Color ink60;
  @override
  final Color ink80;
  @override
  final Color ink100;
  @override
  final Color transparent;
  @override
  final Color white;
  @override
  final Color black;
  @override
  final Color mainGreen;

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
    required this.greenVogue0,
    required this.greenVogue5,
    required this.greenVogue10,
    required this.greenVogue15,
    required this.greenVogue20,
    required this.greenVogue25,
    required this.greenVogue30,
    required this.greenVogue35,
    required this.greenVogue40,
    required this.greenVogue45,
    required this.greenVogue50,
    required this.greenVogue55,
    required this.greenVogue60,
    required this.greenVogue65,
    required this.greenVogue70,
    required this.greenVogue75,
    required this.greenVogue80,
    required this.greenVogue85,
    required this.greenVogue90,
    required this.greenVogue95,
    required this.greenVogue100,
    required this.greenVogue,
    required this.middleBlue,
    required this.pinkLady,
    required this.ink0,
    required this.ink5,
    required this.ink10,
    required this.ink20,
    required this.ink40,
    required this.ink60,
    required this.ink80,
    required this.ink100,
    required this.transparent,
    required this.white,
    required this.black,
    required this.mainGreen,
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
    Color? greenVogue0,
    Color? greenVogue5,
    Color? greenVogue10,
    Color? greenVogue15,
    Color? greenVogue20,
    Color? greenVogue25,
    Color? greenVogue30,
    Color? greenVogue35,
    Color? greenVogue40,
    Color? greenVogue45,
    Color? greenVogue50,
    Color? greenVogue55,
    Color? greenVogue60,
    Color? greenVogue65,
    Color? greenVogue70,
    Color? greenVogue75,
    Color? greenVogue80,
    Color? greenVogue85,
    Color? greenVogue90,
    Color? greenVogue95,
    Color? greenVogue100,
    Color? greenVogue,
    Color? middleBlue,
    Color? pinkLady,
    Color? ink0,
    Color? ink5,
    Color? ink10,
    Color? ink20,
    Color? ink40,
    Color? ink60,
    Color? ink80,
    Color? ink100,
    Color? transparent,
    Color? white,
    Color? black,
    Color? mainGreen,
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
      greenVogue0: greenVogue0 ?? this.greenVogue0,
      greenVogue5: greenVogue5 ?? this.greenVogue5,
      greenVogue10: greenVogue10 ?? this.greenVogue10,
      greenVogue15: greenVogue15 ?? this.greenVogue15,
      greenVogue20: greenVogue20 ?? this.greenVogue20,
      greenVogue25: greenVogue25 ?? this.greenVogue25,
      greenVogue30: greenVogue30 ?? this.greenVogue30,
      greenVogue35: greenVogue35 ?? this.greenVogue35,
      greenVogue40: greenVogue40 ?? this.greenVogue40,
      greenVogue45: greenVogue45 ?? this.greenVogue45,
      greenVogue50: greenVogue50 ?? this.greenVogue50,
      greenVogue55: greenVogue55 ?? this.greenVogue55,
      greenVogue60: greenVogue60 ?? this.greenVogue60,
      greenVogue65: greenVogue65 ?? this.greenVogue65,
      greenVogue70: greenVogue70 ?? this.greenVogue70,
      greenVogue75: greenVogue75 ?? this.greenVogue75,
      greenVogue80: greenVogue80 ?? this.greenVogue80,
      greenVogue85: greenVogue85 ?? this.greenVogue85,
      greenVogue90: greenVogue90 ?? this.greenVogue90,
      greenVogue95: greenVogue95 ?? this.greenVogue95,
      greenVogue100: greenVogue100 ?? this.greenVogue100,
      greenVogue: greenVogue ?? this.greenVogue,
      middleBlue: middleBlue ?? this.middleBlue,
      pinkLady: pinkLady ?? this.pinkLady,
      ink0: ink0 ?? this.ink0,
      ink5: ink5 ?? this.ink5,
      ink10: ink10 ?? this.ink10,
      ink20: ink20 ?? this.ink20,
      ink40: ink40 ?? this.ink40,
      ink60: ink60 ?? this.ink60,
      ink80: ink80 ?? this.ink80,
      ink100: ink100 ?? this.ink100,
      transparent: transparent ?? this.transparent,
      white: white ?? this.white,
      black: black ?? this.black,
      mainGreen: mainGreen ?? this.mainGreen,
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
      greenVogue0: Color.lerp(greenVogue0, other.greenVogue0, t) ?? greenVogue0,
      greenVogue5: Color.lerp(greenVogue5, other.greenVogue5, t) ?? greenVogue5,
      greenVogue10: Color.lerp(greenVogue10, other.greenVogue10, t) ?? greenVogue10,
      greenVogue15: Color.lerp(greenVogue15, other.greenVogue15, t) ?? greenVogue15,
      greenVogue20: Color.lerp(greenVogue20, other.greenVogue20, t) ?? greenVogue20,
      greenVogue25: Color.lerp(greenVogue25, other.greenVogue25, t) ?? greenVogue25,
      greenVogue30: Color.lerp(greenVogue30, other.greenVogue30, t) ?? greenVogue30,
      greenVogue35: Color.lerp(greenVogue35, other.greenVogue35, t) ?? greenVogue35,
      greenVogue40: Color.lerp(greenVogue40, other.greenVogue40, t) ?? greenVogue40,
      greenVogue45: Color.lerp(greenVogue45, other.greenVogue45, t) ?? greenVogue45,
      greenVogue50: Color.lerp(greenVogue50, other.greenVogue50, t) ?? greenVogue50,
      greenVogue55: Color.lerp(greenVogue55, other.greenVogue55, t) ?? greenVogue55,
      greenVogue60: Color.lerp(greenVogue60, other.greenVogue60, t) ?? greenVogue60,
      greenVogue65: Color.lerp(greenVogue65, other.greenVogue65, t) ?? greenVogue65,
      greenVogue70: Color.lerp(greenVogue70, other.greenVogue70, t) ?? greenVogue70,
      greenVogue75: Color.lerp(greenVogue75, other.greenVogue75, t) ?? greenVogue75,
      greenVogue80: Color.lerp(greenVogue80, other.greenVogue80, t) ?? greenVogue80,
      greenVogue85: Color.lerp(greenVogue85, other.greenVogue85, t) ?? greenVogue85,
      greenVogue90: Color.lerp(greenVogue90, other.greenVogue90, t) ?? greenVogue90,
      greenVogue95: Color.lerp(greenVogue95, other.greenVogue95, t) ?? greenVogue95,
      greenVogue100: Color.lerp(greenVogue100, other.greenVogue100, t) ?? greenVogue100,
      greenVogue: Color.lerp(greenVogue, other.greenVogue, t) ?? greenVogue,
      middleBlue: Color.lerp(middleBlue, other.middleBlue, t) ?? middleBlue,
      pinkLady: Color.lerp(pinkLady, other.pinkLady, t) ?? pinkLady,
      ink0: Color.lerp(ink0, other.ink0, t) ?? ink0,
      ink5: Color.lerp(ink5, other.ink5, t) ?? ink5,
      ink10: Color.lerp(ink10, other.ink10, t) ?? ink10,
      ink20: Color.lerp(ink20, other.ink20, t) ?? ink20,
      ink40: Color.lerp(ink40, other.ink40, t) ?? ink40,
      ink60: Color.lerp(ink60, other.ink60, t) ?? ink60,
      ink80: Color.lerp(ink80, other.ink80, t) ?? ink80,
      ink100: Color.lerp(ink100, other.ink100, t) ?? ink100,
      transparent: Color.lerp(transparent, other.transparent, t) ?? transparent,
      white: Color.lerp(white, other.white, t) ?? white,
      black: Color.lerp(black, other.black, t) ?? black,
      mainGreen: Color.lerp(mainGreen, other.mainGreen, t) ?? mainGreen,
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
    greenVogue0: AppColors.greenVogue0,
    greenVogue5: AppColors.greenVogue5,
    greenVogue10: AppColors.greenVogue10,
    greenVogue15: AppColors.greenVogue15,
    greenVogue20: AppColors.greenVogue20,
    greenVogue25: AppColors.greenVogue25,
    greenVogue30: AppColors.greenVogue30,
    greenVogue35: AppColors.greenVogue35,
    greenVogue40: AppColors.greenVogue40,
    greenVogue45: AppColors.greenVogue45,
    greenVogue50: AppColors.greenVogue50,
    greenVogue55: AppColors.greenVogue55,
    greenVogue60: AppColors.greenVogue60,
    greenVogue65: AppColors.greenVogue65,
    greenVogue70: AppColors.greenVogue70,
    greenVogue75: AppColors.greenVogue75,
    greenVogue80: AppColors.greenVogue80,
    greenVogue85: AppColors.greenVogue85,
    greenVogue90: AppColors.greenVogue90,
    greenVogue95: AppColors.greenVogue95,
    greenVogue100: AppColors.greenVogue100,
    greenVogue: AppColors.greenVogue,
    middleBlue: AppColors.middleBlue,
    pinkLady: AppColors.pinkLady,
    ink0: AppColors.ink0,
    ink5: AppColors.ink5,
    ink10: AppColors.ink10,
    ink20: AppColors.ink20,
    ink40: AppColors.ink40,
    ink60: AppColors.ink60,
    ink80: AppColors.ink80,
    ink100: AppColors.ink100,
    transparent: AppColors.transparent,
    white: AppColors.white,
    black: AppColors.black,
    mainGreen: AppColors.mainGreen,
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
    greenVogue0: AppColors.greenVogue0,
    greenVogue5: AppColors.greenVogue5,
    greenVogue10: AppColors.greenVogue10,
    greenVogue15: AppColors.greenVogue15,
    greenVogue20: AppColors.greenVogue20,
    greenVogue25: AppColors.greenVogue25,
    greenVogue30: AppColors.greenVogue30,
    greenVogue35: AppColors.greenVogue35,
    greenVogue40: AppColors.greenVogue40,
    greenVogue45: AppColors.greenVogue45,
    greenVogue50: AppColors.greenVogue50,
    greenVogue55: AppColors.greenVogue55,
    greenVogue60: AppColors.greenVogue60,
    greenVogue65: AppColors.greenVogue65,
    greenVogue70: AppColors.greenVogue70,
    greenVogue75: AppColors.greenVogue75,
    greenVogue80: AppColors.greenVogue80,
    greenVogue85: AppColors.greenVogue85,
    greenVogue90: AppColors.greenVogue90,
    greenVogue95: AppColors.greenVogue95,
    greenVogue100: AppColors.greenVogue100,
    greenVogue: AppColors.greenVogue,
    middleBlue: AppColors.middleBlue,
    pinkLady: AppColors.pinkLady,
    ink0: AppColors.ink0,
    ink5: AppColors.ink5,
    ink10: AppColors.ink10,
    ink20: AppColors.ink20,
    ink40: AppColors.ink40,
    ink60: AppColors.ink60,
    ink80: AppColors.ink80,
    ink100: AppColors.ink100,
    transparent: AppColors.transparent,
    white: AppColors.white,
    black: AppColors.black,
    mainGreen: AppColors.mainGreen,
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

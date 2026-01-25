// Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    this.onPressed,
    this.text,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.textColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.horizontalTextPadding,
    this.verticalTextPadding,
    this.fullWidth = true,
  });

  final VoidCallback? onPressed;
  final String? text;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final Color? textColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? horizontalTextPadding;
  final double? verticalTextPadding;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? .infinity : null,
      padding: .symmetric(horizontal: horizontalPadding ?? 0, vertical: verticalPadding ?? 0),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          backgroundColor: .all(backgroundColor ?? context.appThemes.trueBlue),
          shape: .all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: .circular(borderRadius ?? 6),
              side: BorderSide(
                width: borderColor != null ? 1 : 0,
                color: borderColor ?? context.appThemes.trueBlue,
              ),
            ),
          ),
        ),
        child: Padding(
          padding: .symmetric(
            horizontal: horizontalTextPadding ?? 8,
            vertical: verticalTextPadding ?? 8,
          ),
          child: Text(
            text ?? "",
            style: context.appThemes.bodyMedium.copyWith(
              color: textColor ?? context.appThemes.white,
            ),
            textAlign: .center,
          ),
        ),
      ),
    );
  }
}

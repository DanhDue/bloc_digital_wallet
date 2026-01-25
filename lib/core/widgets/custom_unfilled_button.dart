// Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:flutter/material.dart';

class CustomUnfilledButton extends StatelessWidget {
  const CustomUnfilledButton({
    super.key,
    this.onPressed,
    this.text,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.textColor,
    this.horizontalPadding,
    this.horizontalTextPadding,
    this.subText,
    this.startIcon,
    this.endIcon,
    this.verticalPadding,
    this.verticalTextPadding,
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
  final String? subText;
  final Widget? startIcon;
  final Widget? endIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .symmetric(horizontal: horizontalPadding ?? 0, vertical: verticalPadding ?? 0),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          backgroundColor: .all(backgroundColor ?? context.appThemes.transparent),
          shape: .all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: .circular(borderRadius ?? 6),
              side: BorderSide(
                width: borderColor != null ? 1 : 0,
                color: borderColor ?? context.appThemes.transparent,
              ),
            ),
          ),
        ),
        child: Padding(
          padding: .symmetric(
            horizontal: horizontalTextPadding ?? 8,
            vertical: verticalTextPadding ?? 8,
          ),
          child: Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            mainAxisSize: .min,
            children: [
              Visibility(
                visible: startIcon != null,
                child: Row(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .center,
                  mainAxisSize: .min,
                  children: [startIcon ?? const SizedBox.shrink(), const SizedBox(width: 2)],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .center,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      text ?? "",
                      style: context.appThemes.bodyMedium.copyWith(
                        color: textColor ?? context.appThemes.ink100,
                      ),
                      textAlign: .center,
                    ),
                    Visibility(
                      visible: subText?.isNotEmpty == true,
                      child: Text(
                        subText ?? "",
                        style: context.appThemes.bodyMedium.copyWith(
                          color: context.appThemes.ink60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: endIcon != null,
                child: Row(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .center,
                  mainAxisSize: .min,
                  children: [const SizedBox(width: 2), endIcon ?? const SizedBox.shrink()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

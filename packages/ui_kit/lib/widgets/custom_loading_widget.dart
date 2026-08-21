// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/generated/assets.gen.dart';
import 'package:ui_kit/theme/app_themes.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key, this.msg});

  final String? msg;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                RepaintBoundary(
                  child: Assets.lotties.sandyLoading.lottie(
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    animate: true,
                    repeat: true,
                    backgroundLoading: true,
                  ),
                ),
                Visibility(
                  visible: msg != null && msg!.isNotEmpty,
                  child: Column(
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        msg ?? context.coreT.core.common.processing,
                        style: context.appThemes.bodySmall.copyWith(
                          color: context.appThemes.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/config/theme/app_themes.dart' show AppThemesBuildContext;
import 'package:bloc_digital_wallet/core/extensions/widget_extensions.dart';
import 'package:bloc_digital_wallet/generated/assets.gen.dart';
import 'package:flutter/material.dart';

class TokenActionButton extends StatelessWidget {
  const TokenActionButton({super.key, required this.icon, required this.title});

  final AssetGenImage icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        icon.image(width: 53, height: 80, fit: BoxFit.cover).paddingOnly(bottom: 6),
        Text(
          title,
          style: context.appThemes.titleMedium.copyWith(color: context.appThemes.greenVogue),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

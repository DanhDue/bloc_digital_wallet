// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/models/token_ui_model.dart';
import 'package:bloc_digital_wallet/generated/assets.gen.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';

class TokenItemView extends StatelessWidget {
  final TokenUiModel token;
  final VoidCallback? onTap;
  final bool balanceIsHidden;
  final bool isFirst;

  const TokenItemView({
    super.key,
    required this.token,
    this.onTap,
    this.balanceIsHidden = false,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: .only(top: 8),
        child: Row(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          mainAxisSize: .max,
          children: [
            // Coin Logo with Network Badge
            _buildCoinLogo(context, token.imageUrl),
            const SizedBox(width: 12),

            // Name and Percentage Change
            Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              mainAxisSize: .max,
              children: [
                Text(token.name, style: context.appThemes.titleMedium.copyWith(fontWeight: .w500)),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .center,
                  mainAxisSize: .max,
                  children: [
                    _buildTrendingIcon(context, token.isPositiveChange),
                    Text(
                      token.formattedPercentChange,
                      style: context.appThemes.bodySmall.copyWith(
                        color: !token.isPositiveChange
                            ? context.appThemes.errorColor
                            : context.appThemes.mainGreen,
                      ),
                      textAlign: .end,
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                  ],
                ),
              ],
            ),

            const Expanded(child: SizedBox.shrink()),

            // Balance and USD Estimate
            Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .end,
              mainAxisSize: .min,
              children: [
                Text(
                  balanceIsHidden ? context.t.myWalletHiddenBalance : token.formattedBalance,
                  style: context.appThemes.titleMedium.copyWith(fontWeight: .w500),
                ),
                const SizedBox(height: 2),
                Text(
                  balanceIsHidden ? context.t.myWalletHiddenBalance : token.formattedFiatBalance,
                  style: context.appThemes.bodySmall.copyWith(
                    color: context.appThemes.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinLogo(BuildContext context, String? logoUrl) {
    return Stack(
      children: [
        Padding(
          padding: const .only(top: 4),
          child: SizedBox(
            width: 36,
            height: 36,
            child: ClipRRect(
              borderRadius: .circular(100),
              child: logoUrl != null && logoUrl.isNotEmpty
                  ? CachedNetworkImage(
                      width: 36,
                      height: 36,
                      imageUrl: logoUrl,
                      fit: .cover,
                      placeholder: (context, url) =>
                          Container(color: context.appThemes.dividerColor),
                      errorWidget: (context, url, error) => Container(
                        color: context.appThemes.dividerColor,
                        child: Icon(
                          Icons.token,
                          size: 20,
                          color: context.appThemes.textSecondaryColor,
                        ),
                      ),
                    )
                  : Container(
                      color: context.appThemes.dividerColor,
                      child: Icon(
                        Icons.token,
                        size: 20,
                        color: context.appThemes.textSecondaryColor,
                      ),
                    ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: .circular(14),
            child: Assets.images.icSolana.svg(width: 12, height: 12, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingIcon(BuildContext context, bool isPositive) {
    final color = !isPositive ? context.appThemes.errorColor : context.appThemes.mainGreen;

    return Transform.rotate(
      angle: !isPositive ? 0 : 180 * pi / 180,
      child: Assets.images.icArrowAltLdown.svg(
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
      ),
    );
  }
}

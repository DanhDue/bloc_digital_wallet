// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/features/wallet/domain/entities/token_account_entity.dart';
import 'package:bloc_digital_wallet/generated/assets.gen.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';

class TokenItemView extends StatelessWidget {
  final TokenAccountEntity token;
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
    final mintToken = token.mintToken;
    final name = mintToken?.name ?? '';
    final symbol = mintToken?.symbol ?? '';
    final logoUrl = mintToken?.logo ?? '';
    final balance = token.amount ?? 0.0;
    // Placeholder for percentage change - not available in current entity
    const double? percentChange24h = null;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: .only(top: isFirst ? 0 : 8),
        child: Row(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          mainAxisSize: .max,
          children: [
            // Coin Logo with Network Badge
            _buildCoinLogo(context, logoUrl),
            const SizedBox(width: 12),

            // Name and Percentage Change
            Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              mainAxisSize: .max,
              children: [
                Text(name, style: context.appThemes.titleMedium.copyWith(fontWeight: .w500)),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .center,
                  mainAxisSize: .max,
                  children: [
                    _buildTrendingIcon(context, percentChange24h),
                    Text(
                      _formatPercentChange(percentChange24h),
                      style: context.appThemes.bodySmall.copyWith(
                        color: (percentChange24h?.isNegative ?? false)
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
                  balanceIsHidden
                      ? context.t.myWalletHiddenBalance
                      : _formatBalance(balance, symbol),
                  style: context.appThemes.titleMedium.copyWith(fontWeight: .w500),
                ),
                const SizedBox(height: 2),
                Text(
                  balanceIsHidden ? context.t.myWalletHiddenBalance : _formatUsdEstimate(balance),
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

  Widget _buildTrendingIcon(BuildContext context, double? percentChange) {
    final isNegative = percentChange?.isNegative ?? false;
    final color = isNegative ? context.appThemes.errorColor : context.appThemes.mainGreen;

    return Transform.rotate(
      angle: isNegative ? 0 : 180 * pi / 180,
      child: Assets.images.icArrowAltLdown.svg(
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
      ),
    );
  }

  String _formatPercentChange(double? percentChange) {
    if (percentChange == null) return '0.00%';
    final sign = percentChange.isNegative ? '' : '+';
    return '$sign${percentChange.toStringAsFixed(2)}%';
  }

  String _formatBalance(double balance, String symbol) {
    final formattedBalance = balance.toStringAsFixed(2);
    return '$formattedBalance $symbol';
  }

  String _formatUsdEstimate(double balance) {
    return '\$${balance.toStringAsFixed(2)}';
  }
}

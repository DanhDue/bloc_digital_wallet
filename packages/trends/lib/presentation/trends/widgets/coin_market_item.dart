// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trends/presentation/trends/models/coin_market_ui_model.dart';

/// Widget displaying a single coin market item in the trends list.
class CoinMarketItem extends StatelessWidget {
  final CoinMarketUiModel coin;
  final VoidCallback? onTap;
  final bool isFirst;

  const CoinMarketItem({super.key, required this.coin, this.onTap, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: colorScheme.surface,
        width: .infinity,
        padding: EdgeInsets.only(left: 16, right: 16, top: isFirst ? 0 : 12, bottom: 12),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            mainAxisSize: .min,
            children: [
              _buildLogo(context),
              const SizedBox(width: 12),
              Expanded(child: _buildCoinInfo(context)),
              const SizedBox(width: 12),
              _buildPriceInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return IntrinsicHeight(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: coin.logo?.isNotEmpty == true
            ? CachedNetworkImage(
                width: 42,
                height: 42,
                imageUrl: coin.logo ?? '',
                fit: .cover,
                placeholder: (context, url) => Container(
                  width: 42,
                  height: 42,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.currency_bitcoin, size: 24),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 42,
                  height: 42,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.currency_bitcoin, size: 24),
                ),
              )
            : Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                child: const Icon(Icons.currency_bitcoin, size: 24),
              ),
      ),
    );
  }

  Widget _buildCoinInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: .start,
      crossAxisAlignment: .start,
      mainAxisSize: .max,
      children: [
        Text(
          coin.symbol,
          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          textAlign: .start,
          maxLines: 1,
          overflow: .ellipsis,
        ),
        Text(
          _formatVolume(coin.volume24h),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          textAlign: .start,
          maxLines: 1,
          overflow: .ellipsis,
        ),
      ],
    );
  }

  Widget _buildPriceInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isNegative = coin.isPriceDown;

    return Column(
      mainAxisAlignment: .end,
      crossAxisAlignment: .end,
      mainAxisSize: .min,
      children: [
        Text(
          _formatPrice(coin.price),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
          textAlign: .end,
          maxLines: 1,
          overflow: .ellipsis,
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            mainAxisSize: .min,
            children: [
              Icon(
                isNegative ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                color: isNegative ? Colors.red : Colors.green,
                size: 16,
              ),
              Text(
                coin.priceChangeFormatted,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isNegative ? Colors.red : Colors.green,
                ),
                textAlign: .end,
                maxLines: 1,
                overflow: .ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatPrice(double? price) {
    if (price == null) return '\$0.00';
    if (price >= 1000) {
      return '\$${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  String _formatVolume(double? volume) {
    if (volume == null) return '\$0';
    if (volume >= 1e9) return '\$${(volume / 1e9).toStringAsFixed(2)}B';
    if (volume >= 1e6) return '\$${(volume / 1e6).toStringAsFixed(2)}M';
    if (volume >= 1e3) return '\$${(volume / 1e3).toStringAsFixed(2)}K';
    return '\$${volume.toStringAsFixed(2)}';
  }
}

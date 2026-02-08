// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:async';

import 'package:animated_visibility/animated_visibility.dart';
import 'package:core/utils/secure_clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ui_kit/ui_kit.dart';
// import 'package:wallet/generated/locales.g.dart'; // TODO: Enable when slang generated
import 'package:wallet/domain/entities/wallet_entity.dart';

class WalletItem extends StatefulWidget {
  final WalletEntity wallet;
  final int index;
  final VoidCallback? onTap;
  final bool isBalanceHidden;
  final bool isBalanceLoading;
  final VoidCallback? onToggleBalance;

  const WalletItem({
    super.key,
    required this.wallet,
    this.index = 0,
    this.onTap,
    this.isBalanceHidden = false,
    this.isBalanceLoading = false,
    this.onToggleBalance,
  });

  @override
  State<WalletItem> createState() => _WalletItemState();
}

class _WalletItemState extends State<WalletItem> {
  bool _showQRCode = false;
  QrImage? _qrImage;

  String get _walletAddress => widget.wallet.address ?? '';
  bool get _hasValidAddress => _walletAddress.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _generateQrImage();
  }

  @override
  void didUpdateWidget(WalletItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wallet.address != widget.wallet.address) {
      _generateQrImage();
    }
  }

  void _generateQrImage() {
    if (!_hasValidAddress) {
      _qrImage = null;
      return;
    }
    final qrCode = QrCode.fromData(data: _walletAddress, errorCorrectLevel: QrErrorCorrectLevel.H);
    _qrImage = QrImage(qrCode);
  }

  Timer? _qrTimer;

  void _toggleQRCode() {
    if (!_hasValidAddress) return; // Don't toggle if no valid address
    setState(() {
      _showQRCode = !_showQRCode;
    });
    _cancelQrTimer();
  }

  void _onCopyAddress() {
    if (!_hasValidAddress) return; // Don't copy if no valid address
    setState(() {
      _showQRCode = true;
    });
    _cancelQrTimer();
    SecureClipboard.copySensitive(text: _walletAddress);
    SmartDialog.showToast(
      "",
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: context.appThemes.ink60,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.images.icZeno.image(fit: BoxFit.cover, width: 24, height: 24),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Wallet address copied and will be cleared in 30 seconds", // t.walletList.copied
                    style: context.appThemes.bodyLarge.copyWith(color: context.appThemes.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    _qrTimer = Timer(const Duration(seconds: 30), () {
      Clipboard.setData(const ClipboardData(text: ''));
      if (mounted) {
        setState(() {
          _showQRCode = false;
        });
      }
    });
  }

  void _cancelQrTimer() {
    _qrTimer?.cancel();
    _qrTimer = null;
  }

  @override
  void dispose() {
    _cancelQrTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: _getGradientColors(context, widget.index),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Stack(
                children: [
                  Positioned(
                    right: 75,
                    child: Assets.images.icFingerPrint1.svg(height: 56, fit: BoxFit.cover),
                  ),
                  Positioned(
                    left: 26,
                    bottom: 0,
                    child: Assets.images.icFingerPrint2.svg(height: 56, fit: BoxFit.cover),
                  ),
                  Positioned(
                    right: 18,
                    bottom: 12,
                    child: Visibility(
                      visible: !_showQRCode,
                      maintainSize: true,
                      maintainState: true,
                      maintainAnimation: true,
                      child: GestureDetector(
                        onTap: _toggleQRCode,
                        child: Assets.images.icCardArrowDown.svg(height: 68, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Account ${widget.index + 1}", // t.walletList.account(index: widget.index + 1)
                          style: context.appThemes.titleMedium.copyWith(
                            color: context.appThemes.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Expanded(child: SizedBox.shrink()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Assets.images.icVerticalDots.svg(fit: BoxFit.cover, height: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        widget.isBalanceLoading
                            ? Shimmer.fromColors(
                                baseColor: context.appThemes.white.withValues(alpha: 0.4),
                                highlightColor: context.appThemes.white.withValues(alpha: 0.8),
                                child: Container(
                                  width: 196,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: context.appThemes.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              )
                            : Text.rich(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                TextSpan(
                                  text: "\$ ",
                                  style: context.appThemes.headlineMedium.copyWith(
                                    color: context.appThemes.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.isBalanceHidden
                                          ? "••••••••" // t.tokenList.hiddenBalance
                                          : (widget.wallet.balance ?? 0).toStringAsFixed(2),
                                      style: context.appThemes.headlineMedium.copyWith(
                                        color: context.appThemes.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: widget.onToggleBalance,
                          child: Icon(
                            widget.isBalanceHidden ? Icons.visibility : Icons.visibility_off,
                            color: context.appThemes.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Trend Info
                    widget.isBalanceLoading
                        ? Shimmer.fromColors(
                            baseColor: context.appThemes.white.withValues(alpha: 0.4),
                            highlightColor: context.appThemes.white.withValues(alpha: 0.8),
                            child: Container(
                              width: 169,
                              height: 20,
                              decoration: BoxDecoration(
                                color: context.appThemes.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color:
                                  (widget.isBalanceHidden ||
                                      ((widget.wallet.dailyChange ?? 0) >= 0) ||
                                      (widget.wallet.balance ?? 0) == 0)
                                  ? context.appThemes.indigo.withValues(alpha: 0.6)
                                  : context.appThemes.white.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                            child: Builder(
                              builder: (context) {
                                final balance = widget.wallet.balance ?? 0;
                                final dailyChange = widget.wallet.dailyChange ?? 0;
                                final isZeroBalance = balance == 0;
                                final isTrendUp = dailyChange >= 0;
                                final trendPercent = dailyChange.abs();
                                final trendAmount = balance * (trendPercent / 100);

                                final sign = isTrendUp ? "↑" : "↓";
                                final signChar = isTrendUp ? "+" : "-";
                                final trendColor = isTrendUp
                                    ? context.appThemes.trendUpColor
                                    : context.appThemes.errorColor;

                                return Text(
                                  widget.isBalanceHidden
                                      ? "••••••••"
                                      : (isZeroBalance
                                            ? "\$0.00 (0.00%)"
                                            : "$sign \$${trendAmount.toStringAsFixed(2)} ($signChar${trendPercent.toStringAsFixed(2)}%)"),
                                  style: context.appThemes.bodySmall.copyWith(
                                    color: (widget.isBalanceHidden || isZeroBalance)
                                        ? context.appThemes.white
                                        : trendColor,
                                  ),
                                );
                              },
                            ),
                          ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          _formatAddress(widget.wallet.address ?? ''),
                          style: context.appThemes.bodyLarge.copyWith(
                            color: context.appThemes.white.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: _onCopyAddress,
                          child: Icon(
                            Icons.copy,
                            color: context.appThemes.white.withValues(alpha: 0.7),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_qrImage != null)
          AnimatedVisibility(
            visible: _showQRCode && _hasValidAddress,
            enter: fadeIn(),
            exit: fadeOut(),
            enterDuration: const Duration(milliseconds: 500),
            child: GestureDetector(
              onTap: _toggleQRCode,
              child: Container(
                color: context.appThemes.white,
                width: 96,
                height: 96,
                margin: const EdgeInsets.only(right: 16, bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: PrettyAnimatedQrView(
                    qrImage: _qrImage!,
                    decoration: PrettyQrDecoration(
                      shape: PrettyQrSmoothSymbol(color: context.appThemes.black, roundFactor: 1),
                      image: PrettyQrDecorationImage(
                        image: Assets.images.icZeno.provider(),
                        opacity: 0.69,
                        position: PrettyQrDecorationImagePosition.embedded,
                      ),
                      background: context.appThemes.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<Color> _getGradientColors(BuildContext context, int index) {
    // Gradient cycling using AppThemes
    final gradients = [
      [context.appThemes.walletGradientBlueStart, context.appThemes.walletGradientBlueEnd],
      [context.appThemes.walletGradientPurpleStart, context.appThemes.walletGradientPurpleEnd],
      [context.appThemes.walletGradientGreenStart, context.appThemes.walletGradientGreenEnd],
    ];
    return gradients[index % gradients.length];
  }

  String _formatAddress(String address) {
    if (address.length < 10) return address;
    return '${address.substring(0, 8)}...${address.substring(address.length - 4)}';
  }
}

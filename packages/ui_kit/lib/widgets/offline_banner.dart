// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:core/services/network_connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ui_kit/theme/app_themes.dart';

/// Standalone ribbon banner indicating offline network status.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, this.message = 'Không có kết nối mạng', this.onRetry});

  /// The warning message displayed to the user.
  final String message;

  /// Optional callback invoked when the user taps "Thử lại" (Retry).
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final appThemes = Theme.of(context).extension<AppThemes>() ?? AppThemes.light;

    return Container(
      width: .infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: appThemes.errorColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (onRetry != null)
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Thử lại',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Standalone wrapper widget providing opt-in offline banner presentation with smooth transitions.
class OfflineBannerWrapper extends StatefulWidget {
  const OfflineBannerWrapper({
    super.key,
    required this.child,
    this.statusStream,
    this.offlineMessage,
    this.onRetry,
    this.banner,
  });

  /// The child widget to display within the layout.
  final Widget child;

  /// Optional network status stream. Defaults to [INetworkConnectivityService.onStatusChanged] via [GetIt].
  final Stream<NetworkStatus>? statusStream;

  /// Custom offline warning message.
  final String? offlineMessage;

  /// Optional retry callback when offline.
  final VoidCallback? onRetry;

  /// Optional custom banner widget to display when offline.
  final Widget? banner;

  @override
  State<OfflineBannerWrapper> createState() => _OfflineBannerWrapperState();
}

class _OfflineBannerWrapperState extends State<OfflineBannerWrapper> {
  StreamSubscription<NetworkStatus>? _subscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant OfflineBannerWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statusStream != widget.statusStream) {
      _subscription?.cancel();
      _subscribe();
    }
  }

  void _subscribe() {
    final stream =
        widget.statusStream ??
        (GetIt.I.isRegistered<INetworkConnectivityService>()
            ? GetIt.I<INetworkConnectivityService>().onStatusChanged
            : null);
    _subscription = stream?.listen(_onStatusChanged);
  }

  void _onStatusChanged(NetworkStatus status) {
    final offline = status == NetworkStatus.offline;
    if (_isOffline != offline && mounted) {
      setState(() {
        _isOffline = offline;
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bannerWidget = AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isOffline
              ? (widget.banner ??
                    OfflineBanner(
                      message: widget.offlineMessage ?? 'Không có kết nối mạng',
                      onRetry: widget.onRetry,
                    ))
              : const SizedBox.shrink(),
        );

        if (constraints.hasBoundedHeight) {
          return Column(
            children: [
              bannerWidget,
              Expanded(child: widget.child),
            ],
          );
        }

        return Column(mainAxisSize: MainAxisSize.min, children: [bannerWidget, widget.child]);
      },
    );
  }
}

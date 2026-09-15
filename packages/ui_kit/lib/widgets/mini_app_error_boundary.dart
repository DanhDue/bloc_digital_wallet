// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/theme/app_themes.dart';
import 'package:ui_kit/widgets/custom_filled_button.dart';
import 'package:ui_kit/widgets/custom_unfilled_button.dart';

/// Callback signature for reporting errors caught by the boundary.
typedef MiniAppErrorCallback = void Function(Object error, StackTrace stackTrace);

/// A crash-isolation boundary widget that intercepts unhandled runtime, build,
/// and rendering exceptions within its Mini App subtree.
///
/// Prevents the Flutter Red/Grey Screen of Death from crashing the entire
/// Super App Host Shell, keeping outer navigation (e.g. bottom navigation tabs)
/// fully functional.
class MiniAppErrorBoundary extends StatefulWidget {
  const MiniAppErrorBoundary({
    super.key,
    required this.child,
    this.moduleName,
    this.onGoHome,
    this.onRetry,
    this.onError,
    this.fallbackBuilder,
    this.devMode,
  });

  /// The child Mini App widget tree to protect.
  final Widget child;

  /// Optional name of the Mini App module (e.g. 'Scanner', 'Settings', 'Home').
  final String? moduleName;

  /// Callback executed when the user taps "Về Trang Chủ" (Go Home).
  final VoidCallback? onGoHome;

  /// Optional callback executed when user taps "Thử lại" (Retry).
  final VoidCallback? onRetry;

  /// Optional error reporting callback (e.g. for Sentry, Crashlytics, Talker).
  final MiniAppErrorCallback? onError;

  /// Optional custom fallback widget builder.
  final Widget Function(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
    VoidCallback retry,
  )?
  fallbackBuilder;

  /// Whether debug mode is enabled (defaults to [kDebugMode]).
  final bool? devMode;

  @override
  State<MiniAppErrorBoundary> createState() => MiniAppErrorBoundaryState();
}

class MiniAppErrorBoundaryState extends State<MiniAppErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;
  Key _childKey = UniqueKey();
  FlutterExceptionHandler? _previousHandler;

  /// Whether the boundary is currently displaying an error.
  bool get hasError => _error != null;

  /// The current error object, if any.
  Object? get error => _error;

  /// The current stack trace, if any.
  StackTrace? get stackTrace => _stackTrace;

  /// Whether dev mode is enabled.
  bool get isDebugMode => widget.devMode ?? kDebugMode;

  @override
  void initState() {
    super.initState();
    _setupErrorHandler();
  }

  @override
  void dispose() {
    _restoreErrorHandler();
    super.dispose();
  }

  void _setupErrorHandler() {
    _previousHandler = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (_isSubtreeError(details)) {
        _handleFlutterError(details);
      } else {
        _previousHandler?.call(details);
      }
    };
  }

  void _restoreErrorHandler() {
    if (FlutterError.onError != null) {
      FlutterError.onError = _previousHandler;
    }
  }

  bool _isSubtreeError(FlutterErrorDetails details) {
    final contextStr = details.context?.toString() ?? '';
    if (contextStr.contains('MiniAppErrorBoundary')) {
      return false;
    }
    return details.library == 'widgets library' || details.library == 'rendering library';
  }

  void _handleFlutterError(FlutterErrorDetails details) {
    _captureError(details.exception, details.stack ?? StackTrace.current);
  }

  void _captureError(Object error, StackTrace stackTrace) {
    _error = error;
    _stackTrace = stackTrace;
    widget.onError?.call(error, stackTrace);

    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _error != null) {
          setState(() {});
        }
      });
    }
  }

  /// Manually triggers an error state on this boundary.
  void triggerError(Object error, [StackTrace? stackTrace]) {
    _captureError(error, stackTrace ?? StackTrace.current);
    if (mounted) {
      setState(() {});
    }
  }

  /// Resets the error state, triggers [widget.onRetry], and attempts to re-mount the child.
  void retry() {
    widget.onRetry?.call();
    reset();
  }

  /// Resets the boundary state completely with a new [UniqueKey] to re-mount the child.
  void reset() {
    if (mounted) {
      setState(() {
        _error = null;
        _stackTrace = null;
        _childKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      if (widget.fallbackBuilder != null) {
        return widget.fallbackBuilder!(context, _error!, _stackTrace, retry);
      }
      return _buildDefaultFallback(context);
    }

    return KeyedSubtree(key: _childKey, child: widget.child);
  }

  Widget _buildDefaultFallback(BuildContext context) {
    final appThemes = Theme.of(context).extension<AppThemes>() ?? AppThemes.light;

    return Theme(
      data: Theme.of(context).copyWith(extensions: [appThemes]),
      child: Builder(
        builder: (themedContext) {
          final theme = themedContext.appThemes;
          final title = widget.moduleName != null
              ? 'Tính năng ${widget.moduleName} tạm thời gián đoạn'
              : 'Tính năng tạm thời gián đoạn';

          return Center(
            child: SingleChildScrollView(
              padding: const .symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .center,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: theme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                    textAlign: .center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Đã xảy ra lỗi không mong muốn trong quá trình xử lý. Vui lòng thử lại hoặc quay về trang chủ.',
                    style: theme.bodyMedium.copyWith(color: theme.ink60),
                    textAlign: .center,
                  ),
                  const SizedBox(height: 24),
                  CustomFilledButton(text: 'Thử lại', onPressed: retry, fullWidth: true),
                  const SizedBox(height: 12),
                  CustomUnfilledButton(
                    text: 'Về Trang Chủ',
                    onPressed: widget.onGoHome,
                    borderColor: theme.trueBlue,
                    textColor: theme.trueBlue,
                  ),
                  if (isDebugMode && _error != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.ink10,
                        borderRadius: .circular(8),
                        border: Border.all(color: theme.ink40),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: ExpansionTile(
                        tilePadding: const .symmetric(horizontal: 16),
                        title: Text(
                          'Chi tiết lỗi (Debug)',
                          style: theme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.errorColor,
                          ),
                        ),
                        children: [
                          Container(
                            width: .infinity,
                            padding: const .all(12),
                            color: theme.ink20,
                            child: SelectableText(
                              '$_error\n\nStack Trace:\n${_stackTrace ?? "No stack trace"}',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

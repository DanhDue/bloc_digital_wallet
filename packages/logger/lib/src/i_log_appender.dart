// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'log_record.dart';

/// A sink that receives dispatched [LogRecord]s from an `ILogManager`.
///
/// Concrete implementations (e.g. a console printer, Datadog, or an
/// OpenTelemetry exporter) live outside this package so `packages/logger`
/// itself never depends on a specific telemetry SDK.
abstract interface class ILogAppender {
  /// Stable identifier for this appender, used to enable/disable it
  /// individually (e.g. via configuration or remote flags).
  String get id;

  /// Whether this appender honors per-module logging toggles.
  ///
  /// When `false`, this appender receives every dispatched [LogRecord]
  /// regardless of whether the record's module has been toggled off.
  bool get respectsModuleToggle;

  /// Writes [record] to this appender's underlying destination.
  void append(LogRecord record);
}

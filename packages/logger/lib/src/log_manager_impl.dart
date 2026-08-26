// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'i_log_appender.dart';
import 'i_log_manager.dart';
import 'i_logger.dart';
import 'log_record.dart';
import 'logger_impl.dart';

/// Concrete [ILogManager]: routes each [LogRecord] to every registered
/// [ILogAppender], honoring the per-appender kill switch and the
/// per-module mute.
///
/// This class has no dependency on any concrete [ILogAppender]
/// implementation — it only ever talks to the [ILogAppender] interface, so
/// swapping/adding a telemetry backend never requires a change here.
///
/// **Dispatch order** (Epic HLD §4.1): for each registered appender, the
/// per-appender toggle (`appenderToggles[appender.id]`) is checked first —
/// this is a hard kill switch that applies regardless of module. Only if
/// the appender is enabled is the per-module toggle then considered, and
/// only for appenders that opt in via [ILogAppender.respectsModuleToggle];
/// an appender that doesn't respect module toggles always receives the
/// record once past the appender-level check. This ordering guarantees a
/// module muted for local debugging can never silently blind an appender
/// (e.g. Datadog) that ignores module toggles.
///
/// Both toggle maps default an unset entry to "enabled" (`true`).
class LogManagerImpl implements ILogManager {
  final List<ILogAppender> _appenders = <ILogAppender>[];
  final Map<String, ILogger> _loggers = <String, ILogger>{};
  final Map<String, bool> _moduleToggles = <String, bool>{};
  final Map<String, bool> _appenderToggles = <String, bool>{};

  @override
  ILogger getLogger(String module) {
    return _loggers.putIfAbsent(
      module,
      () => LoggerImpl(module, manager: this),
    );
  }

  @override
  void registerAppender(ILogAppender appender) {
    _appenders.add(appender);
  }

  @override
  void log(LogRecord record) {
    for (final appender in _appenders) {
      if (_shouldDispatch(record, appender)) {
        appender.append(record);
      }
    }
  }

  /// Whether [record] should be delivered to [appender], per the dispatch
  /// order documented on this class: appender kill switch first, then the
  /// module mute (only for appenders that respect it).
  bool _shouldDispatch(LogRecord record, ILogAppender appender) {
    if (!_isAppenderEnabled(appender.id)) {
      return false;
    }
    if (appender.respectsModuleToggle && !_isModuleEnabled(record.module)) {
      return false;
    }
    return true;
  }

  bool _isAppenderEnabled(String appenderId) =>
      _appenderToggles[appenderId] ?? true;

  bool _isModuleEnabled(String module) => _moduleToggles[module] ?? true;

  @override
  void setModuleEnabled(String module, bool enabled) {
    _moduleToggles[module] = enabled;
  }

  @override
  bool isModuleEnabled(String module) => _isModuleEnabled(module);

  @override
  void setAppenderEnabled(String appenderId, bool enabled) {
    _appenderToggles[appenderId] = enabled;
  }
}

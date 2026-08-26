// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:logger/d3nexus_logger.dart';
import 'package:talker_flutter/talker_flutter.dart' hide LogLevel;

import 'appenders/datadog_appender.dart';
import 'appenders/otel_appender.dart';
import 'appenders/talker_appender.dart';

/// Determines which [ILogAppender]s to register with `D3NexusLogger` for
/// the current environment.
///
/// Development registers only [TalkerAppender] (local console/dev-tools
/// debugging). Staging and production additionally register
/// [DatadogAppender] and [OtelAppender] for production telemetry -- see
/// the epic HLD's phased rollout. Extracted as a standalone function
/// (rather than inlined in `LoggingInitializer.init()`) so this
/// environment decision is directly unit-testable without exercising
/// DI/bootstrap.
List<ILogAppender> appendersForEnvironment(Talker talker, {required bool isDevelopment}) {
  final appenders = <ILogAppender>[TalkerAppender(talker)];
  if (!isDevelopment) {
    appenders
      ..add(DatadogAppender(const NoopDatadogLogClient()))
      ..add(OtelAppender(const NoopOtelSpanClient()));
  }
  return appenders;
}

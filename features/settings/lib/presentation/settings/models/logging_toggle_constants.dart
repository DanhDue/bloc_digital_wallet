// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

/// Known module names offered as toggle rows in the Settings "Module
/// Logging" section.
///
/// `packages/logger` has no module registry of its own — the persisted
/// toggle map only ever stores explicit overrides for keys the UI itself
/// offers. This list is illustrative/extensible, not exhaustive: any
/// module NOT in this list still defaults to enabled in `LogManagerImpl`'s
/// dispatch logic (`?? true`) regardless of what the UI shows here. Names
/// match this monorepo's package/feature names — the same `<Module>` names
/// used when migrating real call sites to `D3NexusLogger.getLogger`.
const List<String> kKnownLoggingModules = [
  'App',
  'Core',
  'Framework',
  'Network',
  'Scanner',
  'Settings',
];

/// Known appender ids, offered as toggle rows in the Settings
/// "Telemetry"/Advanced section.
///
/// These are exactly the three appender ids registered by
/// `appendersForEnvironment` (Task 4): the local Talker debug console and
/// the two remote telemetry backends. Unlike [kKnownLoggingModules], this
/// list is exhaustive — every appender the app can register is represented
/// here, since disabling one is a production-impacting kill switch, not a
/// debug convenience.
const List<String> kKnownLogAppenderIds = ['talker', 'datadog', 'otel'];

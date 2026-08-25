# Logging Module (D3NexusLogger) — Design Spec

## Status
Approved — ready for epic-designer.

## Background
The current logging system (`packages/core/lib/utils/log.dart`) is a static `Log` wrapper hard-coupled to `talker_flutter`, with `talker_dio_logger`/`talker_bloc_logger` pulled into `packages/network`. This creates four concrete problems:

1. Switching or adding a telemetry backend (Datadog, OpenTelemetry) requires touching `packages/core` directly.
2. There is no per-module control — every log from every feature dumps into one Talker screen.
3. Log records carry no correlation beyond a bare message, so a developer cannot reconstruct the causal sequence of steps behind one user action or API call.
4. Native platform code (e.g. `packages/native_security`'s Swift plugin) has no path to push logs into the Flutter debug console, and there's no way to keep that plumbing out of modules that have no native code at all.

An earlier draft epic (`.devtool/epic/logging_refactor/`) explored this space and got the general shape right (pluggable core, module toggles, a native bridge package) but its concrete diagram coupled the core logic manager directly to `TalkerAppender`/`DataDogAppender`/`OtelAppender`, which would have broken the "swap BE without touching core" goal in practice. This spec supersedes that draft; the existing epic and its task files will be rewritten from scratch, not incrementally patched.

## Goals
- A pure-Dart logging core (`packages/logger`) with zero dependency on any concrete telemetry SDK (Talker, Datadog, Otel).
- Per-module enable/disable at runtime, without needing a rebuild.
- Per-appender (per-backend) enable/disable at runtime, independent of module toggles.
- Trace-able causal sequence across log records (not just a shared ID, but parent/child ordering), reusable both in the in-app debug UI and by real APM backends.
- A separate, strictly opt-in native bridge package so modules without native platform code never pay for it.

## Non-Goals
- Local file-based log persistence (Datadog SDK's own offline caching covers this).
- Changing wallet/business logic.
- Building a full in-app trace timeline visualization UI (out of scope for this epic; the tree-reconstruction helper is built as a pure, reusable function, but wiring it into a rich visual timeline screen is not).

## Architecture

```
packages/logger                    Pure Dart. No dependency on talker/datadog/otel.
  ├── LogRecord   { level, module, message, error, stackTrace, timestamp,
  │                 traceId, spanId, parentSpanId }
  ├── ILogAppender { String get id; bool get respectsModuleToggle; append(LogRecord) }
  ├── ILogManager  { log(record); registerAppender(appender);
  │                  setModuleEnabled(module, bool); setAppenderEnabled(appenderId, bool) }
  ├── ILogger      { d/i/w/e/v(message, {error, stackTrace}); withSpan({parentSpanId}) }
  ├── buildTraceTree(List<LogRecord>) -> List<TraceNode>   // pure function
  └── D3NexusLogger (static facade) — initialize(manager), getLogger(module)

lib/logging/appenders/             App layer. Each implements ILogAppender and owns its
  ├── talker_appender.dart           own SDK dependency (talker_flutter, datadog SDK, otel SDK).
  ├── datadog_appender.dart          packages/logger never imports any of these.
  └── otel_appender.dart

packages/logger_native_bridge      Pure Dart + Pigeon. Depends only on packages/logger.
                                    Opt-in: only modules that ship real native platform code
                                    (e.g. packages/native_security) add this as a dependency
                                    and register the channel from their own native side.
```

Key architectural decision: concrete appenders (Talker/Datadog/Otel) live in the **app layer**, registered into `D3NexusLogger` via DI at bootstrap — not inside `packages/logger` and not as separate pub packages each. `ILogAppender` is the boundary that delivers "swap backend without touching core"; splitting each appender into its own package would add pubspec/melos/CI overhead without adding any isolation the interface doesn't already provide, given this is a single-app monorepo (not a multi-app shared-package scenario).

### Dispatch logic (module toggle + appender toggle combined)

```
LogManagerImpl.log(record):
  for appender in appenders:
    if !appenderToggles[appender.id]:                          skip   # backend fully disabled
    if moduleToggles[record.module] == false
       && appender.respectsModuleToggle:                        skip   # debug-only mute
    appender.append(record)
```

- `TalkerAppender.respectsModuleToggle = true` — module mute suppresses it from the local debug screen.
- `DatadogAppender` / `OtelAppender`.`respectsModuleToggle = false` — module mute never blinds production telemetry; only `setAppenderEnabled(id, false)` (an explicit, separate control) can stop them.

## Module Enable/Disable
- `LogManagerImpl` holds `Map<String, bool> moduleToggles`, default `true`.
- `D3NexusLogger.setModuleEnabled('Wallet', false)` checked per-appender as above.
- Persisted via `packages/settings` under key `logging.module_toggles`, loaded at bootstrap before `D3NexusLogger.initialize()`. Exposed in a Settings screen (module-level switches, aimed at QA/Dev debug convenience).

## Appender (Backend) Enable/Disable
- `LogManagerImpl` holds a separate `Map<String, bool> appenderToggles`, keyed by `ILogAppender.id` (`'talker'`, `'datadog'`, `'otel'`).
- `D3NexusLogger.setAppenderEnabled('datadog', false)` — a full kill switch per backend, independent of module toggles. Use cases: disable Datadog during local/QA runs to avoid polluting dashboards or burning quota; disable a backend at runtime if its ingestion is degraded, without a release.
- Default registration is environment-driven (e.g. dev registers only `TalkerAppender`; staging/prod also register `DatadogAppender`/`OtelAppender`), but `appenderToggles` can override this at runtime.
- Persisted separately, key `logging.appender_toggles`. Surfaced in an "Advanced/Telemetry" section of Settings, kept visually distinct from the per-module debug toggles since it affects production monitoring, not just local noise.

## Trace/Sequence Design
- Every `LogRecord` carries `traceId` (one per logical flow/request), `spanId` (one per step), and `parentSpanId` (the step that caused this one) — the W3C Trace Context / OpenTelemetry span model.
- `ILogger.withSpan({parentSpanId})` returns a child `ILogger` that auto-stamps a new `spanId` with `parentSpanId` set to the current span, so nested log calls inside one operation (a BLoC event handler, a repository call, a use case) don't need traceId/spanId threaded through manually.
- At the network boundary, the Dio interceptor in `packages/network` (already home to `talker_dio_logger`) injects a standard `traceparent` header built from the active traceId/spanId — if the backend is later instrumented with an APM/Otel collector, the trace continues server-side using the same span model.
- `buildTraceTree(List<LogRecord>) -> List<TraceNode>` in `packages/logger` is a pure, unit-testable function that reconstructs the call tree for a given traceId from spanId/parentSpanId relationships. The Talker adapter uses it to render an indented/tree view when a developer filters the debug screen by traceId, instead of relying on timestamp ordering alone.

## Native Bridge
- `packages/logger_native_bridge`: Pigeon schema defines `NativeLogMessage { level, tag, message, traceId? }` with a `@FlutterApi()` for native → Dart calls.
- Kotlin/Swift side gets a small static utility (`D3NexusNativeLogger.d(tag, message)`) that native module code calls directly; it's forwarded through Pigeon into `D3NexusLogger.getLogger('Native:$tag')`.
- Strictly opt-in: only a module that actually ships native platform code (confirmed example: `packages/native_security`, which has `ios/Classes/NativeSecurityPlugin.swift`) adds `logger_native_bridge` to its own `pubspec.yaml` and registers the channel from its own native side. The root app and pure-Dart modules (`wallet`, `home`, `trends`, etc.) never depend on it.

## Rollout Strategy
1. Build and unit-test `packages/logger` fully in isolation (`LogManagerImpl` dispatch logic, `buildTraceTree`, `LogRecord`).
2. Mark the existing `Log` (`packages/core/lib/utils/log.dart`) `@Deprecated` and have it delegate to `D3NexusLogger` internally, so existing call sites keep working unmodified.
3. On a dedicated branch, refactor all existing call sites (`Log.d/i/w/e`, ~10 today) to `D3NexusLogger.getLogger(module).d/i/w/e`.
4. Remove the old `Log` wrapper and move `talker_flutter`/`talker_dio_logger`/`talker_bloc_logger` dependencies out of `packages/core`/`packages/network` and into the app-layer appenders.

**Rollback**: each phase is independently revertible; Phase 2's delegation shim means Phase 3/4 can be rolled back without touching call sites again.

## Testing
- Unit tests: `LogManagerImpl` dispatch logic (module toggle × appender toggle matrix), `buildTraceTree`, `LogRecord` construction, `withSpan` parent/child stamping.
- Widget test: Settings module-toggle UI and Advanced/Telemetry appender-toggle UI.
- Native bridge: Pigeon-generated channel tested via platform-mocked method channel calls on both Android and iOS.

## Open Items for epic-designer
- Task breakdown must fully replace `.devtool/epic/logging_refactor/` (overview + all 7 task files) rather than append to it, per the "rewrite from scratch" decision above — English-only task files, each with the full required section set (including Epic Reference link and Relevant Files & Context Pointers, currently missing from the old draft).

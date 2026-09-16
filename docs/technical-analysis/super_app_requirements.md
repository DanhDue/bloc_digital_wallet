# Super App Requirements & Implementation Status

> **Purpose:** Maps the 4-Pillar Super App Governance Framework to concrete implementations
> in `bloc_digital_wallet`. Use this as an onboarding map and progress tracker.
>
> **Legend:** ✅ Implemented · 🔄 In Progress · 📋 Planned · ❌ Not Applicable (Flutter ecosystem)

---

## The 4-Pillar Governance Framework

A Super App platform requires governance across four core pillars plus supporting operational domains.
The table below maps each pillar and domain to the Flutter-adapted implementation in this monorepo.

---

## Pillar 1: Decomposed Architecture (Container & Modules)

**Principle:** The host app is a thin container. Mini Apps are independently deployable
modules with no direct cross-module imports.

| # | Requirement | Flutter Adaptation | Status | Reference |
|---|-------------|--------------------|--------|-----------|
| 1.1 | Host App as thin container (auth, network, storage only) | `lib/` (host) + `features/shell/` owns composition root, tabs, navigation | ✅ Implemented | `packages/platform/` |
| 1.2 | Mini Apps as independent, lazy-loadable modules | Dart packages in `features/` — no Dynamic Feature Modules (not available in Flutter) | ✅ Implemented | `features/wallet/`, `features/transaction/`, etc. |
| 1.3 | Zero direct cross-feature imports | `check_module_boundaries.sh` CI gate enforces this | ✅ Implemented | `scripts/check_module_boundaries.sh` |
| 1.4 | DI export discipline (no `*_impl.dart` barrel exports) | Barrels export domain/presentation only — enforced by CI | ✅ Implemented | `scripts/check_module_boundaries.sh` |
| 1.5 | Feature packages scaffolded consistently | `mason make pac_mvi_feature` / `pac_mvi_subfeature` bricks | ✅ Implemented | `bricks/pac_mvi_feature/` |

---

## Pillar 2: Centralized Communication & Routing

**Principle:** Modules communicate only through typed contracts, never by direct import.
All routing is centralized — modules are "blind" to each other.

| # | Requirement | Flutter Adaptation | Status | Reference |
|---|-------------|--------------------|--------|-----------|
| 2.1 | DeepLink Router Engine (modules register routes, host resolves) | `DeepLinkCoordinator` (Host) + `DeepLinkParser` & `DeepLinkRegistry` (`packages/platform/`) — lifecycle timing buffer, cold/warm start staging | ✅ Implemented | `lib/deeplink/deep_link_coordinator.dart`, `packages/platform/lib/deeplink/deep_link_parser.dart` |
| 2.2 | Blind cross-module navigation (no direct page imports) | `DeepLinkRoutes` with typed `PageRouteInfo` (`packages/platform/`) + `DeepLinkNavigator` (Host) — routes by path without direct feature imports | ✅ Implemented | `packages/platform/lib/deeplink/deep_link_routes.dart`, `lib/deeplink/deep_link_navigator.dart` |
| 2.3 | Typed cross-feature event bus (no setState/callback coupling) | `AppEventBus` in `packages/platform/` with reactive broadcast streams (`on<T>()`, `fire()`) | ✅ Implemented | `packages/platform/lib/app_event_bus.dart` |
| 2.4 | Native OS deep link handling (Android App Links / iOS Universal Links) | `app_links` integration + `AndroidManifest.xml` (Custom Schemes `d3nexus://`, `d3nexusshield://` & App Links `https://app.d3nexus.com/`) + `Info.plist` (`CFBundleURLSchemes`) | ✅ Implemented | `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist` |
| 2.5 | Auth Guard for protected routes | `DeepLinkAuthGuard` — intercepts protected routes when unauthenticated, buffers pending payload, and resumes upon `LoginSuccessEvent` | ✅ Implemented | `lib/deeplink/deep_link_auth_guard.dart` |

---

## Pillar 3: State Isolation

**Principle:** Each Mini App manages its own state. No shared mutable global state.

| # | Requirement | Flutter Adaptation | Status | Reference |
|---|-------------|--------------------|--------|-----------|
| 3.1 | Per-feature local state (no shared global store) | MVI/BLoC scoped per feature via `BlocProvider` | ✅ Implemented | All `features/*/presentation/` |
| 3.2 | Layered DI (host registers singletons, features use scoped factories) | GetIt + Injectable: `@injectable` BLoCs, `@LazySingleton` repositories | ✅ Implemented | `packages/core/lib/di/` |
| 3.3 | Immutable state contracts | `sealed class XxxState` + `Equatable` / `@freezed` models | ✅ Implemented | All feature BLoCs |
| 3.4 | No Flutter imports in Domain layer | Enforced by `melos analyze` + architecture audit skill | ✅ Implemented | `features/*/domain/` |

---

## Pillar 4: Lifecycle Governance (CI/CD)

**Principle:** The platform enforces architectural rules automatically. No manual
review required for boundary violations.

| # | Requirement | Flutter Adaptation | Status | Reference |
|---|-------------|--------------------|--------|-----------|
| 4.1 | Sandbox development (features buildable standalone) | Each `features/*/` is a runnable Dart package; `pac_mvi_feature` sets up standalone entry | ✅ Implemented | `bricks/pac_mvi_feature/` |
| 4.2 | Module boundary CI gate | `check_module_boundaries.sh` runs on CI — blocks cross-feature imports | ✅ Implemented | `scripts/check_module_boundaries.sh` |
| 4.3 | License header enforcement | `check_license_header.sh` on CI | ✅ Implemented | `scripts/check_license_header.sh` |
| 4.4 | Static analysis gate (zero warnings) | `melos run analyze` — must exit 0 | ✅ Implemented | `melos.yaml` |
| 4.5 | Code generation pipeline (incremental + full) | `melos genAlls` / `melos genFeature` / `genChanged.sh` | ✅ Implemented | `scripts/genAlls.sh` |
| 4.6 | AI-driven development workflow (tri-platform) | `/epic-lifecycle` skill: brainstorming → epic-designer → epic-implementation → quality_check | ✅ Implemented | `.agents/skills/` |

---

## 5. Resilience & Fault Tolerance Requirements

**Principle:** The app remains stable under network loss, unhandled exceptions, and concurrency spikes.

| # | Requirement | Flutter Adaptation | Status | Reference |
|---|-------------|--------------------|--------|-----------|
| 5.1 | OOM prevention (image memory cap) | `AppCachedImage` — downsampling + RAM cap + `evictFromCache()` on dispose | ✅ Implemented | `packages/ui_kit/lib/app_cached_image/` |
| 5.2 | Mini App crash isolation | `MiniAppErrorBoundary` — catches errors per-feature, shows fallback UI | ✅ Implemented | `packages/ui_kit/lib/mini_app_error_boundary/` |
| 5.3 | OS memory pressure handling | `MemoryPressureObserver` — `didReceiveMemoryWarning` + `onTrimMemory` | ✅ Implemented | `packages/core/lib/memory/` |
| 5.4 | Offline awareness | `NetworkConnectivityService` + `OfflineBanner` widget | ✅ Implemented | `packages/core/lib/network/` |
| 5.5 | Token refresh concurrency (Mutex lock) | `Mutex`-guarded refresh in `AuthInterceptor` — prevents duplicate refresh calls | ✅ Implemented | `packages/core/lib/auth/auth_interceptor.dart` |

---

## 6. Logging & Observability Requirements

**Principle:** Logs are pluggable, structured, per-module toggleable, and work without a Flutter Engine.

| # | Requirement | Flutter Adaptation | Status | Reference |
|---|-------------|--------------------|--------|-----------|
| 6.1 | Pluggable logging backend (swap without touching core) | `D3NexusLogger` + `LogAppender` interface + DI-registered backends | 📋 Planned | `epic: logging_refactor` |
| 6.2 | Structured log levels (verbose/debug/info/warning/error/fatal) | `LogLevel` enum + `LogEntry` model | 📋 Planned | `epic: logging_refactor` |
| 6.3 | Per-module logging toggles | `LogManager.setModuleLevel(module, level)` | 📋 Planned | `epic: logging_refactor` |
| 6.4 | Headless native logging (no Flutter Engine required) | `LoggerNativeBridge` — Kotlin WorkManager + Swift BGTaskScheduler | 📋 Planned | `epic: logging_refactor` |
| 6.5 | W3C Trace Context propagation (distributed tracing) | `traceparent` header injection via `NetworkTracing` interceptor | 📋 Planned | `epic: logging_refactor` |
| 6.6 | Remote log appender (Crashlytics / Datadog) | `CrashlyticsAppender` / `DatadogAppender` implementations | 📋 Planned | `epic: logging_refactor` |

---

## 7. Native Plugin Requirements (Tri-Platform Parity)

**Principle:** Native plugins run without a Flutter Engine. Android and iOS implementations
are symmetric. Mason bricks scaffold the full tri-platform structure.

| # | Requirement | Flutter Adaptation | Status | Reference |
|---|-------------|--------------------|--------|-----------|
| 7.1 | Android headless plugin (no Flutter Engine) | Pure Dagger2 + WorkManager — zero Flutter dependency | ✅ Implemented | `packages/logger_native_bridge/android/` |
| 7.2 | iOS headless plugin (no Flutter Engine) | FactoryKit + BGTaskScheduler — zero Flutter dependency | ✅ Implemented | `packages/logger_native_bridge/ios/` |
| 7.3 | Android native UI (Jetpack Compose) | `pac_add_native_ui` brick adds Compose Activity/Fragment | ✅ Implemented | `bricks/pac_add_native_ui/` |
| 7.4 | iOS native UI (SwiftUI) | `pac_add_native_ui` brick adds SwiftUI View | ✅ Implemented | `bricks/pac_add_native_ui/` |
| 7.5 | Mason brick generation for native plugins | `mason make pac_native_plugin --name <name> --has_ui <bool>` | ✅ Implemented | `bricks/pac_native_plugin/` |
| 7.6 | MethodChannel contract (Flutter ↔ Native) | Auto-generated by `pac_native_plugin` brick | ✅ Implemented | `bricks/pac_native_plugin/` |

---

## 8. Template & Developer Experience Requirements

**Principle:** A new project can be created from the template in one command. The template
is self-documenting and AI-agent-navigable.

| # | Requirement | Flutter Adaptation | Status | Reference |
|---|-------------|--------------------|--------|-----------|
| 8.1 | Dual-Mode template (Enterprise 3-tab / Lean 2-tab) | `configure_mode.sh enterprise\|lean` + `rename_project.sh` | ✅ Implemented | `scripts/rename_project.sh` |
| 8.2 | One-command project rename | `./scripts/rename_project.sh "App Name" app_id com.bundle.id` | ✅ Implemented | `scripts/rename_project.sh` |
| 8.3 | Feature scaffolding (Mason bricks) | `pac_mvi_feature`, `pac_mvi_subfeature`, `pac_library` | ✅ Implemented | `bricks/` |
| 8.4 | Native plugin scaffolding (Mason bricks) | `pac_native_plugin`, `pac_add_native_ui` | ✅ Implemented | `bricks/` |
| 8.5 | AI-agent workflow documentation | `.agents/` skills + `docs/` — agent-navigable structure | ✅ Implemented | `.agents/`, `docs/` |
| 8.6 | OTA localization via Slang (type-safe) | `slang.yaml` + `melos genAlls` regenerates type-safe keys | ✅ Implemented | `packages/core/assets/i18n/` |
| 8.7 | Settings: Language + Dark Mode | Feature package `features/settings/` — BLoC-driven, persisted via Hive | ✅ Implemented | `features/settings/` |
| 8.8 | SecureFiles provisioning for CI/CD | `scripts/secrets_ops.sh encode\|decode` + `SECURE_FILES` env var | ✅ Implemented | `scripts/secrets_ops.sh` |

---

## 9. Super App Governance & Boundary Enforcement (SGR)

**Principle:** Ranh giới giữa các Mini App được bảo vệ tự động ở cấp độ AST và quy chuẩn kiến trúc.

| # | Requirement | Flutter Adaptation | Status | Reference |
|---|-------------|--------------------|--------|-----------|
| 9.1 | SGR-01: Module boundary AST verification script | `scripts/check_module_boundaries.sh` quét AST chặn 100% cross-feature import | ✅ Implemented | `scripts/check_module_boundaries.sh` |
| 9.2 | SGR-02: Zero direct cross-module imports | Cô lập hoàn toàn các gói trong `features/*`, chỉ phụ thuộc vào `packages/*` | ✅ Implemented | `features/*/pubspec.yaml` |
| 9.3 | SGR-03: Centralized deep link schema validation | `DeepLinkParser` + `DeepLinkRegistry` chuẩn hóa URI, trích xuất params, fallback an toàn về Home | ✅ Implemented | `packages/platform/lib/deeplink/` |
| 9.4 | SGR-04: Stateless cross-module event bus | `AppEventBus` truyền thông điệp bất đồng bộ không gây kết hợp state | ✅ Implemented | `packages/platform/lib/app_event_bus.dart` |
| 9.5 | SGR-05: Dual-Mode build & runtime configuration | `scripts/configure_mode.sh` chuyển đổi nhanh giữa Lean (3 apps) và Enterprise (10 apps) | ✅ Implemented | `scripts/configure_mode.sh` |

---

## 10. Memory Management & Resource Governance (MMR)

**Principle:** Ngăn chặn tuyệt đối Out-of-Memory (OOM) và kiểm soát rò rỉ tài nguyên khi chạy đồng thời nhiều Mini App.

| # | Requirement | Flutter Adaptation | Status | Reference |
|---|-------------|--------------------|--------|-----------|
| 10.1 | MMR-01: Global ImageCache capping (25% heap) | Cấu hình trần cứng `maximumSizeBytes = 50MB` trong `PaintingBinding.instance.imageCache` | 📋 Planned | `docs/technical-analysis/flutter_production_roadmap.vi.md` |
| 10.2 | MMR-02: Strict decode downsampling in UI Kit | Ép buộc truyền `memCacheWidth` & `memCacheHeight` trong `AppCachedNetworkImage` | 📋 Planned | `packages/ui_kit/lib/widgets/app_cached_image.dart` |
| 10.3 | MMR-03: System low-memory event propagation | `WidgetsBindingObserver.didHaveMemoryPressure` dispatch `LowMemoryEvent` qua `AppEventBus` | 📋 Planned | `docs/technical-analysis/flutter_production_roadmap.vi.md` |
| 10.4 | MMR-04: Background feature resource purging | Tự động hủy cache in-memory và unmount state khi Mini App chuyển sang background | 📋 Planned | `docs/technical-analysis/flutter_production_roadmap.vi.md` |
| 10.5 | MMR-05: Stream & Controller disposal discipline | 100% StreamSubscriptions và Controllers phải được đóng trong `close()` / `dispose()` | ✅ Implemented | Code Health Audit Skill |

---

## 11. Dynamic Delivery & OTA Localization (OTA)

**Principle:** Cập nhật động tài nguyên và bản dịch tuân thủ nghiêm ngặt chính sách Apple App Store & Google Play.

| # | Requirement | Flutter Adaptation | Status | Reference |
|---|-------------|--------------------|--------|-----------|
| 11.1 | OTA-01: Slang OTA dynamic translation bundle | Tải gói JSON bản dịch từ xa và hot-swap qua Slang Engine mà không cần build lại | ✅ Implemented | `packages/core/assets/i18n/` |
| 11.2 | OTA-02: Remote asset caching & eviction policy | Quản lý banner, icon, SVG từ xa với giới hạn disk cache và TTL xóa tự động | ✅ Implemented | `packages/ui_kit/` |
| 11.3 | OTA-03: Apple App Store Guideline 2.5.2 compliance | Biên dịch thuần AOT single binary; cấm thực thi dynamic executable bytecode | ✅ Implemented | Kiến trúc chuẩn AOT |
| 11.4 | OTA-04: Graceful offline degraded operation | Khi mất kết nối mạng, tài nguyên động tự động fallback về asset nội bộ | 🔄 In Progress | `NetworkConnectivityService` |

---

## Implementation Summary

| Pillar / Domain | Total Reqs | ✅ Done | 🔄 In Progress | 📋 Planned |
|-----------------|:---------:|:-------:|:--------------:|:----------:|
| Pillar 1: Decomposed Architecture | 5 | 5 | 0 | 0 |
| Pillar 2: Communication & Routing | 5 | 5 | 0 | 0 |
| Pillar 3: State Isolation | 4 | 4 | 0 | 0 |
| Pillar 4: Lifecycle Governance | 6 | 6 | 0 | 0 |
| Domain 5: Resilience & Fault Tolerance | 5 | 5 | 0 | 0 |
| Domain 6: Logging & Observability | 6 | 0 | 0 | 6 |
| Domain 7: Native Plugin Parity | 6 | 6 | 0 | 0 |
| Domain 8: Template & DX | 8 | 8 | 0 | 0 |
| Domain 9: Super App Governance (SGR) | 5 | 5 | 0 | 0 |
| Domain 10: Memory Management (MMR) | 5 | 2 | 0 | 3 |
| Domain 11: Dynamic Delivery & OTA (OTA) | 4 | 3 | 1 | 0 |
| **TOTAL** | **59** | **49** | **1** | **9** |

**Overall completion: 83.1% (49/59 requirements implemented, 1 in progress, 9 planned)**

---

## Active Epics

| Epic | Status | Unblocks Requirements |
|------|--------|-----------------------|
| `super_app_roadmap` | 🔄 In Progress | Domains 10, 11: MMR-01..05, OTA-01..04 |
| `deeplink_router_engine` | ✅ Implemented | Pillar 2: Req 2.1–2.5, SGR-03 (All Completed) |
| `logging_refactor` | 📋 Planned | Logging: Req 6.1–6.6 |

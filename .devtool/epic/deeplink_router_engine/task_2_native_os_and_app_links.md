---
id: "task_2_native_os_and_app_links"
status: "done"
priority: "high"
assignee: null
epic: "deeplink_router_engine"
dueDate: null
created: "2026-09-11T01:58:25+07:00"
modified: "2026-09-11T02:20:20+07:00"
completedAt: "2026-09-11T02:20:20+07:00"
labels: ["architecture", "android", "ios", "native", "infrastructure"]
order: "a2"
---

# Task 2: Native OS Configuration & AppLinks Integration

Epic: [deeplink_router_engine](../epic/deeplink_router_engine/deeplink_router_engine.en.md)

## Requirement Analysis
The Host application must be configured at the operating system level to intercept both Custom URL Schemes and Universal/App Links, delegating them to Flutter runtime via the `app_links` plugin.

Key Requirements:
1. Add `app_links: ^6.3.4` (or latest compatible) to root `pubspec.yaml` dependencies.
2. Configure Android `AndroidManifest.xml`:
   - Set `android:launchMode="singleTask"` on `MainActivity` to prevent spawning duplicate Activity instances when handling deep links.
   - Add intent-filter for Custom Scheme: `<data android:scheme="d3nexus" />`.
   - Add intent-filter for App Links: `<data android:scheme="https" android:host="app.d3nexus.com" />` with `android:autoVerify="true"`.
3. Configure iOS `Info.plist` & Entitlements:
   - Add `CFBundleURLTypes` specifying `CFBundleURLSchemes` with `d3nexus`.
   - Configure `ios/Runner/Runner.entitlements` with Associated Domains: `applinks:app.d3nexus.com`.
4. Verify Android and iOS build configs compile cleanly without Gradle/Pod conflicts.

## Relevant Files & Context Pointers
- `pubspec.yaml` — Root app dependencies.
- `android/app/src/main/AndroidManifest.xml` — Android manifest declaring intent filters and singleTask launchMode.
- `ios/Runner/Info.plist` — iOS property list declaring URL types.
- `ios/Runner/Runner.entitlements` — iOS associated domains entitlement.

## Design Rationale
- **SingleTask Launch Mode:** Without `singleTask`, tapping a deep link when the app is already in the background creates a new Activity stack on Android, wiping out user state or duplicating screens.
- **TDD Adaptation:** This is an OS manifest, entitlements, and package dependency integration task. TDD (RED/GREEN/REFACTOR) does not apply directly to XML/plist markup. In its place, the verifiable steps are: configure declarations, run `flutter pub get`, execute Gradle assemble dry-run, and verify XML/plist syntax validity.

## Implementation Steps & Verification Checklist
- [ ] **Dependency Setup**:
  - Add `app_links` to `pubspec.yaml` under `dependencies:`.
  - Run `flutter pub get` and verify dependency resolution across workspace.
- [ ] **Android Configuration**:
  - Update `android/app/src/main/AndroidManifest.xml`:
    - Ensure `android:launchMode="singleTask"`.
    - Add custom scheme intent-filter (`d3nexus`).
    - Add HTTPS App Links intent-filter (`app.d3nexus.com`).
  - Run `./gradlew :app:assembleStgDebug` to verify Android build passes.
- [ ] **iOS Configuration**:
  - Update `ios/Runner/Info.plist` with `CFBundleURLTypes`.
  - Ensure `ios/Runner/Runner.entitlements` exists with `applinks:app.d3nexus.com`.
  - Verify syntax using `plutil -lint ios/Runner/Info.plist`.

## Definition of Done (DoD)
- [ ] `app_links` resolves cleanly in `pubspec.lock`.
- [ ] `./gradlew :app:assembleStgDebug` succeeds without manifest merge errors.
- [ ] `Info.plist` passes `plutil -lint`.

## Dependencies & Blockers
- Blocked by: [Task 1: Platform DeepLink Protocol, Parser & Registry](task_1_deeplink_protocol_and_parser.md).
- Blocks: [Task 3: DeepLink Coordinator, Auth Guard & Deduplication](task_3_deeplink_coordinator_and_auth_guard.md).

## References & Rollback
- Plugin documentation: https://pub.dev/packages/app_links
- Rollback Strategy: Revert `pubspec.yaml`, `AndroidManifest.xml`, and `Info.plist` via git.

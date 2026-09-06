# Epic: Flutter Super App Template & Bộ Mason Bricks Chuẩn Hóa

## Mục lục
1. [Meta Data](#meta-data)
2. [Bối cảnh](#bối-cảnh)
3. [Mục tiêu & Ngoài phạm vi](#mục-tiêu--ngoài-phạm-vi)
4. [Kiến trúc & Thiết kế kỹ thuật](#kiến-trúc--thiết-kế-kỹ-thuật)
   - [Kiến trúc tổng thể](#kiến-trúc-tổng-thể)
   - [Use Cases](#use-cases)
   - [Sequence Diagram (Luồng nâng cấp UI)](#sequence-diagram-luồng-nâng-cấp-ui)
5. [Chiến lược Rollout & Giảm thiểu rủi ro](#chiến-lược-rollout--giảm-thiểu-rủi-ro)
6. [Phân rã Kanban Tasks](#phân-rã-kanban-tasks)

---

## Meta Data
- **Epic**: `flutter_super_app_template`
- **Trạng thái**: Đang thực hiện (In-Progress / Designing)
- **Target Release**: Flutter Super App Template v1.0
- **Source Spec**: [2026-09-06-flutter-super-app-template-design.md](2026-09-06-flutter-super-app-template-design.md)
- **Template Native Tham chiếu**:
  - Android: `/Users/danhdue/AllProjects/digital_wallet/android_digital_wallet/.worktrees/android_super_app_template`
  - iOS: `/Users/danhdue/AllProjects/digital_wallet/iOSDigitalWallet/.worktrees/ios_super_app_template`

---

## Bối cảnh
`bloc_digital_wallet` là monorepo Flutter quản lý bằng Melos, tuân thủ Clean Architecture + MVI. Trước đây, toàn bộ các package (hạ tầng dùng chung, tiện ích, native bridges, và các mini-app nghiệp vụ) bị đặt chung trong một thư mục phẳng `packages/`. Thêm vào đó, các bản thảo thiết kế trước đây dự định trích xuất cả một dự án Standalone Native Android ngay từ bên trong repo Flutter.

Hiện tại, vì đã có sẵn 2 template native độc lập hoàn chỉnh ([`android_super_app_template`](file:///Users/danhdue/AllProjects/digital_wallet/android_digital_wallet/.worktrees/android_super_app_template) và [`ios_super_app_template`](file:///Users/danhdue/AllProjects/digital_wallet/iOSDigitalWallet/.worktrees/ios_super_app_template)), định hướng được điều chỉnh chuẩn xác:
1. Tái cấu trúc `bloc_digital_wallet` thành **Flutter Super App Template** chuẩn mực bằng cách phân tách rõ `packages/` (hạ tầng, tiện ích, native plugins) và `features/` (mini-apps), đạt sự đồng nhất 100% (Tri-Platform Parity) với cả Android và iOS.
2. Xây dựng bộ Mason Bricks tinh gọn để sinh features, thư viện, và packages tích hợp native (hỗ trợ cả No-UI với Pigeon và With-UI với Jetpack Compose/SwiftUI + MviViewModel qua PlatformView).
3. Bổ sung cơ chế nâng cấp một chạm (`pac_add_native_ui` / `scripts/add_native_ui.sh`) chuyển đổi package từ No-UI sang With-UI mà không ảnh hưởng mã nguồn cũ.
4. Loại bỏ triệt để các script và brick cũ nhằm sinh standalone native app từ Flutter.

---

## Mục tiêu & Ngoài phạm vi

### Mục tiêu
- **Đồng nhất cấu trúc 3 nền tảng (Tri-Platform Parity):** Phân tách cấu trúc thư mục thành `packages/` (hạ tầng) và `features/` (mini-apps), khớp chuẩn với `android_super_app_template` và `ios_super_app_template`.
- **Cắt gọn danh mục package trong Template:** Giữ 8 package hạ tầng trong `packages/` (`core`, `framework`, `network`, `ui_kit`, `platform`, `logger`, `logger_native_bridge`, `native_security`), 1 feature mẫu thực tế (`features/settings`), và 1 feature khung rỗng (`features/scanner`). Loại bỏ hoàn toàn các package domain ví (`wallet`, `transaction`, `trends`, `authentication`, `onboard`).
- **Tái cấu trúc Shell Host:** Shell 3 tab (`Home` stub page, `Scanner`, `Settings`), mở app vào thẳng Settings, bỏ splash tùy biến.
- **Hệ thống Mason Bricks:**
  - `pac_mvi_feature`: Sinh feature package thuần Dart trong `features/{{name}}/`, tự động đăng ký DI, AutoRoute, và `DeepLinkRoutes` (neo: `settings`).
  - `pac_library`: Sinh package tiện ích/hạ tầng nội bộ trong `packages/{{name}}/`.
  - `pac_native_plugin`: Sinh Flutter plugin trong `packages/{{name}}/` với Clean Architecture Android (Kotlin) & iOS (Swift) (`Platform/Domain/Data/Presentation`). Hỗ trợ Pigeon cho `has_ui: false` và Jetpack Compose/SwiftUI + self-contained `MviViewModel` qua PlatformView cho `has_ui: true`.
  - `pac_add_native_ui` & `scripts/add_native_ui.sh`: Nâng cấp một chạm từ headless sang có UI native an toàn.
- **Công cụ Đổi tên dự án:** `scripts/rename_project.sh` đổi tên package, app, bundle ID, imports; giữ cố định namespace vendor `com.danhdue.*` của plugin native.
- **CI Boundary Gate:** Cập nhật `scripts/check_module_boundaries.sh` kiểm tra phân định ranh giới giữa `features/*` và `packages/*`.

### Ngoài phạm vi
- Tự tạo hoặc trích xuất ứng dụng native Android/iOS độc lập từ repo Flutter (đã do 2 template native độc lập đảm nhiệm).
- Xây dựng cơ chế tải mã động runtime (Flutter biên dịch thành 1 binary duy nhất).
- Thay thế `auto_route` hoặc `get_it`.

---

## Kiến trúc & Thiết kế Kỹ thuật

### Kiến trúc Tổng thể
```mermaid
graph TD
    subgraph HostApp ["Flutter Super App Host (lib/)"]
        ShellPage["ShellPage (3 Tabs: Home, Scanner, Settings)"]
        AppRouter["AppRouter (AutoRoute)"]
        DI["AppInjection (GetIt)"]
    end

    subgraph Features ["features/ (Mini-Apps / Features)"]
        Settings["features/settings (Sample Thực tế)"]
        Scanner["features/scanner (Sample Khung rỗng)"]
        NewFeature["features/{{name}} (sinh bởi pac_mvi_feature)"]
    end

    subgraph PlatformPkg ["packages/platform (Quản trị)"]
        DeepLink["DeepLinkRoutes (Định tuyến phi phụ thuộc)"]
        EventBus["AppEventBus (Giao tiếp phi phụ thuộc)"]
    end

    subgraph InfraPkgs ["packages/ (Hạ tầng Dùng chung)"]
        Core["packages/core"]
        Framework["packages/framework (MviBloc)"]
        Network["packages/network (Dio/Retrofit)"]
        UIKit["packages/ui_kit (Design System)"]
        Logger["packages/logger"]
    end

    subgraph NativePlugins ["packages/ (Native Bridges & Plugins)"]
        NativeSec["packages/native_security (FFI)"]
        NativeLog["packages/logger_native_bridge (Pigeon)"]
        NewPlugin["packages/{{plugin}} (sinh bởi pac_native_plugin)"]
    end

    ShellPage --> Features
    AppRouter --> Features
    DI --> Features
    Features --> PlatformPkg
    Features --> InfraPkgs
    NativePlugins --> Core
    NewPlugin -.->|PlatformView (UI) hoặc Pigeon (No-UI)| HostApp
```

### Use Cases
```mermaid
flowchart TD
    Dev["Developer"] --> U1["Sinh Mini-App Feature mới"]
    Dev --> U2["Sinh Package Thư viện Nội bộ"]
    Dev --> U3["Sinh Native Plugin (No-UI / With-UI)"]
    Dev --> U4["Nâng cấp Plugin No-UI lên With-UI"]
    Dev --> U5["Clone Template & Đổi tên Dự án"]

    U1 -->|Chạy| B1["mason make pac_mvi_feature --name <name>"]
    B1 --> O1["Xuất ra features/<name>/ & nối DI/Router/DeepLink"]

    U2 -->|Chạy| B2["mason make pac_library --name <name>"]
    B2 --> O2["Xuất ra packages/<name>/ & thêm vào workspace"]

    U3 -->|Chạy| B3["mason make pac_native_plugin --name <name> --has_ui <bool>"]
    B3 --> O3["Xuất ra packages/<name>/ với Clean Arch Kotlin/Swift"]

    U4 -->|Chạy| B4["mason make pac_add_native_ui --name <name>"]
    B4 --> O4["Tự động chèn Compose/SwiftUI + PlatformView qua Mason Hooks"]

    U5 -->|Chạy| S1["mason make pac_rename_project (hoặc ./scripts/rename_project.sh)"]
    S1 --> O5["Đổi tên toàn diện đa nền tảng bằng Mason Dart Hook & kiểm tra với melos genAlls"]
```

### Sequence Diagram (Luồng nâng cấp UI)
```mermaid
sequenceDiagram
    autonumber
    actor Dev as Developer
    participant Mason as Mason CLI (pac_add_native_ui)
    participant HookPre as Hook pre_gen.dart
    participant PluginDir as packages/<name>/
    participant Android as Android Source
    participant iOS as iOS Source
    participant Dart as Dart Barrel & UI
    participant HookPost as Hook post_gen.dart

    Dev->>Mason: mason make pac_add_native_ui --name <name>
    Mason->>HookPre: Chạy kiểm tra ban đầu
    HookPre->>PluginDir: Kiểm tra packages/<name> tồn tại & chưa có presentation/
    Mason->>Android: Bật Compose trong build.gradle.kts
    Mason->>Android: Sinh presentation/ (MviViewModel.kt, Screen.kt, PlatformView.kt)
    Mason->>iOS: Sinh Presentation/ (MviViewModel.swift, View.swift, PlatformView.swift)
    Mason->>Dart: Sinh lib/src/ui/<name>_native_view.dart (AndroidView/UiKitView)
    Mason->>HookPost: Chạy hoàn thiện & patch mã nguồn
    HookPost->>Android: Patch *Plugin.kt để đăng ký PlatformViewFactory
    HookPost->>iOS: Patch *Plugin.swift để đăng ký FlutterPlatformViewFactory
    HookPost->>Dart: Export view widget trong lib/<name>.dart
    Mason-->>Dev: Nâng cấp hoàn tất 100% bằng Mason (Sẵn sàng code Compose & SwiftUI)
```

---

## Chiến lược Rollout & Giảm thiểu Rủi ro

### Các Giai đoạn Thực thi
1. **Giai đoạn 1 (Tái cấu trúc thư mục):** Chuyển `packages/settings` và `packages/scanner` sang `features/`. Cập nhật `melos.yaml`, root `pubspec.yaml`, và relative paths. Chạy kiểm tra `melos bootstrap` và `melos genAlls`.
2. **Giai đoạn 2 (Hệ thống Bricks):** Xây dựng và kiểm thử `pac_mvi_feature`, `pac_library`, `pac_native_plugin`, `pac_add_native_ui`, và `pac_rename_project`.
3. **Giai đoạn 3 (Cắt gọn Template):** Loại bỏ các package domain ví, dựng lại Shell 3 tab, dọn assets, cập nhật script kiểm tra CI.
4. **Giai đoạn 4 (Đổi tên & Nghiệm thu):** Thử nghiệm chạy `mason make pac_rename_project` trên branch cách ly, build kiểm thử thành công trên cả Android và iOS.

### Rủi ro & Biện pháp Xử lý
- **Lỗi đường dẫn tương đối khi chuyển sang `features/`:** Chiều sâu tương đối đến `packages/` đổi thành `../../packages/*`. Biện pháp: Kiểm tra tự động bằng `dart analyze` và `melos run analyze`.
- **Xung đột phiên bản Pigeon:** Pigeon bản mới xung đột analyzer với `theme_tailor`. Biện pháp: Ghim phiên bản Pigeon `26.3.2` tương thích với workspace.
- **Lỗi đăng ký plugin khi đổi tên:** Đổi tên nhầm namespace plugin native có thể làm gãy bridge. Biện pháp: Khóa cứng namespace `com.danhdue.*` trong hook `pac_rename_project`.

---

## Phân rã Kanban Tasks

| Task ID | Tiêu đề Task | Phạm vi & Tệp tác động |
|---|---|---|
| [Task 1](task_1_monorepo_restructuring.md) | Tái cấu trúc Thư mục Monorepo (Tri-Platform Parity) | Phân tách `packages/` và `features/`, chuyển `settings` & `scanner`, cập nhật `melos.yaml` và workspace root. |
| [Task 2](task_2_pac_mvi_feature_brick.md) | Cập nhật Brick `pac_mvi_feature` | Đích đến `features/{{name}}`, chuyển anchor sang `settings`, cập nhật hooks và bricks con. |
| [Task 3](task_3_pac_library_brick.md) | Tạo mới Brick `pac_library` | Đích đến `packages/{{name}}`, sinh thư viện thuần Dart/Flutter và đăng ký workspace. |
| [Task 4](task_4_pac_native_plugin_brick.md) | Tạo mới Brick `pac_native_plugin` | Clean Arch Android (Kotlin) & iOS (Swift); Pigeon cho No-UI, Compose/SwiftUI + MviViewModel cho With-UI. |
| [Task 5](task_5_pac_add_native_ui_tool.md) | Tạo mới Brick `pac_add_native_ui` | Brick nâng cấp 1 chạm từ No-UI lên With-UI qua Mason hooks (pre_gen/post_gen), tự động patch Gradle, Kotlin, Swift, Dart. |
| [Task 6](task_6_template_trimming_and_shell.md) | Cắt gọn Template & Dựng lại Shell Host | Xóa 5 package domain ví, dựng Shell 3 tab (Home stub, Scanner, Settings), dọn assets, cập nhật CI gate. |
| [Task 7](task_7_obsolete_cleanups.md) | Dọn dẹp Bricks Lỗi thời & Script Cũ | Xóa `sample`, `test_brick`, `native_feature_module`, và các script trích xuất standalone cũ. |
| [Task 8](task_8_rename_project_brick_and_validation.md) | Brick `pac_rename_project` & Nghiệm thu Toàn diện | Xây dựng brick `pac_rename_project` (Dart hook cross-platform) + wrapper script, test clone/rename, chạy `melos genAlls`, build APK & iOS Runner. |



# Epic: Template — Kiến trúc Native iOS

## Mục lục
1. [Meta Data](#1-meta-data)
2. [Bối cảnh](#2-bối-cảnh)
3. [Mục tiêu & Không làm gì](#3-mục-tiêu--không-làm-gì)
4. [Phạm vi](#4-phạm-vi)
5. [Danh sách task](#5-danh-sách-task)

## 1. Meta Data
- **Epic**: `template_ios`
- **Trạng thái**: Planning
- **Spec gốc**: [flutter_super_app_template.vi.md](../flutter_super_app_template/flutter_super_app_template.vi.md), [2026-08-29-flutter-super-app-template-design.md mục 3.5](../flutter_super_app_template/2026-08-29-flutter-super-app-template-design.md)
- **Epic song song**: [template_flutter](../template_flutter/template_flutter.vi.md), [template_android](../template_android/template_android.vi.md)
- **Nguồn tham chiếu**: không có project native iOS sẵn có (khác Android có `android_digital_wallet`) — tầng MVI Swift được thiết kế mới hoàn toàn trong epic này, dịch khái niệm 1:1 từ `MviViewModel` Kotlin của `android_digital_wallet`.

## 2. Bối cảnh
2 plugin native hiện có (`native_security`, `logger_native_bridge`) đều có thư mục `ios/Classes/` với source Swift phẳng, không quy ước layer chung, không tooling lint/format. Khác Android, không có project native iOS song song nào để port sẵn stack MVI/DI/quality — epic này thiết kế mới hoàn toàn bản Swift tương đương stack Kotlin của `template_android` (native `core`, native `framework`, tooling chất lượng), giữ cùng tên/ngữ nghĩa giữa 2 nền tảng để dễ đối chiếu.

## 3. Mục tiêu & Không làm gì

### Mục tiêu
- Thiết kế và hiện thực `MviViewModel`/`MvvmViewModel`/`ViewState` bản Swift (Combine-based `ObservableObject`, min target **iOS 13** — chốt 2026-08-29, không dùng `@Observable`/`swift-perception`), dịch ngữ nghĩa `StateFlow`/`Channel`/`SharedFlow` 1:1 (`uiState`, `viewState`, `event`, `sharedEvent`, `dispatch`/`reduce`/`setState`, `startLoading`/`handleError`).
- Xây native `core` bản Swift (`SafeExecution`, `DataState<T>`, `Logger`, `Container`, `ReplayQueue`) làm dependency bắt buộc cho mọi module native, có UI hay không — cùng contract với `core` Android, khác ngôn ngữ.
- Thiết lập SwiftLint + SwiftFormat dùng chung (1 ruleset, mọi plugin/module cùng trỏ vào) — tương đương convention plugin chất lượng bên Android.
- Refactor source Swift của `native_security` và `logger_native_bridge` vào `Platform/Domain/Data`, khớp tên thư mục 1:1 với Android để đối chiếu.
- Phủ nửa iOS của brick Mason `native_package` (flag `trigger`/`has_ui`) và của `scripts/native_add_ui_dependency.sh`.
- Đóng gói `native_security`, `logger_native_bridge`, và output của brick `native_ios_package` **chỉ qua SPM** (không `.podspec`) — chốt 2026-08-29, đón đầu việc CocoaPods read-only từ 2/12/2026. Phạm vi chỉ 2 plugin này, không phải `ios/Podfile` của app.
- Ship `scripts/extract_native_standalone_ios.sh` để tách `core`/`framework` — vốn đã không phụ thuộc Flutter theo thiết kế — thành 1 repo native iOS độc lập, mới tinh (không liên quan Flutter), dùng khi dự án cần phát triển native thuần.

### Không làm gì
- Bất kỳ việc gì bên Android — xem `template_android`.
- Phase 3 (an toàn plugin OS-integrated, vd Extension kiểu `CallDirectoryHandler`; binding Go) — để dành, chỉ xây `core.SafeExecution` làm nguyên hàm gốc Phase 3 cần sau này.
- Xây 1 Call Directory Extension sản xuất hoàn chỉnh — phần iOS của `vchat_shield` chỉ là nguồn rút bài học.

## 4. Phạm vi
Ma trận use case, tách `core`/`framework`, và bảng dịch Kotlin→Swift đã chốt đầy đủ ở spec gốc (mục 3.5 và các sơ đồ theo use case) — epic này chỉ thi công. Xem bảng task bên dưới.

## 5. Danh sách task

| # | Task | Tóm tắt |
|---|---|---|
| 1 | [`MviViewModel` bản Swift](../../features/task_1_swift_mvi_viewmodel.md) | Thiết kế + hiện thực bộ ba ViewModel/`ViewState` Combine-based (floor iOS 13, đã chốt). |
| 2 | [Module native `core`](../../features/task_2_native_core_module_ios.md) | `SafeExecution`, `DataState<T>`, `Logger`, `Container`, `ReplayQueue` bản Swift. |
| 3 | [Tooling chất lượng](../../features/task_3_quality_tooling.md) | `.swiftlint.yml`/`.swiftformat` dùng chung, nối vào Run Script Phase. |
| 4 | [Refactor `native_security`](../../features/task_4_refactor_native_security_ios.md) | Tổ chức lại source Swift vào `Platform/Domain/Data`. |
| 5 | [Refactor `logger_native_bridge`](../../features/task_5_refactor_logger_native_bridge_ios.md) | Tương tự; nối `ReplayQueue` bản Swift. |
| 6 | [Brick `native_ios_package`](../../features/task_6_native_package_brick_ios.md) | Brick độc lập, sinh khung iOS cho Ô1–Ô4, cùng dạng flag `trigger`/`has_ui` với Android nhưng gọi riêng. |
| 7 | [`native_add_ui_dependency` (iOS)](../../features/task_7_add_ui_dependency_tool_ios.md) | Nối `Package.swift` để thêm `framework` + `presentation/` vào package đã có. |
| 8 | [Guide binding Go (nửa iOS)](../../features/task_8_go_binding_guide_ios.md) | Tích hợp `.xcframework`, snippet panic-recovery cho ranh giới Swift/cgo. |
| 9 | [Trích xuất repo độc lập](../../features/task_9_standalone_extraction_ios.md) | `scripts/extract_native_standalone_ios.sh` — tách `core`/`framework` thành repo native mới, không phụ thuộc Flutter. |
| 10 | [Đóng gói chỉ SPM](../../features/task_10_spm_only_packaging.md) | Xoá `.podspec` khỏi `native_security`/`logger_native_bridge`/output của brick; chỉ dùng SPM. Làm trước Task 4-7. |

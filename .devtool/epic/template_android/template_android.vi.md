# Epic: Template — Kiến trúc Native Android

## Mục lục
1. [Meta Data](#1-meta-data)
2. [Bối cảnh](#2-bối-cảnh)
3. [Mục tiêu & Không làm gì](#3-mục-tiêu--không-làm-gì)
4. [Phạm vi](#4-phạm-vi)
5. [Danh sách task](#5-danh-sách-task)

## 1. Meta Data
- **Epic**: `template_android`
- **Trạng thái**: Planning
- **Spec gốc**: [flutter_super_app_template.vi.md](../flutter_super_app_template/flutter_super_app_template.vi.md), [2026-08-29-flutter-super-app-template-design.md mục 3](../flutter_super_app_template/2026-08-29-flutter-super-app-template-design.md)
- **Epic song song**: [template_flutter](../template_flutter/template_flutter.vi.md), [template_ios](../template_ios/template_ios.vi.md)
- **Nguồn tham chiếu**: `android_digital_wallet` (nguồn kiến trúc MVI + `buildSrc` để port), `vchat_shield` (native code mà quy tắc crash-boundary của epic này sinh ra để tránh lặp lại — các pattern OS-integrated của nó thuộc Phase 3, ngoài phạm vi epic này)

## 2. Bối cảnh
Hiện repo chỉ có đúng 2 mặt native Android — `native_security` (plugin FFI) và `logger_native_bridge` (plugin Pigeon) — mỗi cái có source Kotlin phẳng riêng, không quy ước layer chung, không tooling lint/format, và lặp lại boilerplate `kotlin_version`/AGP trong `build.gradle`. Song song đó, `android_digital_wallet` (1 project native khác) đã có sẵn `MviViewModel`/`MvvmViewModel`/`ViewState` chạy tốt và 1 `buildSrc` đầy đủ (Spotless, Detekt, convention plugin Hilt+Compose, version catalog). Epic này port phần dùng lại được của đó vào `android/` của template, thiết lập quy ước layer `platform/domain/data(/presentation)`, và tạo 1 brick Mason tham số hoá duy nhất để mọi module native Android tương lai được sinh nhất quán thay vì viết tay.

## 3. Mục tiêu & Không làm gì

### Mục tiêu
- Port convention chất lượng của `android/buildSrc` (Spotless/ktlint + Detekt, 1 ruleset dùng chung) áp cho **mọi** module native kể cả plugin package — khả thi vì cơ chế nạp plugin của Flutter khiến mọi plugin trở thành subproject của cùng 1 root Gradle build với host app lúc build.
- Port convention plugin Hilt+Compose, chỉ áp cho module sở hữu màn hình native (`has_ui=true`).
- Tạo native `core` (`SafeExecution`, `DataState<T>`, `Logger`, `Container`, `ReplayQueue`) làm dependency bắt buộc cho mọi module native, có UI hay không.
- Tạo native `framework` (`MviViewModel`/`MvvmViewModel`/`ViewState`), port từ `android_digital_wallet`, chỉ phụ thuộc native `core`.
- Refactor source Kotlin của `native_security` và `logger_native_bridge` vào `platform/domain/data`, xoá lặp `kotlin_version`/AGP, sạch lint/format.
- Giữ plugin package trung lập với DI framework (`Container` thủ công, không Hilt) để dùng được ở bất kỳ app Flutter nào.
- Ship 1 brick Mason tham số hoá duy nhất, `native_package(trigger, has_ui)`, bao phủ đủ 4 ô (Ô1–Ô4) từ 1 nguồn thay vì 3-4 brick bảo trì riêng lẻ.
- Ship `scripts/native_add_ui_dependency.sh` — nửa "tool" của việc nâng cấp package không-UI thành có-UI (phía Android).
- Ship `scripts/extract_native_standalone_android.sh` để tách `core`/`framework`/`buildSrc` — vốn đã không phụ thuộc Flutter theo thiết kế — thành 1 repo native Android độc lập, mới tinh (không liên quan Flutter), dùng khi dự án cần phát triển native thuần.

### Không làm gì
- Bất kỳ việc gì bên iOS — xem `template_ios`.
- Phase 3 (pattern an toàn cho plugin OS-integrated, binding Go) — để dành; chỉ xây nguyên hàm gốc (`core.SafeExecution`) mà Phase 3 sẽ dùng sau này.
- Viết lại `vchat_shield` — chỉ là nguồn rút bài học, không phải mục tiêu migrate.

## 4. Phạm vi
Ma trận use case (trigger × has_ui), tách `core`/`framework`, chiến lược 1-brick, và sơ đồ theo từng use case đã chốt đầy đủ ở spec gốc — epic này chỉ thi công nửa Android. Xem bảng task bên dưới.

## 5. Danh sách task

| # | Task | Tóm tắt |
|---|---|---|
| 1 | [Port `buildSrc`](../../features/task_1_buildsrc_port.md) | Convention chất lượng (Spotless/Detekt) + convention Hilt/Compose, cắt gọn từ `android_digital_wallet`. |
| 2 | [Module native `core`](../../features/task_2_native_core_module_android.md) | `SafeExecution`, `DataState<T>`, `Logger`, `Container`, `ReplayQueue`. |
| 3 | [Module native `framework`](../../features/task_3_native_framework_module.md) | `MviViewModel`/`MvvmViewModel`/`ViewState`, port và thích nghi. |
| 4 | [Refactor `native_security`](../../features/task_4_refactor_native_security_android.md) | Tổ chức lại vào `platform/domain/data`, áp convention chất lượng. |
| 5 | [Refactor `logger_native_bridge`](../../features/task_5_refactor_logger_native_bridge_android.md) | Tương tự; nối `ReplayQueue` tổng quát hoá từ logic replay hiện có. |
| 6 | [Brick `native_android_package`](../../features/task_6_native_package_brick_android.md) | Brick tham số hoá độc lập, sinh khung Android cho Ô1–Ô4 (tách riêng khỏi brick iOS). |
| 7 | [`native_add_ui_dependency.sh`](../../features/task_7_add_ui_dependency_tool_android.md) | Thêm dependency `framework` + convention Hilt/Compose + bắc cầu Hilt↔`Container` vào package đã có. |
| 8 | [Guide binding Go (nửa Android)](../../features/task_8_go_binding_guide_android.md) | `docs/architecture/native-go-binding.md` — gomobile `.aar`, snippet panic-recovery cho JNI. |
| 9 | [Trích xuất repo độc lập](../../features/task_9_standalone_extraction_android.md) | `scripts/extract_native_standalone_android.sh` — tách `core`/`framework`/`buildSrc` thành repo native mới, không phụ thuộc Flutter. |

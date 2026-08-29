# Epic: Template — Cắt gọn Flutter/Dart

## Mục lục
1. [Meta Data](#1-meta-data)
2. [Bối cảnh](#2-bối-cảnh)
3. [Mục tiêu & Không làm gì](#3-mục-tiêu--không-làm-gì)
4. [Phạm vi](#4-phạm-vi)
5. [Danh sách task](#5-danh-sách-task)

## 1. Meta Data
- **Epic**: `template_flutter`
- **Trạng thái**: Planning
- **Spec gốc**: [flutter_super_app_template.vi.md](../flutter_super_app_template/flutter_super_app_template.vi.md), [2026-08-29-flutter-super-app-template-design.md mục 4](../flutter_super_app_template/2026-08-29-flutter-super-app-template-design.md)
- **Epic song song**: [template_android](../template_android/template_android.vi.md), [template_ios](../template_ios/template_ios.vi.md)
- **Lý do tách**: khối lượng công việc (native + Flutter) quá lớn cho 1 epic; tách theo nền tảng để mỗi bên lập kế hoạch/thi công/review độc lập. Thứ tự khuyến nghị: `template_android`/`template_ios` trước (nền native), `template_flutter` sau cùng — nhưng Task 1-6 của epic này không phụ thuộc cứng vào 2 epic native, có thể làm song song.
- **Nơi làm việc (chốt 2026-08-29)**: toàn bộ công việc làm trên 1 **git worktree của chính repo `bloc_digital_wallet`** (vd `.worktrees/flutter_super_app_template`), không tách sang repo `git init` mới ngay. Việc tách repo độc lập (nếu cần) để quyết định sau, không chặn epic này.

## 2. Bối cảnh
`bloc_digital_wallet` là monorepo Clean Architecture + MVI đã trưởng thành, mang theo trọn vẹn 1 sản phẩm digital wallet (7 feature package, 90 locale, asset đặc thù domain, lịch sử `.agent`/`.devtool` lớn). Mục tiêu: 1 template clone-và-đổi-tên — cắt domain digital wallet còn lại đúng 1 feature thật (`settings`) + 1 feature khung rỗng (`scanner`), giữ nguyên mọi tooling dùng lại được (Mason bricks, CI gate, scripts), và thêm 1 cửa vào đổi tên duy nhất để dự án mới chỉ cần clone + chạy 1 script.

## 3. Mục tiêu & Không làm gì

### Mục tiêu
- Rút gọn tập feature package còn `settings` (thật) + `scanner` (rỗng, sinh từ brick), giữ nguyên mọi package hạ tầng (`core`, `framework`, `network`, `native_security`, `ui_kit`, `platform`, `logger`, `logger_native_bridge`).
- Dựng lại Host `lib/` quanh Shell 3 tab (home stub, scanner, settings), settings là tab mặc định, bỏ splash tuỳ biến.
- Giữ nguyên 90 locale và font SF Compact; chỉ xoá asset đặc thù digital-wallet.
- Giữ `pac_mvi_feature`/`pac_mvi_subfeature`/`remove_pac_feature`/`remove_pac_subfeature` **và** bricks cũ nhắm `lib/features/` (`mvi_feature`, `mvi_subfeature`, `sample`, `remove_feature`, `remove_subfeature`, `remove_sample`, `test_brick`) — giữ lại, không xoá, phòng trường hợp dự án sau này không theo package-first organization. Sửa hook `pac_mvi_feature` để vẫn nối feature mới đúng cách khi `onboard` (neo hiện tại) không còn.
- Dọn `.agent/`, `.devtool/epic/`, `docs/`, và cấu hình đa-IDE về bộ tối giản, generic.
- Chỉ còn đúng 1 `scripts/rename_project.sh` là bước duy nhất cần chạy sau khi clone. Script **không đụng** namespace Kotlin/Swift cố định `com.danhdue.*` của 2 plugin.
- Giữ nguyên `.gitlab-ci.yml` (kể cả bước Firebase secrets/`buildIPA`) làm mẫu tham khảo, không rút gọn.

### Không làm gì
- Bất kỳ việc kiến trúc native nào (Android/Kotlin, iOS/Swift) — xem `template_android`/`template_ios`.
- Các mục Phase 3 của design doc gốc (an toàn plugin OS-integrated, binding Go) — để dành, không thuộc epic này.
- Thiết kế lại domain digital wallet — bị xoá, không migrate.

## 4. Phạm vi
Danh sách package giữ/bỏ, layout tab Shell, quyết định locale/asset, và thiết kế CI/rename-script đã chốt đầy đủ ở spec gốc — epic này chỉ thi công. Xem bảng task bên dưới; mỗi file task trỏ ngược về đúng mục trong design doc gốc mà nó thi công.

## 5. Danh sách task

| # | Task | Tóm tắt |
|---|---|---|
| 1 | [Cắt gọn package inventory](../../features/task_1_trim_package_inventory.md) | Xoá `authentication`/`onboard`/`wallet`/`transaction`/`trends`/`d3nexus_logger`; sinh `scanner` rỗng từ `pac_mvi_feature`. |
| 2 | [Dựng lại Host Shell](../../features/task_2_rebuild_host_shell.md) | Shell 3 tab (home stub/scanner/settings), bỏ splash tuỳ biến, cập nhật `app_router.dart`/`injection.dart`/`AuthNavigationInitializer`. |
| 3 | [Dọn asset & locale](../../features/task_3_asset_locale_cleanup.md) | Xoá image/lottie/json đặc thù wallet; giữ nguyên 90 locale và font SF Compact. |
| 4 | [Dọn mason bricks](../../features/task_4_mason_bricks_cleanup.md) | Giữ nguyên bricks cũ thời `lib/features/`; sửa neo `onboard` trong hook `pac_mvi_feature`. |
| 5 | [Dọn docs & `.agent`](../../features/task_5_docs_agent_cleanup.md) | Gỡ tham chiếu tên project, cắt gọn `.devtool/epic`/`docs/`, gom cấu hình đa-IDE. |
| 6 | [Đồng bộ CI](../../features/task_6_ci_simplification.md) | Giữ nguyên `.gitlab-ci.yml` làm mẫu; đồng bộ `module_boundary_whitelist.txt`/`FEATURE_PACKAGES` theo package đã cắt. |
| 7 | [Script đổi tên](../../features/task_7_rename_script.md) | `scripts/rename_project.sh` — cửa vào duy nhất khi clone-và-đổi-tên (namespace plugin native giữ cố định). |
| 8 | [Trích xuất & kiểm thử trên worktree](../../features/task_8_extraction_validation.md) | Dựng 1 git worktree riêng trong repo này; chạy thử toàn bộ vòng rename→build. |

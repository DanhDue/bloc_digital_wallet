# Hướng dẫn sử dụng Template

Guide thực hành, theo từng use case — mỗi mục là 1 việc cụ thể bạn muốn làm, kèm lệnh và tham chiếu ngược
về task/design doc nếu cần đọc sâu hơn. Xem [flutter_super_app_template](../../.devtool/epic/flutter_super_app_template/flutter_super_app_template.vi.md)
để hiểu tổng quan kiến trúc trước khi dùng guide này.

> **Lưu ý về tên lệnh**: các spec doc trước đó có nhắc tới 1 brick/script dùng chung cho cả 2 nền tảng
> (`native_package`, `extract_native_standalone.sh`, `native_add_ui_dependency.sh`). Quyết định cuối cùng
> là **tách riêng theo từng nền tảng** — không có lệnh nào nhận tham số `android`/`ios`. Danh sách dưới đây
> là tên lệnh chính thức.

## Mục lục
0. [Bắt đầu 1 project mới từ template](#0-bắt-đầu-1-project-mới-từ-template)
1. [Tạo 1 Flutter package mới](#1-tạo-1-flutter-package-mới)
2. [Thêm native KHÔNG UI vào 1 package](#2-thêm-native-không-ui-vào-1-package)
3. [Thêm native CÓ UI vào 1 package](#3-thêm-native-có-ui-vào-1-package)
4. [Nâng cấp package không-UI có sẵn thành có-UI](#4-nâng-cấp-package-không-ui-có-sẵn-thành-có-ui)
5. [Tạo 1 project Android Native độc lập từ template](#5-tạo-1-project-android-native-độc-lập-từ-template)
6. [Tạo 1 project iOS Native độc lập từ template](#6-tạo-1-project-ios-native-độc-lập-từ-template)
7. [Thêm binding Go vào 1 package native đã có](#7-thêm-binding-go-vào-1-package-native-đã-có)
8. [Xoá 1 feature package](#8-xoá-1-feature-package)

---

## 0. Bắt đầu 1 project mới từ template

Việc đầu tiên và bắt buộc trước mọi việc khác — mọi bước sau đều giả định bạn đã làm xong bước này.

```bash
git clone <template-repo-url> my_new_app
cd my_new_app
./scripts/rename_project.sh my_new_app com.mycompany.mynewapp
melos bootstrap
melos genAlls
```

`rename_project.sh` đổi tên package Dart, import trong `lib/`, `applicationId`/bundle id, tên hiển thị app
— xem [template_flutter task 7](../../.devtool/epic/template_flutter/task_7_rename_script.md). Sau bước
này, `flutter run` sẽ mở thẳng vào Shell với tab Settings.

## 1. Tạo 1 Flutter package mới

Không cần code native gì cả — feature thuần Dart/Flutter.

```bash
mason make pac_mvi_feature
# nhập tên feature khi được hỏi, vd: wallet
```

Brick tự sinh `packages/<name>/` (Clean Architecture: `data/domain/presentation`), tự nối vào root
`pubspec.yaml`, `lib/di/injection.dart`, `lib/app_router.dart`, `lib/core/localization/...`, chạy
`melos bootstrap` + `./scripts/integrateFeatureToApp.sh <name>` cho bạn. Đây chính là Case 1 trong
[flutter_super_app_template §2](../../.devtool/epic/flutter_super_app_template/flutter_super_app_template.vi.md).

## 2. Thêm native KHÔNG UI vào 1 package

Dùng khi package cần gọi xuống Kotlin/Swift nhưng không có màn hình native nào (vd: secure storage, mã
hoá, đọc thông tin thiết bị). Tương ứng Ô1/Ô3 trong ma trận use case.

```bash
# Nếu cần code native cho Android:
mason make native_android_package
#   name: <ten_package>
#   trigger: passive        (Dart gọi vào)  |  os_triggered (OS tự gọi, độc lập Flutter)
#   has_ui: false

# Nếu cần cả code native cho iOS (chạy thêm lệnh riêng, không gộp):
mason make native_ios_package
#   name: <ten_package>   (đúng tên như trên, để ghi vào cùng packages/<name>/)
#   trigger: passive | os_triggered  (chọn giống Android nếu muốn hành vi nhất quán 2 nền tảng)
#   has_ui: false
```

Chỉ cần Android thì chỉ chạy lệnh đầu; chỉ cần iOS thì chỉ chạy lệnh sau — 2 lệnh độc lập hoàn toàn, brick
tự phát hiện `packages/<name>/` đã tồn tại (do lệnh kia tạo) hay chưa để merge đúng cách. Kết quả: có sẵn
`platform/domain/data`, phụ thuộc native `core`, DI thủ công (không Hilt). Nếu `trigger=os_triggered`,
entry-point sinh ra đã được bọc sẵn `core.SafeExecution`. Xem
[template_android task 6](../../.devtool/epic/template_android/task_6_native_package_brick.md) /
[template_ios task 6](../../.devtool/epic/template_ios/task_6_native_package_brick_ios.md).

## 3. Thêm native CÓ UI vào 1 package

Dùng khi cần 1 màn hình/overlay native thật sự (vd: 1 `PlatformView` camera tuỳ biến). Tương ứng Ô2/Ô4.

```bash
mason make native_android_package   # has_ui: true
mason make native_ios_package       # has_ui: true (nếu cần cả iOS)
```

So với mục 2, package sinh ra có thêm `presentation/` (Compose/SwiftUI + `MviViewModel`), tự động kéo theo
`framework` (native) và áp convention Hilt+Compose (Android). Nếu `trigger=passive`, kết quả nhúng vào cây
widget Flutter qua `PlatformView`; nếu `trigger=os_triggered`, có `Activity`/overlay/Extension riêng, độc
lập `FlutterEngine`.

## 4. Nâng cấp package không-UI có sẵn thành có-UI

Dùng khi package đã tạo ở mục 2 (`has_ui=false`), giờ mới phát sinh nhu cầu UI — **không chạy lại brick**
(sẽ đè mất `platform/domain/data` đã viết).

```bash
# Android:
./scripts/native_add_ui_dependency_android.sh <ten_package>

# iOS (lệnh riêng, độc lập):
./scripts/native_add_ui_dependency_ios.sh <ten_package>
```

2 script này chỉ lo phần dễ sai nhất: thêm dependency `framework` + convention Hilt/Compose (Android) hoặc
`ios/framework` (iOS). Sau đó làm theo checklist thủ công (tạo `presentation/`, đăng ký
`PlatformViewFactory`/`Activity`) — xem
[template_android task 7](../../.devtool/epic/template_android/task_7_add_ui_dependency_tool.md) /
[template_ios task 7](../../.devtool/epic/template_ios/task_7_add_ui_dependency_tool_ios.md) để biết chi
tiết checklist.

## 5. Tạo 1 project Android Native độc lập từ template

Dùng khi bạn muốn viết 1 app Android thuần (không Flutter) nhưng vẫn muốn thừa hưởng bộ khung MVI +
tooling (Spotless/Detekt/Hilt/Compose) đã chuẩn hoá trong template.

```bash
./scripts/extract_native_standalone_android.sh ~/Projects/my_native_android_app
cd ~/Projects/my_native_android_app
git init
./gradlew :app:assembleDebug
```

Script copy `core`/`framework`/`buildSrc` (vốn đã không phụ thuộc Flutter) ra thư mục mới, sinh thêm 1
`settings.gradle.kts` + `app/` demo tối thiểu — thư mục này chạy được ngay, không liên quan gì Flutter.
**Không** copy `native_security`/`logger_native_bridge` (chúng là plugin Flutter, không thuộc bộ khung app
thuần). Xem [template_android task 9](../../.devtool/epic/template_android/task_9_standalone_extraction.md).

## 6. Tạo 1 project iOS Native độc lập từ template

```bash
./scripts/extract_native_standalone_ios.sh ~/Projects/my_native_ios_app
cd ~/Projects/my_native_ios_app
git init
open MyNativeIosApp.xcodeproj
```

Tương tự mục 5, copy `ios/core`/`ios/framework` ra 1 Xcode project mới tối giản, không dính
`Flutter.framework`. Xem
[template_ios task 9](../../.devtool/epic/template_ios/task_9_standalone_extraction.md).

## 7. Thêm binding Go vào 1 package native đã có

Dùng khi 1 package (đã tạo ở mục 2/3) cần gọi vào thư viện Go đã biên dịch (vd E2EE cho chat). Đây là
**guide + snippet copy-paste**, không có lệnh/brick tự động (mỗi thư viện Go có API khác nhau).

1. Đọc `docs/architecture/native-go-binding.md` (phần Android hoặc iOS tương ứng).
2. Đặt file `.aar` (Android, từ gomobile) hoặc `.xcframework` (iOS) vào `data/` của package.
3. Copy snippet panic-recovery vào đúng biên giới JNI (Android)/cgo (iOS) — **bắt buộc**, không được bỏ
   qua, nếu không 1 panic của Go sẽ crash cả app.
4. Nếu package là `trigger=os_triggered`: gọi Go trực tiếp từ Kotlin/Swift, không tạo headless Flutter
   engine chỉ để chạm tới Go.

Xem [template_android task 8](../../.devtool/epic/template_android/task_8_go_binding_guide.md) /
[template_ios task 8](../../.devtool/epic/template_ios/task_8_go_binding_guide_ios.md).

## 8. Xoá 1 feature package

```bash
mason make remove_pac_feature
# nhập tên feature cần xoá
```

Brick tự gỡ package khỏi `pubspec.yaml`, `injection.dart`, `app_router.dart`, translation providers — làm
ngược lại đúng những gì `pac_mvi_feature` (mục 1) đã nối vào.

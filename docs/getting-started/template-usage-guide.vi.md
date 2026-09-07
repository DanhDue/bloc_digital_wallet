# Hướng dẫn sử dụng Template

Guide thực hành theo từng use case — mỗi mục là một công việc cụ thể, kèm lệnh thực thi và tham chiếu kiến trúc. Xem [flutter_super_app_template](../../.devtool/epic/flutter_super_app_template/flutter_super_app_template.vi.md) để hiểu tổng quan kiến trúc monorepo trước khi bắt đầu.

> **Lưu ý về kiến trúc**: Các template native độc lập (app Android thuần hoặc iOS thuần không dùng Flutter) đã được tách sang các repository độc lập chuyên biệt. Trong repo Flutter Super App này, tính năng native được cung cấp thông qua mô hình Plugin Tri-Platform (`pac_native_plugin`) và thư viện dùng chung (`pac_library`).

---

## Mục lục
0. [Bắt đầu 1 project mới từ template](#0-bắt-đầu-1-project-mới-từ-template)
1. [Tạo 1 Flutter Feature mới (`features/`)](#1-tạo-1-flutter-feature-mới-features)
2. [Tạo 1 Thư viện dùng chung (`packages/`)](#2-tạo-1-thư-viện-dùng-chung-packages)
3. [Tạo Plugin Native KHÔNG UI (Headless Pigeon)](#3-tạo-plugin-native-không-ui-headless-pigeon)
4. [Tạo Plugin Native CÓ UI (Compose & SwiftUI)](#4-tạo-plugin-native-có-ui-compose--swiftui)
5. [Nâng cấp Plugin không-UI có sẵn thành có-UI](#5-nâng-cấp-plugin-không-ui-có-sẵn-thành-có-ui)
6. [Tạo Subfeature / Màn hình con trong Feature có sẵn](#6-tạo-subfeature--màn-hình-con-trong-feature-có-sẵn)
7. [Thêm binding Go vào 1 package native đã có](#7-thêm-binding-go-vào-1-package-native-đã-có)
8. [Xoá 1 feature package](#8-xoá-1-feature-package)

---

## 0. Bắt đầu 1 project mới từ template

Việc đầu tiên và bắt buộc trước mọi việc khác — mọi bước sau đều giả định bạn đã làm xong bước này.
> 📖 **Xem hướng dẫn chi tiết từng bước:** [create-new-project-from-template.vi.md](create-new-project-from-template.vi.md)

```bash
# 1. Clone và khởi tạo git mới
git clone <template-repo-url> my_new_app
cd my_new_app
rm -rf .git && git init

# 2. Đổi tên và nhận diện dự án (app_name, package_name, bundle_id)
./scripts/rename_project.sh "My New App" my_new_app com.mycompany.mynewapp

# 3. Đồng bộ cấu hình bảo mật (dev/stg/prd)
sh .agents/skills/copy_secure_configurations/resources/scripts/copy_secure_files.sh

# 4. Kiểm tra và chạy ứng dụng
melos run analyze
fvm flutter test
flutter run --flavor dev --dart-define-from-file=secureFiles/dev/environment-configs.json
```

`rename_project.sh` đổi tên package Dart, import trong `lib/`, `features/`, `applicationId`/bundle id, tên hiển thị app (Android & iOS) và tự động chạy `melos bootstrap` & `melos genAlls`. Sau bước này, `flutter run` sẽ mở thẳng vào Shell với các tab Home, Scanner, Settings.

---

## 1. Tạo 1 Flutter Feature mới (`features/`)

Dùng khi triển khai một tính năng nghiệp vụ người dùng (thuần Dart/Flutter theo Clean Architecture + MVI).

```bash
mason make pac_mvi_feature --name <ten_feature>
# ví dụ: mason make pac_mvi_feature --name wallet
```

- **Thư mục sinh ra:** `features/<ten_feature>/` (Clean Architecture: `data/`, `domain/`, `presentation/` với BLoC MVI).
- **Tự động liên kết:** Nối vào root `pubspec.yaml`, `lib/di/injection.dart`, `lib/app_router.dart`, hệ thống dịch đa ngôn ngữ Slang, và tự động chạy `melos bootstrap` + `./scripts/integrateFeatureToApp.sh <ten_feature>`.

---

## 2. Tạo 1 Thư viện dùng chung (`packages/`)

Dùng khi viết các module hạ tầng kỹ thuật dùng chung, tiện ích mạng, hoặc UI Kit không chứa nghiệp vụ đặc thù.

```bash
mason make pac_library --name <ten_thu_vien> --is_flutter true
```

- Chọn `--is_flutter false` cho các package thuần Dart không phụ thuộc Flutter framework.
- **Thư mục sinh ra:** `packages/<ten_thu_vien>/` và tự động đăng ký với Melos workspace.

---

## 3. Tạo Plugin Native KHÔNG UI (Headless Pigeon)

Dùng khi package cần gọi xuống các API native hệ thống (mã hóa phần cứng, sinh trắc học, cảm biến thiết bị) mà không hiển thị view native.

```bash
mason make pac_native_plugin --name <ten_plugin> --has_ui false
```

- **Thư mục sinh ra:** Plugin Tri-Platform tại `packages/<ten_plugin>/` tuân thủ Clean Architecture cho cả Android (Kotlin) và iOS (Swift), cầu nối tự động bằng Pigeon.
- Xử lý đồng bộ 2 nền tảng trong cùng 1 package thống nhất.

---

## 4. Tạo Plugin Native CÓ UI (Compose & SwiftUI)

Dùng khi tính năng đòi hỏi thành phần giao diện native hiệu năng cao (khung camera tùy biến, bản đồ native, view AR) nhúng vào Flutter qua `PlatformView`.

```bash
mason make pac_native_plugin --name <ten_plugin> --has_ui true
```

- **Thư mục sinh ra:** Bổ sung thêm tầng `presentation/` native (Jetpack Compose cho Android, SwiftUI cho iOS) kết hợp `MviViewModel` native.
- Tự động đăng ký `PlatformViewFactory` ở cả Kotlin và Swift.

---

## 5. Nâng cấp Plugin không-UI có sẵn thành có-UI

Dùng khi plugin đã tạo trước đó (`has_ui=false`), sau này phát sinh nhu cầu UI — **không chạy lại `pac_native_plugin`** (tránh ghi đè code nghiệp vụ domain/data đã viết).

```bash
mason make pac_add_native_ui --name <ten_plugin>
```

- **Tự động patch:** Cập nhật dependencies Jetpack Compose trong Gradle, iOS Podspec cho SwiftUI, sinh ViewModel MVI native và cầu nối `PlatformViewFactory`.

---

## 6. Tạo Subfeature / Màn hình con trong Feature có sẵn

Dùng khi thêm màn hình phụ hoặc luồng chức năng con vào trong một feature đã có (ví dụ: thêm `order_detail` vào `e_commerce`).

```bash
mason make pac_mvi_subfeature --package_name <ten_feature> --subfeature_name <ten_subfeature>
```

- Tái sử dụng repository và data source hiện có, tự động mở rộng method và sinh UI widget tương ứng.

---

## 7. Thêm binding Go vào 1 package native đã có

Dùng khi 1 package native cần gọi vào thư viện Go đã biên dịch (ví dụ: module mã hóa E2EE). Đây là tài liệu tích hợp thủ công:

1. Đặt file `.aar` (Android, từ gomobile) hoặc `.xcframework` (iOS) vào thư mục `data/` của package.
2. Sao chép snippet panic-recovery vào đúng biên giới JNI (Android) / cgo (iOS) — **bắt buộc**, tránh để panic của Go làm crash app host Flutter.
3. Nếu package chạy dạng `os_triggered`: gọi Go trực tiếp từ Kotlin/Swift, không khởi tạo FlutterEngine chạy nền chỉ để tương tác với Go.

---

## 8. Xoá 1 feature package

Dùng khi cần gỡ bỏ an toàn một feature package:

```bash
mason make remove_pac_feature --name <ten_feature>
```

- Brick tự động gỡ package khỏi `pubspec.yaml`, `injection.dart`, `app_router.dart`, và các nhà cung cấp bản dịch — dọn dẹp sạch sẽ các liên kết.

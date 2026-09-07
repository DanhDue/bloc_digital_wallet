# Hướng dẫn Khởi tạo Dự án Mới từ Flutter Super App Template

Tài liệu này hướng dẫn chi tiết từng bước để tạo và cấu hình một ứng dụng Flutter mới từ **Flutter Super App Template**, sử dụng công cụ tự động hóa đổi tên và nhận diện dự án (`rename_project.sh` / `pac_rename_project`).

---

## 📌 Mục lục
- [1. Quy trình 4 Bước Khởi tạo Nhanh](#1-quy-trình-4-bước-khởi-tạo-nhanh)
  - [Bước 1: Sao chép Template & Khởi tạo Git](#bước-1-sao-chép-template--khởi-tạo-git)
  - [Bước 2: Đổi tên và Nhận diện Dự án (1 lệnh duy nhất)](#bước-2-đổi-tên-và-nhận-diện-dự-án-1-lệnh-duy-nhất)
  - [Bước 3: Cấu hình Secure Files & Flavors](#bước-3-cấu-hình-secure-files--flavors)
  - [Bước 4: Kiểm tra & Khởi chạy Ứng dụng](#bước-4-kiểm-tra--khởi-chạy-ứng-dụng)
- [2. Cơ chế Tự động Hóa Dưới Nền (Under the Hood)](#2-cơ-chế-tự-động-hóa-dưới-nền-under-the-hood)
- [3. Phát triển Tính năng Mới với Mason Bricks](#3-phát-triển-tính-năng-mới-với-mason-bricks)
- [4. Các Lệnh Tiện ích Thường dùng](#4-các-lệnh-tiện-ích-thường-dùng)
- [5. Xử lý Sự cố Thường gặp (Troubleshooting)](#5-xử-lý-sự-cố-thường-gặp-troubleshooting)

---

## 1. Quy trình 4 Bước Khởi tạo Nhanh

### Bước 1: Sao chép Template & Khởi tạo Git

1. Clone template sang một thư mục mới cho dự án của bạn (ví dụ: `my_super_app`):
   ```bash
   git clone <URL_TEMPLATE_REPO> my_super_app
   cd my_super_app
   ```

2. Tách biệt lịch sử Git để biến thư mục thành dự án độc lập:
   ```bash
   # Xóa git cũ của template
   rm -rf .git

   # Khởi tạo repository mới
   git init
   git branch -M main
   ```

---

### Bước 2: Đổi tên và Nhận diện Dự án (1 lệnh duy nhất)

Template cung cấp script tự động hóa cross-platform (chạy được trên macOS, Linux, Windows):
```bash
./scripts/rename_project.sh "<App Name>" <package_name> <bundle_id>
```

#### Các tham số:
| Tham số | Định dạng | Ví dụ | Mô tả |
|---|---|---|---|
| `app_name` | Chuỗi hiển thị | `"My Super App"` | Tên ứng dụng hiển thị trên màn hình điện thoại |
| `package_name` | `snake_case` | `my_super_app` | Tên Dart package trong `pubspec.yaml` |
| `bundle_id` | `reverse-domain` | `com.company.mysuperapp` | Android Application ID / iOS Bundle Identifier |

#### Ví dụ thực tế:
```bash
./scripts/rename_project.sh "E-Commerce App" ecommerce_app com.mycompany.ecommerce
```

> **Ghi chú**: Nếu chạy `./scripts/rename_project.sh` không kèm tham số, CLI sẽ bật chế độ tương tác hỏi từng trường để bạn nhập lần lượt.

---

### Bước 3: Cấu hình Secure Files & Flavors

1. Cập nhật các thông số môi trường (Dev, Staging, Production) tại thư mục `secureFiles/`:
   - `secureFiles/dev/environment-configs.json`
   - `secureFiles/stg/environment-configs.json`
   - `secureFiles/prd/environment-configs.json`

2. *(Tùy chọn)* Nếu dự án tích hợp Firebase, sao chép file cấu hình tương ứng vào từng môi trường:
   - Android: `secureFiles/{dev,stg,prd}/google-services.json`
   - iOS: `secureFiles/{dev,stg,prd}/GoogleService-Info.plist`

3. Chạy script đồng bộ cấu hình vào các thư mục native Android và iOS:
   ```bash
   sh .agent/skills/copy_secure_configurations/resources/scripts/copy_secure_files.sh
   ```

---

### Bước 4: Kiểm tra & Khởi chạy Ứng dụng

Sau khi đổi tên và copy cấu hình, tiến hành xác thực dự án:

1. **Kiểm tra phân tích tĩnh (Static Analysis):**
   ```bash
   melos run analyze
   ```
   *Yêu cầu kết quả: `No issues found!`*

2. **Chạy bộ kiểm thử tự động (Unit / Widget Tests):**
   ```bash
   fvm flutter test
   ```

3. **Khởi chạy ứng dụng (Môi trường Dev):**
   ```bash
   # Chạy trên máy ảo/thiết bị thật với flavor dev
   flutter run --flavor dev --dart-define-from-file=secureFiles/dev/environment-configs.json
   ```

---

## 2. Cơ chế Tự động Hóa Dưới Nền (Under the Hood)

Script `./scripts/rename_project.sh` gọi Mason brick `pac_rename_project` với hook [post_gen.dart](../../bricks/pac_rename_project/hooks/post_gen.dart) viết bằng thuần Dart, tự động thực thi các tác vụ:

1. **Root Configuration:**
   - Cập nhật `name` trong `pubspec.yaml` và `melos.yaml`.
2. **Dart Source Code & Imports:**
   - Quét toàn bộ các thư mục `lib/`, `features/`, `test/`, `integration_test/`.
   - Chuyển toàn bộ `package:bloc_digital_wallet/...` thành `package:<package_name>/...`.
   - **Bảo toàn Vendor Lock:** Giữ nguyên các namespace và import của plugin native nội bộ `com.danhdue.*` (`packages/native_security`, `packages/logger_native_bridge`).
3. **Cấu hình Android Native:**
   - Cập nhật `namespace` và `applicationId` trong `android/app/build.gradle.kts`.
   - Đổi `DART_DEFINES_APP_NAME` thành tên hiển thị mới.
   - Tự động di chuyển `MainActivity.kt` sang đúng cấu trúc thư mục package mới `android/app/src/main/kotlin/<bundle/id>/` và cập nhật dòng khai báo `package <bundle_id>`.
4. **Cấu hình iOS Native:**
   - Cập nhật `PRODUCT_BUNDLE_IDENTIFIER` trong `ios/Runner.xcodeproj/project.pbxproj`.
   - Cập nhật tên app trong `ios/Runner/Info.plist`.
   - Cập nhật `BASE_ID` trong `ios/scripts/verify_flavors.sh`.
   - Cập nhật `DART_DEFINES_APP_NAME` tương ứng cho từng flavor trong `ios/Flutter/*.xcconfig`.
5. **Đồng bộ Dependencies & Code Generation:**
   - Tự động chạy `melos bootstrap`.
   - Tự động chạy `./scripts/genAlls.sh` (Slang localization code gen, `build_runner`, Freezed/Retrofit).

---

## 3. Phát triển Tính năng Mới với Mason Bricks

Sau khi khởi tạo dự án, bạn tiếp tục mở rộng ứng dụng bằng hệ thống Mason Bricks chuẩn hóa cho kiến trúc Super App:

### 1. Tạo Feature mới theo Clean Architecture + MVI (`features/`)
```bash
mason make pac_mvi_feature --name e_commerce
```
Sinh module tại `features/e_commerce` với đầy đủ các tầng `data`, `domain`, `presentation`, BLoC MVI, và tự động liên kết vào Router / DI của ứng dụng.

### 2. Tạo Màn hình con / Subfeature trong một Feature
```bash
mason make pac_mvi_subfeature --feature_name e_commerce --name order_detail
```

### 3. Tạo Thư viện thuần Dart/Flutter dùng chung (`packages/`)
```bash
mason make pac_library --name network_cache
```
Sinh package tiện ích tại `packages/network_cache` và tự động đăng ký với Melos workspace.

### 4. Tạo Native Plugin Tri-Platform (Android Kotlin + iOS Swift)
- **Không có UI (Chỉ gọi API native qua Pigeon bridge):**
  ```bash
  mason make pac_native_plugin --name biometric_auth --has_ui false
  ```
- **Có UI (Tích hợp Jetpack Compose và SwiftUI PlatformView):**
  ```bash
  mason make pac_native_plugin --name custom_scanner --has_ui true
  ```

### 5. Nâng cấp Plugin No-UI có sẵn lên With-UI (Compose & SwiftUI)
```bash
mason make pac_add_native_ui --plugin_name biometric_auth
```
Tự động patch Gradle, Podfile, sinh ViewModel MVI native và cầu nối `PlatformViewFactory`.

---

## 4. Các Lệnh Tiện ích Thường dùng

| Tác vụ | Lệnh | Ghi chú |
|---|---|---|
| **Sinh toàn bộ code** | `./scripts/genAlls.sh` | Chạy Slang l10n + `build_runner` trên toàn monorepo |
| **Sinh code cho file thay đổi** | `./scripts/genChanged.sh` | Tối ưu thời gian, chỉ chạy build_runner cho file bị sửa |
| **Kiểm tra ranh giới module** | `./scripts/check_module_boundaries.sh` | Đảm bảo tuân thủ kiến trúc phân tầng (Clean Architecture) |
| **Build APK Debug (Dev)** | `./scripts/buildApk.sh dev` | Build APK cho môi trường Dev |
| **Build APK Release (Stg/Prd)** | `./scripts/buildApk.sh prd` | Build APK cho môi trường Production |
| **Build iOS IPA** | `./scripts/buildIPA.sh prd` | Đóng gói ứng dụng iOS |

---

## 5. Xử lý Sự cố Thường gặp (Troubleshooting)

### Lỗi 1: `melos: command not found` hoặc `mason: command not found`
**Giải pháp:** Cài đặt công cụ toàn cục qua Dart SDK:
```bash
dart pub global activate melos
dart pub global activate mason_cli
mason get
```

### Lỗi 2: Xung đột cache hoặc build_runner bị lỗi
**Giải pháp:** Dọn dẹp cache và khởi động lại code generator:
```bash
./scripts/clean.sh
melos bootstrap
./scripts/genAlls.sh
```

### Lỗi 3: iOS Podfile / CocoaPods không nhận Bundle ID mới
**Giải pháp:** Cài đặt lại CocoaPods trong thư mục `ios/`:
```bash
cd ios
rm -rf Pods Podfile.lock .symlinks
pod install --repo-update
cd ..
```

# Hướng dẫn Khởi tạo Dự án Mới từ Flutter Super App Template

Tài liệu này hướng dẫn chi tiết từng bước để tạo và cấu hình một ứng dụng Flutter mới từ **Flutter Super App Template**, sử dụng công cụ tự động hóa đổi tên và nhận diện dự án (`rename_project.sh` / `pac_rename_project`).

Template được xây dựng với **Kiến trúc Dual-Mode** — chọn giữa **Enterprise Super App** (Shell 3 tab: Home, Scanner, Settings) hoặc **Lean Standalone App** (Shell 2 tab: Home, Settings). Bạn chọn chế độ khi tạo dự án, và có thể chuyển đổi bất cứ lúc nào sau đó.

---

## 📌 Mục lục
- [1. Chọn Chế Độ Template](#1-chọn-chế-độ-template)
- [2. Quy trình 4 Bước Khởi tạo Nhanh](#2-quy-trình-4-bước-khởi-tạo-nhanh)
  - [Bước 1: Sao chép Template & Khởi tạo Git](#bước-1-sao-chép-template--khởi-tạo-git)
  - [Bước 2: Đổi tên và Nhận diện Dự án (1 lệnh duy nhất)](#bước-2-đổi-tên-và-nhận-diện-dự-án-1-lệnh-duy-nhất)
  - [Bước 3: Cấu hình Secure Files & Flavors](#bước-3-cấu-hình-secure-files--flavors)
  - [Bước 4: Kiểm tra & Khởi chạy Ứng dụng](#bước-4-kiểm-tra--khởi-chạy-ứng-dụng)
- [3. Cơ chế Tự động Hóa Dưới Nền (Under the Hood)](#3-cơ-chế-tự-động-hóa-dưới-nền-under-the-hood)
  - [3.1 Cơ chế Đổi tên Dự án](#31-cơ-chế-đổi-tên-dự-án)
  - [3.2 Cơ chế Chuyển Đổi Chế Độ (`configure_mode.sh`)](#32-cơ-chế-chuyển-đổi-chế-độ-configure_modesh)
- [4. Phát triển Tính năng Mới với Mason Bricks](#4-phát-triển-tính-năng-mới-với-mason-bricks)
- [5. Các Lệnh Tiện ích Thường dùng](#5-các-lệnh-tiện-ích-thường-dùng)
- [6. Xử lý Sự cố Thường gặp (Troubleshooting)](#6-xử-lý-sự-cố-thường-gặp-troubleshooting)

---

## 1. Chọn Chế Độ Template

Trước khi bắt đầu, hãy chọn chế độ phù hợp với dự án của bạn:

| | **Enterprise** (mặc định) | **Lean** |
|---|---|---|
| **Shell Tabs** | 3 tab: Home, Scanner, Settings | 2 tab: Home, Settings |
| **Trường hợp sử dụng** | Super App với nhiều mini-app | Ứng dụng độc lập hoặc MVP |
| **Tính năng Scanner** | Hoạt động, liên kết với Router, DI, DeepLink | Ngắt kết nối (code vẫn còn nhưng không kích hoạt) |
| **Tùy chọn `--prune`** | Không áp dụng | Xóa vĩnh viễn code Scanner |

> **Gợi ý**: Bạn luôn có thể chuyển đổi chế độ sau bằng lệnh `./scripts/configure_mode.sh <enterprise|lean>`. Chọn `enterprise` nếu chưa chắc chắn.

---

## 2. Quy trình 4 Bước Khởi tạo Nhanh

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
./scripts/rename_project.sh "<App Name>" <package_name> <bundle_id> [--mode <enterprise|lean>]
```

#### Các tham số:
| Tham số | Định dạng | Ví dụ | Mô tả |
|---|---|---|---|
| `app_name` | Chuỗi hiển thị | `"My Super App"` | Tên ứng dụng hiển thị trên màn hình điện thoại |
| `package_name` | `snake_case` | `my_super_app` | Tên Dart package trong `pubspec.yaml` |
| `bundle_id` | `reverse-domain` | `com.company.mysuperapp` | Android Application ID / iOS Bundle Identifier |
| `--mode` | `enterprise` \| `lean` | `--mode lean` | *(Tùy chọn)* Chế độ template. Mặc định: `enterprise` |

#### Ví dụ thực tế:
```bash
# Chế độ Enterprise (mặc định) — Super App đầy đủ với Scanner + Settings
./scripts/rename_project.sh "E-Commerce App" ecommerce_app com.mycompany.ecommerce

# Chế độ Lean — ứng dụng độc lập chỉ có Settings, Scanner ngắt kết nối
./scripts/rename_project.sh "My MVP" my_mvp com.mycompany.mvp --mode lean
```

> **Ghi chú**: Nếu chạy `./scripts/rename_project.sh` không kèm tham số, CLI sẽ bật chế độ tương tác hỏi từng trường để bạn nhập lần lượt. Cờ `--mode` mặc định là `enterprise` khi không được chỉ định.

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
   ./scripts/copy_secure_files.sh
   ```

---

### Bước 4: Kiểm tra & Khởi chạy Ứng dụng

Sau khi đổi tên và copy cấu hình, tiến hành xác thực dự án:

1. **Bật Swift Package Manager (một lần cho mỗi máy):**
   ```bash
   flutter config --enable-swift-package-manager
   ```
   Các package native iOS của template (`logger_native_bridge`, `native_security`, và mọi thứ sinh bởi `pac_native_plugin`) được phân phối dưới dạng Swift Package, không phải CocoaPods pod. Yêu cầu Flutter ≥ 3.44. CocoaPods vẫn chạy song song với SPM cho các plugin bên thứ ba chưa hỗ trợ — không cần thao tác thêm.

2. **Kiểm tra phân tích tĩnh (Static Analysis):**
   ```bash
   melos run analyze
   ```
   *Yêu cầu kết quả: `No issues found!`*

3. **Chạy bộ kiểm thử tự động (Unit / Widget Tests):**
   ```bash
   fvm flutter test
   ```

4. **Khởi chạy ứng dụng (Môi trường Dev):**
   ```bash
   # Chạy trên máy ảo/thiết bị thật với flavor dev
   flutter run --flavor dev --dart-define-from-file=secureFiles/dev/environment-configs.json
   ```

---

## 3. Cơ chế Tự động Hóa Dưới Nền (Under the Hood)

### 3.1 Cơ chế Đổi tên Dự án

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
5. **Cấu hình Ứng dụng & Môi trường:**
   - Cập nhật `defaultValue` trong `lib/config/app_config.dart`.
   - Cập nhật `APP_NAME` trong `secureFiles/{dev,stg,prd}/environment-configs.json` và template resources.
   - Cập nhật tên cấu hình debug trong `.vscode/launch.json` và `.agents/skills/setup_variants/resources/launch.json`.
   - Cập nhật `project_name` trong `.agents/config.json`.
   - Cập nhật package imports trong toàn bộ các mẫu Mason `bricks/` (`bricks/mvi_feature`, `bricks/mvi_subfeature`).
6. **Cấu hình Chế độ:**
   - Khi `--mode lean` được chỉ định, ủy quyền cho `scripts/configure_mode.sh lean` để ngắt kết nối tính năng Scanner (xem bên dưới).
7. **Đồng bộ Dependencies & Code Generation:**
   - Tự động chạy `melos bootstrap`.
   - Tự động chạy `./scripts/genAlls.sh` (Slang localization code gen, `build_runner`, Freezed/Retrofit).

### 3.2 Cơ chế Chuyển Đổi Chế Độ (`configure_mode.sh`)

Script `./scripts/configure_mode.sh` chuyển đổi giữa chế độ **enterprise** và **lean** bằng cách thao tác trên các **vùng marker** (marker regions) được nhúng trong các file host chính:

```bash
./scripts/configure_mode.sh <enterprise|lean> [--prune] [--force] [--skip-verify]
```

#### Cơ chế hoạt động:

| File Mục tiêu | Tác dụng |
|---|---|
| `lib/shell/shell_page.dart` | Bật/tắt tab Scanner (3-tab ↔ 2-tab) |
| `lib/app_router.dart` | Comment/uncomment route Scanner |
| `lib/di/injection.dart` | Comment/uncomment module DI Scanner |
| `packages/platform/deeplink/` | Comment/uncomment đăng ký deep-link Scanner |

#### Các cờ:
| Cờ | Mô tả |
|---|---|
| `--prune` | **Chỉ dùng cho chế độ Lean.** Xóa vĩnh viễn thư mục `features/scanner` và các tham chiếu trong `pubspec.yaml`. Không thể hoàn tác nếu không dùng `git reset`. |
| `--force` | Bỏ qua kiểm tra an toàn dirty-tree khi sử dụng `--prune`. |
| `--skip-verify` | Bỏ qua bước xác minh tự động `melos bootstrap && melos run analyze` sau khi chuyển đổi. |

#### Chuyển đổi qua lại:
```bash
# Chuyển sang chế độ lean (ngắt kết nối Scanner, code vẫn còn trên đĩa)
./scripts/configure_mode.sh lean

# Chuyển lại chế độ enterprise (kích hoạt lại Scanner)
./scripts/configure_mode.sh enterprise

# Xóa vĩnh viễn Scanner (yêu cầu git tree sạch)
./scripts/configure_mode.sh lean --prune
```

> **An toàn**: `--prune` kiểm tra `git status --porcelain` trước khi xóa code. Nếu có thay đổi chưa commit, script sẽ dừng lại trừ khi `--force` được truyền vào.

---

## 4. Phát triển Tính năng Mới với Mason Bricks

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

Các plugin sinh ra bao gồm kiến trúc native production-ready sẵn dùng:
- **Android**: Kotlin 2.1.0, Kotlin DSL `build.gradle.kts`, KSP, **Pure Dagger 2** (`PluginComponentProvider` — không dùng Hilt), và **WorkManager** `DataSyncWorker` chạy nền với **không cần Flutter Engine** (tiết kiệm 150MB+ RAM).
- **iOS**: Swift Package Manager (`Package.swift`), **FactoryKit 3.3.2** (subclass `SharedContainer`), và **`BGTaskScheduler`** `DataSyncTask` chạy nền với **không cần Flutter Engine**.

### 5. Nâng cấp Plugin No-UI có sẵn lên With-UI (Compose & SwiftUI)
```bash
mason make pac_add_native_ui --plugin_name biometric_auth
```
Tự động bật Compose trong Gradle (Android), sinh ViewModel MVI native vào `ios/<name>/Sources/<name>/Presentation/` (layout Swift Package Manager — không đụng Podfile), và patch plugin class để đăng ký `PlatformViewFactory`. **DI hiện có (Dagger 2 / FactoryKit) và background workers (WorkManager / BGTaskScheduler) được bảo toàn nghiêm ngặt** — chỉ thêm tầng presentation.

---

## 5. Các Lệnh Tiện ích Thường dùng

| Tác vụ | Lệnh | Ghi chú |
|---|---|---|
| **Chuyển đổi chế độ template** | `./scripts/configure_mode.sh <enterprise\|lean>` | Bật/tắt giữa Shell 3-tab và 2-tab |
| **Sinh toàn bộ code** | `./scripts/genAlls.sh` | Chạy Slang l10n + `build_runner` trên toàn monorepo |
| **Sinh code cho file thay đổi** | `./scripts/genChanged.sh` | Tối ưu thời gian, chỉ chạy build_runner cho file bị sửa |
| **Kiểm tra ranh giới module** | `./scripts/check_module_boundaries.sh` | Đảm bảo tuân thủ kiến trúc phân tầng (Clean Architecture) |
| **Build APK Debug (Dev)** | `./scripts/buildApk.sh dev` | Build APK cho môi trường Dev |
| **Build APK Release (Stg/Prd)** | `./scripts/buildApk.sh prd` | Build APK cho môi trường Production |
| **Build iOS IPA** | `./scripts/buildIPA.sh prd` | Đóng gói ứng dụng iOS |

---

## 6. Xử lý Sự cố Thường gặp (Troubleshooting)

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

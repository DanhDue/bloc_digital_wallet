# Dynamic Configuration API Contract

This document defines the API contracts required from the Backend (BE) to support the dynamic update of Localizations (translations) and Themes. It is divided into two sections: **Client APIs** (used by the Mobile App) and **Admin APIs** (used by the CMS/Admin Dashboard for CRUD operations).

## Table of Contents
- [Versioning & Caching Strategy](#versioning--caching-strategy)
- [Part 1: Client APIs (Mobile App)](#part-1-client-apis-mobile-app)
  - [1.1 List Available Themes](#11-list-available-themes)
  - [1.2 Get Theme Details](#12-get-theme-details)
  - [1.3 Get Localization Overrides](#13-get-localization-overrides)
- [Part 2: Admin APIs (CMS)](#part-2-admin-apis-cms)
  - [2.1 Create a New Theme](#21-create-a-new-theme)
  - [2.2 Partial Update a Theme (Delta Update)](#22-partial-update-a-theme-delta-update)
  - [2.3 Delete a Theme](#23-delete-a-theme)
  - [2.4 Create a New Translation](#24-create-a-new-translation)
  - [2.5 List & Get Translations](#25-list--get-translations)
  - [2.6 Update Translations (Upsert/Patch)](#26-update-translations-upsertpatch)
  - [2.7 Delete a Translation](#27-delete-a-translation)
- [Appendix: Full Translation JSON Mocks](#appendix-full-translation-json-mocks)
  - [EN (English)](#en-english)
  - [VI (Vietnamese)](#vi-vietnamese)

### Related Documents
- [Dynamic Configuration HLD](./dynamic_configuration_hld.md) — Architecture overview, component responsibilities, sequence diagrams
- [User Preferences Sync API](./user_preferences_sync_api.md) — **NEW**: Per-user preferences, cross-device sync, delta versioning, and enhanced Bootstrap API

---

## Versioning & Caching Strategy
- **Versioning**: Every mutation (Create/Update/Delete) on a Theme or Translation should increment its `version` (e.g., semantic versioning or timestamp).
- **Caching**: Client APIs should support `ETag` or `Last-Modified` headers. If the version matches the mobile app's cached version, BE returns `304 Not Modified` to save bandwidth.

---

## Part 1: Client APIs (Mobile App)

These APIs are read-only and optimized for fast retrieval by the mobile application.

### 1.1 List Available Themes
`GET /api/v1/themes`

**Description**: Fetches the list of all available themes and their metadata so the App knows what themes can be downloaded. Can also indicate if a specific campaign theme is currently active.

**Response: `200 OK`**
```json
{
  "status": "success",
  "data": {
    "active_campaign_theme_id": "tet_holiday_special",
    "themes": [
      {
        "id": "default_light",
        "name": "Standard Light",
        "mode": "light",
        "version": "1.0.0",
        "thumbnail_url": "https://cdn.example.com/themes/light_thumb.png"
      },
      {
        "id": "tet_holiday_special",
        "name": "Tết Nguyên Đán",
        "mode": "light",
        "version": "2.1.0",
        "valid_from": "2026-01-20T00:00:00Z",
        "valid_to": "2026-02-15T00:00:00Z"
      }
    ]
  }
}
```

### 1.2 Get Theme Details
`GET /api/v1/themes/{theme_id}`

**Description**: Fetches the exact color palette, assets, and typography configurations for a specific theme.

**Query Parameters**:
- `version` (Optional): App's current cached version.
- `dpr` (Integer/Float, Optional): Device Pixel Ratio (e.g., `1`, `2`, `3`). Used by BE to return the optimal image resolution.

**Response: `200 OK`**
```json
{
  "status": "success",
  "data": {
    "version": "2.1.0",
    "theme": {
      "id": "tet_holiday_special",
      "colors": {
        "primary": "#E53935",
        "secondary": "#FFB300",
        "background": "#FFFFFF",
        "surface": "#F5F5F5",
        "error": "#D32F2F",
        "text_primary": "#212121"
      },
      "assets": {
        "home_banner": "https://cdn.example.com/assets/tet_banner_3x.png",
        "button_icon": "https://cdn.example.com/assets/ic_flower.svg"
      },
      "typography": {
        "global_font_family": "Roboto",
        "tokens": {
          "headline_large": {
            "font_size": 32,
            "font_weight": 700,
            "line_height": 40,
            "letter_spacing": 0.0
          },
          "body_regular": {
            "font_size": 14,
            "font_weight": 400,
            "line_height": 20,
            "letter_spacing": 0.25
          },
          "label_small": {
            "font_size": 11,
            "font_weight": 500,
            "line_height": 16,
            "letter_spacing": 0.5
          }
        }
      }
    }
  }
}
```

> **🖼️ Responsive Asset Strategy (Performance Optimization)**:
> Cách tối ưu nhất để code phía Mobile (UI) không bị "bẩn" bởi các vòng lặp if/else là phó thác việc tính toán URL cho Backend (Dựa vào request của Mobile).
> 
> 1. Khi gọi API `GET /api/v1/themes/{theme_id}`, Mobile App truyền thêm query parameter `?dpr=3` (lấy từ `MediaQuery.devicePixelRatioOf(context)`).
> 2. Backend đọc giá trị `dpr` này và trả về chuỗi URL duy nhất đã được "đo ni đóng giày" cho đúng resolution đó (ví dụ: trả về thẳng file `_3x.png`).
> 3. Mobile App parse JSON thành `String` đơn thuần và truyền thẳng vào UI `Image.network(theme.assets.homeBanner)`. Không thừa dữ liệu, không logic if/else phức tạp.



## Part 2: Admin APIs (CMS)

These APIs are used by the Backend Admin Portal to manage (Create, Update, Delete) themes and translations. 
*Note: All Admin APIs require appropriate Authorization (e.g., Bearer Token with Admin roles).*

### 2.1 Create a New Theme
`POST /api/v1/admin/themes`

**Request Body**:
```json
{
  "id": "summer_vibes",
  "name": "Summer Vibes",
  "mode": "light",
  "valid_from": "2026-06-01T00:00:00Z",
  "valid_to": "2026-08-31T00:00:00Z",
  "colors": {
    "primary": "#FF9800",
    "background": "#FFF3E0"
  },
  "assets": {
    "home_banner": {
      "1x": "https://cdn.example.com/assets/summer_1x.png",
      "2x": "https://cdn.example.com/assets/summer_2x.png",
      "3x": "https://cdn.example.com/assets/summer_3x.png"
    }
  },
  "typography": {
    "tokens": {
      "headline_large": {
        "font_size": 34
      }
    }
  }
}
```

**Response: `201 Created`**
*(Backend automatically generates `version: "1.0.0"` for the newly created theme).*

### 2.2 Partial Update a Theme (Delta Update)
`PATCH /api/v1/admin/themes/{theme_id}`

**Description**: Updates only the specific fields provided in the payload without replacing the entire theme. 
When the Backend receives this, it must perform a **deep merge** with the existing theme data, and **auto-increment** the `version` field (e.g., from `1.0.0` to `1.0.1`).

**Request Body** (Example: Only updating the primary color and one asset):
```json
{
  "colors": {
    "primary": "#F57C00"
  },
  "assets": {
    "home_banner": {
      "3x": "https://cdn.example.com/assets/summer_v2_3x.png"
    }
  }
}
```

**Response: `200 OK`**

> **💡 Asset Optimization Strategy (Mobile Side)**: 
> Although the CMS sends partial updates (`PATCH`), the `GET /api/v1/themes/{theme_id}` API for Mobile should ideally still return the **full JSON** (since the JSON is very lightweight, < 5KB).
> 
> **How Mobile saves bandwidth for Assets**:
> The JSON only contains **URLs** to assets. The Mobile App uses a local image cache (e.g., `cached_network_image`). 
> - If an asset changes, the CMS updates the URL (e.g., `tet_banner.png` -> `tet_banner_v2.png`).
> - The Mobile App downloads the new JSON, sees a new URL for `home_banner`, and downloads only the new image.
> - All other asset URLs remain unchanged, so the Mobile App instantly loads them from disk cache without re-downloading.

### 2.3 Delete a Theme
`DELETE /api/v1/admin/themes/{theme_id}`

**Description**: Deletes (hard or soft) a theme.
*Note: If the deleted theme is currently set as the `active_campaign_theme_id`, Backend must clear that setting to allow Apps to fallback to system defaults.*

**Response: `204 No Content`**

### 2.4 Create a New Translation
`POST /api/v1/translations`

**Description**: Creates a new translation record for a specific language (e.g., adding French `fr`).

**Request Body**:
```json
{
  "language_code": "fr",
  "language_name": "French",
  "translations": {
    "login_page": {
      "title": "Bienvenue",
      "submit_button": "Se connecter"
    }
  }
}
```

**Response: `201 Created`**
*(Backend automatically generates `version: "1.0.0"` for the newly created language).*

### 2.5 List & Get Translations

**A. List Available Languages**
`GET /api/v1/translations`

**Description**: Fetches the list of all supported languages and their metadata.

**Response: `200 OK`**
```json
{
  "status": "success",
  "data": [
    { "language_code": "en", "language_name": "English", "version": "1.0.5", "updated_at": "2026-08-10T10:00:00Z" },
    { "language_code": "vi", "language_name": "Vietnamese", "version": "1.0.2", "updated_at": "2026-08-11T12:00:00Z" }
  ]
}
```

**B. Get Translation Details (Unified & Delta Update)**
`GET /api/v1/translations/{language_code}`

**Description**: Fetches the full JSON tree for a specific language (used by CMS). It also supports delta updates for the Mobile Client via the `?since_version=` query parameter.

**Query Parameters**:
- `since_version` (Optional): The version the client currently has. If provided, returns a `delta` mode response.

**Response: `200 OK` (Delta mode example)**
```json
{
  "success": true,
  "message": "Translation retrieved",
  "data": {
    "mode": "delta",
    "version": "1.0.6",
    "checksum": "...",
    "translations": {
      "login_page": {
        "title": "Welcome Back V2"
      }
    },
    "deleted_keys": []
  }
}
```

### 2.6 Update Translations (Upsert/Patch)
`PATCH /api/v1/translations/{language_code}`

**Description**: Updates specific translation keys. The BE should perform a **deep merge** of these keys with existing ones and auto-increment the overall translation `version`.

**Request Body**:
```json
{
  "translations": {
    "login_page": {
      "title": "Welcome to Summer Edition"
    }
  }
}
```

**Response: `200 OK`**

### 2.7 Delete a Translation
`DELETE /api/v1/translations/{language_code}`

**Description**: Deletes or disables a language from the system.
*Note: Backend should prevent deletion of the default fallback language.*

**Response: `204 No Content`**

---

## Appendix: Full Translation JSON Mocks

This section provides the fully aggregated JSON payloads for English (`en`) and Vietnamese (`vi`) localizations. Backend can use these structures to mock responses for the Client APIs (`GET /api/v1/translations/{language_code}`) and as a base tree for Admin CMS.

### en_US (English)
```json
{
  "common": {
    "appName": "Digital Wallet"
  },
  "transaction": {
    "title": "Transaction Feature",
    "noData": "No Data",
    "history": {
      "received": "Received",
      "sent": "Sent"
    },
    "bitcoin": {
      "wallet": "Bitcoin Wallet",
      "received": "Received BTC",
      "sent": "Sent BTC"
    }
  },
  "settings": {
    "title": "Settings",
    "account": {
      "title": "Account",
      "profile": "Edit Profile",
      "changePassword": "Change Password",
      "twoFactorAuth": "Two-Factor Auth (2FA)",
      "twoFactorAuthOn": "On",
      "twoFactorAuthOff": "Off"
    },
    "preferences": {
      "title": "Preferences",
      "currency": "Currency / Units",
      "currencyUsd": "USD (\\$)",
      "language": "Language",
      "languageEnglish": "English",
      "darkMode": "Dark Mode"
    },
    "developer": {
      "title": "Developer",
      "debugMode": "Debug Mode"
    },
    "appInfo": {
      "title": "App Info",
      "contactSupport": "Contact Support",
      "aboutApp": "About App",
      "defaultVersion": "v2.4.12"
    },
    "logout": "Logout",
    "errorOccurred": "An error occurred"
  },
  "home": {
    "main": {
      "title": "Home",
      "exitToast": "Press back again to exit"
    },
    "nav": {
      "wallet": "Wallet",
      "browser": "Browser",
      "qrScanner": "Scan",
      "trends": "Trends",
      "settings": "Settings"
    }
  },
  "core": {
    "common": {
      "error": "An error occurred. Please try again later!",
      "close": "Close",
      "skip": "Skip",
      "cancel": "Cancel",
      "finish": "Finish",
      "success": "Success",
      "failure": "Failure",
      "commingSoon": "Coming Soon",
      "commingSoonDescription": "This feature is coming soon",
      "enterYourEmail": "Enter your email",
      "subscribe": "Subscribe",
      "processing": "Processing...",
      "qrCodeIsSaveToGallery": "QR Code saved to gallery"
    }
  },
  "onboard": {
    "splash": {
      "digitalWallet": "Digital Wallet",
      "serviceHealthChecking": "Zeno Service health checking...",
      "restartServiceWarning": "Please wait just a minutes for restart Zeno service! @@"
    },
    "intro": {
      "zenoWallet": "Zeno Wallet",
      "swipeToGetStarted": "Swipe to get started",
      "secureCryptoWalletTitle": "The Most\nSecure & Easiest\nCrypto Wallet",
      "manageDigitalAssets": "Manage all your digital assets in one secure place.",
      "gettingStarted": "Let's go"
    }
  },
  "trends": {
    "title": "Trends Feature",
    "search": {
      "hint": "Search coins...",
      "noRecentSearches": "No recent searches",
      "recentSearches": "Recent Searches",
      "noCoinsFound": "No coins found"
    },
    "error": {
      "retry": "Retry",
      "message": "An error occurred"
    }
  },
  "wallet": {
    "title": "Wallet Feature",
    "wallet": {
      "actionSend": "Send",
      "actionReceive": "Receive",
      "actionBuy": "Buy",
      "actionStaking": "Staking"
    },
    "networkSelection": {
      "selectNetwork": "All Networks",
      "search": "Search",
      "error": "An error occurred"
    },
    "nftsList": {
      "title": "NFTs",
      "notFoundMessage": "No NFTs Found",
      "addNft": "Add NFT",
      "error": "An error occurred"
    },
    "tokenList": {
      "title": "Tokens",
      "notFoundMessage": "No Tokens Found",
      "addToken": "Add Token",
      "error": "An error occurred",
      "hiddenBalance": "****"
    },
    "walletList": {
      "account": "Account $index",
      "copied": "Wallet address copied and will be cleared in 30 seconds",
      "noWalletsFound": "No wallets found"
    }
  },
  "scanner": {
    "title": "Scanner Feature"
  },
  "authentication": {
    "login": {
      "welcomeBack": "Welcome Back",
      "loginToContinue": "Login to continue",
      "email": "Email",
      "enterYourEmail": "Enter your email",
      "password": "Password",
      "enterYourPassword": "Enter your password",
      "loginButton": "Login",
      "or": "OR",
      "continueWithGoogle": "Continue with Google",
      "googleLoginTapped": "Google login tapped (UI only).",
      "continueWithApple": "Continue with Apple",
      "appleLoginTapped": "Apple login tapped (UI only).",
      "continueWithFacebook": "Continue with Facebook",
      "facebookLoginTapped": "Facebook login tapped (UI only).",
      "dontHaveAccount": "Don't have an account?",
      "emailNotFound": "No account found with this email address",
      "invalidEmailFormat": "Please enter a valid email address",
      "signUpButton": "Sign up"
    },
    "signUp": {
      "title": "Sign Up",
      "createAccount": "Create Account",
      "createYourAccount": "Create your account to get started",
      "firstName": "First Name",
      "firstNameHint": "John",
      "lastName": "Last Name",
      "lastNameHint": "Doe",
      "phoneNumber": "Phone Number",
      "enterYourPhone": "Enter your phone",
      "dateOfBirth": "Date of Birth",
      "selectYourBirthday": "Select your birthday",
      "selectDate": "Select date",
      "createAPassword": "Create a password",
      "pleaseSelectDob": "Please select your date of birth",
      "alreadyHaveAccount": "Already have an account?",
      "backToLogin": "Back to Login",
      "loginButton": "Login"
    },
    "forgotPassword": {
      "title": "Forgot password",
      "tapped": "Forgot Password?",
      "tappedUIOnly": "Forgot password tapped (UI only).",
      "subtitle": "Please enter your email to reset the password",
      "emailLabel": "Your Email",
      "emailHint": "contact@example.com",
      "submitButton": "Reset Password",
      "success": "Password reset email sent! Check your inbox.",
      "codeFormatInvalid": "Please enter a valid 5-digit code",
      "checkYourEmail": "Check your email",
      "enterCodeInstruction": "enter 5 digit code that mentioned in the email",
      "verifyCode": "Verify Code",
      "resendEmail": "Resend email"
    }
  }
}
```

### vi_VN (Tiếng Việt)
```json
{
  "common": {
    "appName": "Ví Điện Tử"
  },
  "transaction": {
    "title": "Tính năng Transaction",
    "noData": "Không có dữ liệu",
    "history": {
      "received": "Đã nhận",
      "sent": "Đã gửi"
    },
    "bitcoin": {
      "wallet": "Ví Bitcoin",
      "received": "Đã nhận BTC",
      "sent": "Đã gửi BTC"
    }
  },
  "settings": {
    "title": "Cài đặt",
    "account": {
      "title": "Tài khoản",
      "profile": "Chỉnh sửa hồ sơ",
      "changePassword": "Đổi mật khẩu",
      "twoFactorAuth": "Xác thực 2 yếu tố (2FA)",
      "twoFactorAuthOn": "Bật",
      "twoFactorAuthOff": "Tắt"
    },
    "preferences": {
      "title": "Tùy chọn",
      "currency": "Tiền tệ / Đơn vị",
      "currencyUsd": "USD (\\$)",
      "language": "Ngôn ngữ",
      "languageEnglish": "Tiếng Anh",
      "darkMode": "Chế độ tối"
    },
    "developer": {
      "title": "Nhà phát triển",
      "debugMode": "Chế độ gỡ lỗi"
    },
    "appInfo": {
      "title": "Thông tin ứng dụng",
      "contactSupport": "Liên hệ hỗ trợ",
      "aboutApp": "Về ứng dụng",
      "defaultVersion": "v2.4.12"
    },
    "logout": "Đăng xuất",
    "errorOccurred": "Đã xảy ra lỗi"
  },
  "home": {
    "main": {
      "title": "Trang chủ",
      "exitToast": "Nhấn lần nữa để thoát"
    },
    "nav": {
      "wallet": "Ví",
      "browser": "Giao dịch",
      "qrScanner": "Quét",
      "trends": "Xu hướng",
      "settings": "Cài đặt"
    }
  },
  "core": {
    "common": {
      "error": "Đã có lỗi xảy ra. Vui lòng thử lại sau!",
      "close": "Đóng",
      "skip": "Bỏ qua",
      "cancel": "Hủy",
      "finish": "Hoàn thành",
      "success": "Thành công",
      "failure": "Thất bại",
      "commingSoon": "Sắp ra mắt",
      "commingSoonDescription": "Tính năng này sắp ra mắt",
      "enterYourEmail": "Nhập email của bạn",
      "subscribe": "Đăng ký",
      "processing": "Đang xử lý...",
      "qrCodeIsSaveToGallery": "Mã QR đã được lưu vào thư viện"
    }
  },
  "trends": {
    "title": "Tính năng Trends",
    "search": {
      "hint": "Tìm kiếm coins...",
      "noRecentSearches": "Không có tìm kiếm gần đây",
      "recentSearches": "Tìm Kiếm Gần Đây",
      "noCoinsFound": "Không tìm thấy coins"
    },
    "error": {
      "retry": "Thử lại",
      "message": "Đã xảy ra lỗi"
    }
  },
  "wallet": {
    "title": "Tính năng Ví",
    "wallet": {
      "actionSend": "Gửi",
      "actionReceive": "Nhận",
      "actionBuy": "Mua",
      "actionStaking": "Staking"
    },
    "networkSelection": {
      "selectNetwork": "Tất cả mạng",
      "search": "Tìm kiếm",
      "error": "Đã xảy ra lỗi"
    },
    "nftsList": {
      "title": "NFTs",
      "notFoundMessage": "Không tìm thấy NFT",
      "addNft": "Thêm NFT",
      "error": "Đã xảy ra lỗi"
    },
    "tokenList": {
      "title": "Tokens",
      "notFoundMessage": "Không tìm thấy Token",
      "addToken": "Thêm Token",
      "error": "Đã xảy ra lỗi",
      "hiddenBalance": "****"
    },
    "walletList": {
      "account": "Tài khoản $index",
      "copied": "Đã sao chép địa chỉ ví và sẽ được xóa sau 30 giây",
      "noWalletsFound": "Không tìm thấy ví nào"
    }
  },
  "scanner": {
    "title": "Tính năng Scanner"
  },
  "authentication": {
    "login": {
      "welcomeBack": "Chào mừng trở lại",
      "loginToContinue": "Đăng nhập để tiếp tục",
      "email": "Email",
      "enterYourEmail": "Nhập email của bạn",
      "password": "Mật khẩu",
      "enterYourPassword": "Nhập mật khẩu",
      "loginButton": "Đăng nhập",
      "or": "HOẶC",
      "continueWithGoogle": "Tiếp tục với Google",
      "googleLoginTapped": "Đăng nhập Google đã được nhấn (chỉ giao diện).",
      "continueWithApple": "Tiếp tục với Apple",
      "appleLoginTapped": "Đăng nhập Apple đã được nhấn (chỉ giao diện).",
      "continueWithFacebook": "Tiếp tục với Facebook",
      "facebookLoginTapped": "Đăng nhập Facebook đã được nhấn (chỉ giao diện).",
      "dontHaveAccount": "Chưa có tài khoản?",
      "emailNotFound": "Không tìm thấy tài khoản với email này",
      "invalidEmailFormat": "Vui lòng nhập địa chỉ email hợp lệ",
      "signUpButton": "Đăng ký"
    },
    "signUp": {
      "title": "Đăng ký",
      "createAccount": "Tạo tài khoản",
      "createYourAccount": "Tạo tài khoản của bạn để bắt đầu",
      "firstName": "Tên",
      "firstNameHint": "Văn",
      "lastName": "Họ",
      "lastNameHint": "Nguyễn",
      "phoneNumber": "Số điện thoại",
      "enterYourPhone": "Nhập số điện thoại",
      "dateOfBirth": "Ngày sinh",
      "selectYourBirthday": "Chọn ngày sinh",
      "selectDate": "Chọn ngày",
      "createAPassword": "Tạo mật khẩu",
      "pleaseSelectDob": "Vui lòng chọn ngày sinh của bạn",
      "alreadyHaveAccount": "Đã có tài khoản?",
      "backToLogin": "Quay lại đăng nhập",
      "loginButton": "Đăng nhập"
    },
    "forgotPassword": {
      "title": "Quên mật khẩu",
      "tapped": "Quên mật khẩu?",
      "tappedUIOnly": "Quên mật khẩu đã được nhấn (chỉ giao diện).",
      "subtitle": "Vui lòng nhập email để đặt lại mật khẩu",
      "emailLabel": "Email của bạn",
      "emailHint": "contact@example.com",
      "submitButton": "Đặt lại mật khẩu",
      "success": "Email đặt lại mật khẩu đã được gửi! Kiểm tra hộp thư của bạn.",
      "codeFormatInvalid": "Vui lòng nhập mã 5 chữ số hợp lệ",
      "checkYourEmail": "Kiểm tra email",
      "enterCodeInstruction": "nhập mã 5 chữ số được đề cập trong email",
      "verifyCode": "Xác minh mã",
      "resendEmail": "Gửi lại email"
    }
  }
}
```

### ko_KR (한국어 - Korean)
```json
{
  "common": {
    "appName": "디지털 지갑"
  },
  "transaction": {
    "title": "거래 기능",
    "noData": "데이터 없음",
    "history": {
      "received": "받음",
      "sent": "보냄"
    },
    "bitcoin": {
      "wallet": "비트코인 지갑",
      "received": "BTC 받음",
      "sent": "BTC 보냄"
    }
  },
  "settings": {
    "title": "설정",
    "account": {
      "title": "계정",
      "profile": "프로필 편집",
      "changePassword": "비밀번호 변경",
      "twoFactorAuth": "2단계 인증 (2FA)",
      "twoFactorAuthOn": "켜짐",
      "twoFactorAuthOff": "꺼짐"
    },
    "preferences": {
      "title": "환경설정",
      "currency": "통화 / 단위",
      "currencyUsd": "USD (\\$)",
      "language": "언어",
      "languageEnglish": "영어",
      "darkMode": "다크 모드"
    },
    "developer": {
      "title": "개발자",
      "debugMode": "디버그 모드"
    },
    "appInfo": {
      "title": "앱 정보",
      "contactSupport": "고객 지원 문의",
      "aboutApp": "앱 정보",
      "defaultVersion": "v2.4.12"
    },
    "logout": "로그아웃",
    "errorOccurred": "오류가 발생했습니다"
  },
  "home": {
    "main": {
      "title": "홈",
      "exitToast": "뒤로 버튼을 한 번 더 누르면 종료됩니다"
    },
    "nav": {
      "wallet": "지갑",
      "browser": "브라우저",
      "qrScanner": "스캔",
      "trends": "트렌드",
      "settings": "설정"
    }
  },
  "core": {
    "common": {
      "error": "오류가 발생했습니다. 나중에 다시 시도해 주세요!",
      "close": "닫기",
      "skip": "건너뛰기",
      "cancel": "취소",
      "finish": "완료",
      "success": "성공",
      "failure": "실패",
      "commingSoon": "출시 예정",
      "commingSoonDescription": "이 기능은 곧 출시될 예정입니다",
      "enterYourEmail": "이메일을 입력하세요",
      "subscribe": "구독",
      "processing": "처리 중...",
      "qrCodeIsSaveToGallery": "QR 코드가 갤러리에 저장되었습니다"
    }
  },
  "onboard": {
    "splash": {
      "digitalWallet": "디지털 지갑",
      "serviceHealthChecking": "Zeno 서비스 상태 확인 중...",
      "restartServiceWarning": "Zeno 서비스를 재시작하는 중입니다. 잠시만 기다려 주세요! @@"
    },
    "intro": {
      "zenoWallet": "제노 지갑",
      "swipeToGetStarted": "스와이프하여 시작하기",
      "secureCryptoWalletTitle": "가장 안전하고\n쉬운\n암호화폐 지갑",
      "manageDigitalAssets": "모든 디지털 자산을 한 곳에서 안전하게 관리하세요.",
      "gettingStarted": "시작하기"
    }
  },
  "trends": {
    "title": "트렌드 기능",
    "search": {
      "hint": "코인 검색...",
      "noRecentSearches": "최근 검색어 없음",
      "recentSearches": "최근 검색어",
      "noCoinsFound": "코인을 찾을 수 없습니다"
    },
    "error": {
      "retry": "다시 시도",
      "message": "오류가 발생했습니다"
    }
  },
  "wallet": {
    "title": "지갑 기능",
    "wallet": {
      "actionSend": "보내기",
      "actionReceive": "받기",
      "actionBuy": "구매",
      "actionStaking": "스테이킹"
    },
    "networkSelection": {
      "selectNetwork": "모든 네트워크",
      "search": "검색",
      "error": "오류가 발생했습니다"
    },
    "nftsList": {
      "title": "NFT",
      "notFoundMessage": "NFT를 찾을 수 없습니다",
      "addNft": "NFT 추가",
      "error": "오류가 발생했습니다"
    },
    "tokenList": {
      "title": "토큰",
      "notFoundMessage": "토큰을 찾을 수 없습니다",
      "addToken": "토큰 추가",
      "error": "오류가 발생했습니다",
      "hiddenBalance": "****"
    },
    "walletList": {
      "account": "계정 $index",
      "copied": "지갑 주소가 복사되었습니다. 30초 후에 삭제됩니다.",
      "noWalletsFound": "지갑을 찾을 수 없습니다"
    }
  },
  "scanner": {
    "title": "스캐너 기능"
  },
  "authentication": {
    "login": {
      "welcomeBack": "다시 오신 것을 환영합니다",
      "loginToContinue": "계속하려면 로그인하세요",
      "email": "이메일",
      "enterYourEmail": "이메일을 입력하세요",
      "password": "비밀번호",
      "enterYourPassword": "비밀번호를 입력하세요",
      "loginButton": "로그인",
      "or": "또는",
      "continueWithGoogle": "Google로 계속하기",
      "googleLoginTapped": "Google 로그인 탭됨 (UI 전용).",
      "continueWithApple": "Apple로 계속하기",
      "appleLoginTapped": "Apple 로그인 탭됨 (UI 전용).",
      "continueWithFacebook": "Facebook으로 계속하기",
      "facebookLoginTapped": "Facebook 로그인 탭됨 (UI 전용).",
      "dontHaveAccount": "계정이 없으신가요?",
      "emailNotFound": "이 이메일 주소로 등록된 계정을 찾을 수 없습니다",
      "invalidEmailFormat": "유효한 이메일 주소를 입력하세요",
      "signUpButton": "회원가입"
    },
    "signUp": {
      "title": "회원가입",
      "createAccount": "계정 만들기",
      "createYourAccount": "시작하려면 계정을 만드세요",
      "firstName": "이름",
      "firstNameHint": "길동",
      "lastName": "성",
      "lastNameHint": "홍",
      "phoneNumber": "전화번호",
      "enterYourPhone": "전화번호를 입력하세요",
      "dateOfBirth": "생년월일",
      "selectYourBirthday": "생일 선택",
      "selectDate": "날짜 선택",
      "createAPassword": "비밀번호 만들기",
      "pleaseSelectDob": "생년월일을 선택해 주세요",
      "alreadyHaveAccount": "이미 계정이 있으신가요?",
      "backToLogin": "로그인으로 돌아가기",
      "loginButton": "로그인"
    },
    "forgotPassword": {
      "title": "비밀번호 찾기",
      "tapped": "비밀번호를 잊으셨나요?",
      "tappedUIOnly": "비밀번호 찾기 탭됨 (UI 전용).",
      "subtitle": "비밀번호를 재설정하려면 이메일을 입력하세요",
      "emailLabel": "이메일",
      "emailHint": "contact@example.com",
      "submitButton": "비밀번호 재설정",
      "success": "비밀번호 재설정 이메일이 전송되었습니다! 받은편지함을 확인하세요.",
      "codeFormatInvalid": "유효한 5자리 코드를 입력하세요",
      "checkYourEmail": "이메일을 확인하세요",
      "enterCodeInstruction": "이메일에 기재된 5자리 코드를 입력하세요",
      "verifyCode": "코드 확인",
      "resendEmail": "이메일 다시 보내기"
    }
  }
}
```

### ja_JP (日本語 - Japanese)
```json
{
  "common": {
    "appName": "デジタルウォレット"
  },
  "transaction": {
    "title": "トランザクション機能",
    "noData": "データなし",
    "history": {
      "received": "受け取り",
      "sent": "送信"
    },
    "bitcoin": {
      "wallet": "ビットコインウォレット",
      "received": "BTCを受け取りました",
      "sent": "BTCを送信しました"
    }
  },
  "settings": {
    "title": "設定",
    "account": {
      "title": "アカウント",
      "profile": "プロフィール編集",
      "changePassword": "パスワード変更",
      "twoFactorAuth": "2段階認証 (2FA)",
      "twoFactorAuthOn": "オン",
      "twoFactorAuthOff": "オフ"
    },
    "preferences": {
      "title": "環境設定",
      "currency": "通貨 / 単位",
      "currencyUsd": "USD (\\$)",
      "language": "言語",
      "languageEnglish": "英語",
      "darkMode": "ダークモード"
    },
    "developer": {
      "title": "開発者",
      "debugMode": "デバッグモード"
    },
    "appInfo": {
      "title": "アプリ情報",
      "contactSupport": "サポートに連絡",
      "aboutApp": "アプリについて",
      "defaultVersion": "v2.4.12"
    },
    "logout": "ログアウト",
    "errorOccurred": "エラーが発生しました"
  },
  "home": {
    "main": {
      "title": "ホーム",
      "exitToast": "もう一度戻るボタンを押すと終了します"
    },
    "nav": {
      "wallet": "ウォレット",
      "browser": "ブラウザ",
      "qrScanner": "スキャン",
      "trends": "トレンド",
      "settings": "設定"
    }
  },
  "core": {
    "common": {
      "error": "エラーが発生しました。後でもう一度お試しください！",
      "close": "閉じる",
      "skip": "スキップ",
      "cancel": "キャンセル",
      "finish": "完了",
      "success": "成功",
      "failure": "失敗",
      "commingSoon": "近日公開",
      "commingSoonDescription": "この機能は近日公開予定です",
      "enterYourEmail": "メールアドレスを入力してください",
      "subscribe": "購読する",
      "processing": "処理中...",
      "qrCodeIsSaveToGallery": "QRコードがギャラリーに保存されました"
    }
  },
  "onboard": {
    "splash": {
      "digitalWallet": "デジタルウォレット",
      "serviceHealthChecking": "Zenoサービスの状態を確認中...",
      "restartServiceWarning": "Zenoサービスを再起動しています。少々お待ちください！ @@"
    },
    "intro": {
      "zenoWallet": "ゼノウォレット",
      "swipeToGetStarted": "スワイプして開始",
      "secureCryptoWalletTitle": "最も安全で\n簡単な\n暗号資産ウォレット",
      "manageDigitalAssets": "すべてのデジタル資産を1つの安全な場所で管理します。",
      "gettingStarted": "始める"
    }
  },
  "trends": {
    "title": "トレンド機能",
    "search": {
      "hint": "コインを検索...",
      "noRecentSearches": "最近の検索はありません",
      "recentSearches": "最近の検索",
      "noCoinsFound": "コインが見つかりません"
    },
    "error": {
      "retry": "再試行",
      "message": "エラーが発生しました"
    }
  },
  "wallet": {
    "title": "ウォレット機能",
    "wallet": {
      "actionSend": "送信",
      "actionReceive": "受け取り",
      "actionBuy": "購入",
      "actionStaking": "ステーキング"
    },
    "networkSelection": {
      "selectNetwork": "すべてのネットワーク",
      "search": "検索",
      "error": "エラーが発生しました"
    },
    "nftsList": {
      "title": "NFT",
      "notFoundMessage": "NFTが見つかりません",
      "addNft": "NFTを追加",
      "error": "エラーが発生しました"
    },
    "tokenList": {
      "title": "トークン",
      "notFoundMessage": "トークンが見つかりません",
      "addToken": "トークンを追加",
      "error": "エラーが発生しました",
      "hiddenBalance": "****"
    },
    "walletList": {
      "account": "アカウント $index",
      "copied": "ウォレットアドレスがコピーされました。30秒後に消去されます。",
      "noWalletsFound": "ウォレットが見つかりません"
    }
  },
  "scanner": {
    "title": "スキャナー機能"
  },
  "authentication": {
    "login": {
      "welcomeBack": "お帰りなさい",
      "loginToContinue": "ログインして続行",
      "email": "メール",
      "enterYourEmail": "メールアドレスを入力してください",
      "password": "パスワード",
      "enterYourPassword": "パスワードを入力してください",
      "loginButton": "ログイン",
      "or": "または",
      "continueWithGoogle": "Googleで続行",
      "googleLoginTapped": "Googleログインがタップされました（UIのみ）。",
      "continueWithApple": "Appleで続行",
      "appleLoginTapped": "Appleログインがタップされました（UIのみ）。",
      "continueWithFacebook": "Facebookで続行",
      "facebookLoginTapped": "Facebookログインがタップされました（UIのみ）。",
      "dontHaveAccount": "アカウントをお持ちではありませんか？",
      "emailNotFound": "このメールアドレスの登録が見つかりません",
      "invalidEmailFormat": "有効なメールアドレスを入力してください",
      "signUpButton": "サインアップ"
    },
    "signUp": {
      "title": "サインアップ",
      "createAccount": "アカウント作成",
      "createYourAccount": "アカウントを作成して始めましょう",
      "firstName": "名",
      "firstNameHint": "太郎",
      "lastName": "姓",
      "lastNameHint": "山田",
      "phoneNumber": "電話番号",
      "enterYourPhone": "電話番号を入力してください",
      "dateOfBirth": "生年月日",
      "selectYourBirthday": "誕生日を選択",
      "selectDate": "日付を選択",
      "createAPassword": "パスワードを作成",
      "pleaseSelectDob": "生年月日を選択してください",
      "alreadyHaveAccount": "すでにアカウントをお持ちですか？",
      "backToLogin": "ログインに戻る",
      "loginButton": "ログイン"
    },
    "forgotPassword": {
      "title": "パスワードを忘れた場合",
      "tapped": "パスワードをお忘れですか？",
      "tappedUIOnly": "パスワードを忘れた場合がタップされました（UIのみ）。",
      "subtitle": "パスワードをリセットするにはメールアドレスを入力してください",
      "emailLabel": "メールアドレス",
      "emailHint": "contact@example.com",
      "submitButton": "パスワードをリセット",
      "success": "パスワードリセットのメールが送信されました！受信トレイを確認してください。",
      "codeFormatInvalid": "有効な5桁のコードを入力してください",
      "checkYourEmail": "メールを確認",
      "enterCodeInstruction": "メールに記載されている5桁のコードを入力してください",
      "verifyCode": "コードを確認",
      "resendEmail": "メールを再送信"
    }
  }
}
```

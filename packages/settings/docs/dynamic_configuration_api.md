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

### 1.3 Get Localization Overrides
`GET /api/v1/translations/{language_code}`

**Description**: Fetches the translation JSON for a specific language (e.g., `en`, `vi`).

**Response: `200 OK`**
```json
{
  "status": "success",
  "data": {
    "version": "1.0.5",
    "translations": {
      "login_page": {
        "title": "Welcome Back",
        "submit_button": "Log In"
      }
    }
  }
}
```
*(The `translations` object must match the exact tree structure defined in the application's `.i18n.json` files).*

---

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
`POST /api/v1/admin/translations`

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
`GET /api/v1/admin/translations`

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

**B. Get Translation Details**
`GET /api/v1/admin/translations/{language_code}`

**Description**: Fetches the full JSON tree for a specific language. This is similar to the Client API but may include audit information.

**Response: `200 OK`**

### 2.6 Update Translations (Upsert/Patch)
`PATCH /api/v1/admin/translations/{language_code}`

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
`DELETE /api/v1/admin/translations/{language_code}`

**Description**: Deletes or disables a language from the system.
*Note: Backend should prevent deletion of the default fallback language.*

**Response: `204 No Content`**

---

## Appendix: Full Translation JSON Mocks

This section provides the fully aggregated JSON payloads for English (`en`) and Vietnamese (`vi`) localizations. Backend can use these structures to mock responses for the Client APIs (`GET /api/v1/translations/{language_code}`) and as a base tree for Admin CMS.

### EN (English)
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

### VI (Vietnamese)
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

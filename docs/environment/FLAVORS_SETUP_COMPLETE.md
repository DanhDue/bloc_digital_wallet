# Flutter Flavors + Environment Configuration - UPDATED

**Complete setup matching flutter_digital_wallet project**

---

## 🎯 What Changed

This project now uses **Android flavors + dart-defines** approach, matching your `flutter_digital_wallet` project exactly!

### Key Benefits:
✅ Android flavors for different signing configs (dev/stg use debug, prd uses release)  
✅ Environment variables via `--dart-define-from-file`  
✅ Dynamic app names and application IDs  
✅ Single `main.dart` entry point  
✅ VS Code integration with `--flavor` argument  

---

## 📁 Project Structure

```
bloc_digital_wallet/
├── android/app/build.gradle.kts       # ✨ NEW: Parses dart-defines + flavors
├── lib/
│   ├── main.dart                      # Single entry point
│   └── config/
│       └── environment_config.dart    # Config helper
├── secureFiles/
│   ├── dev/environment-configs.json   # APP_NAME, APP_ID_SUFFIX, etc.
│   ├── stg/environment-configs.json
│   ├── prd/environment-configs.json
│   └── signing/                       # ✨ NEW: Keystores
│       ├── debug.keystore             # For dev/stg
│       ├── keystore.properties        # For prd (you create)
│       └── your-release.keystore      # For prd (you create)
└── .vscode/launch.json                # ✨ UPDATED: Includes --flavor
```

---

## 🔧 How It Works

### 1. Environment Config JSON
**File**: `secureFiles/dev/environment-configs.json`
```json
{
  "APP_NAME": "Digital Wallet Dev",
  "APP_ID_SUFFIX": ".dev",
  "ENVIRONMENT": "development",
  "API_BASE_URL": "https://dev-api.example.com",
  ...
}
```

### 2. Flutter Passes to Gradle
```bash
flutter run \
  --flavor dev \
  --dart-define-from-file=secureFiles/dev/environment-configs.json
```

### 3. Gradle Parses Dart-Defines
```kotlin
// build.gradle.kts automatically parses dart-defines
applicationId = "com.example.bloc_digital_wallet"
applicationIdSuffix = ".dev"  // from APP_ID_SUFFIX
resValue("string", "app_name", "Digital Wallet Dev")  // from APP_NAME
```

### 4. Result
- **App ID**: `com.example.bloc_digital_wallet.dev`
- **App Name**: "Digital Wallet Dev"
- **Signing**: Debug keystore (for dev/stg) or Release keystore (for prd)
- **Config**: All environment variables accessible via `EnvironmentConfig`

---

## 🚀 Running the App

### Via VS Code (Recommended)
1. Press **F5** or open Run & Debug
2. Select: `Digital Wallet (dev-debug)`
3. App runs with:
   - Flavor: `dev`
   - Environment: development
   - App ID: `com.example.bloc_digital_wallet.dev`
   - Signing: debug keystore

### Via Terminal
```bash
# Development
flutter run \
  --flavor dev \
  --dart-define-from-file=secureFiles/dev/environment-configs.json

# Staging
flutter run \
  --flavor stg \
  --dart-define-from-file=secureFiles/stg/environment-configs.json

# Production
flutter run \
  --flavor prd \
  --dart-define-from-file=secureFiles/prd/environment-configs.json \
  --release
```

---

## 📦 Building for Release

### Android APK
```bash
# Set BUILD_FLAVOR in scripts/buildConfigs/.env.info
./scripts/buildApk.sh

# Or directly:
flutter build apk \
  --flavor dev \
  --dart-define-from-file=secureFiles/dev/environment-configs.json \
  --release
```

### iOS IPA
```bash
./scripts/buildIPA.sh

# Or directly:
flutter build ipa \
  --flavor dev \
  --dart-define-from-file=secureFiles/dev/environment-configs.json \
  --release
```

---

## 🔐 Android Signing Setup

### Development & Staging (Uses Debug Keystore)
Already configured! Uses `secureFiles/signing/debug.keystore`

### Production (Requires Release Keystore)

#### 1. Generate Release Keystore
```bash
cd secureFiles/signing
keytool -genkey -v -keystore release.keystore \
  -alias bloc-wallet-key \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

#### 2. Create `keystore.properties`
```bash
cd secureFiles/signing
cp keystore.properties.template keystore.properties
```

Edit `keystore.properties`:
```properties
storeFile=release.keystore
storePassword=your-store-password
keyAlias=bloc-wallet-key
keyPassword=your-key-password
```

#### 3. Build Production
```bash
flutter build apk --flavor prd \
  --dart-define-from-file=secureFiles/prd/environment-configs.json \
  --release
```

---

## 🆚 Comparison: Old vs New

| Aspect | Before (Earlier Today) | Now (Like flutter_digital_wallet) |
|--------|------------------------|-----------------------------------|
| **Android Flavors** | ❌ None | ✅ dev, stg, prd |
| **Signing Configs** | ❌ Debug only | ✅ Debug (dev/stg) + Release (prd) |
| **App ID Suffix** | ❌ Manual | ✅ Dynamic from dart-defines |
| **App Name** | ❌ Static | ✅ Dynamic from dart-defines |
| **Build Command** | `--dart-define-from-file` only | `--flavor` + `--dart-define-from-file` |
| **Multiple Apps** | ❌ Can't install together | ✅ dev, stg, prd side-by-side |

---

## 📊 Application IDs

| Environment | Application ID | App Name | Signing |
|-------------|----------------|----------|---------|
| **dev** | `com.example.bloc_digital_wallet.dev` | Digital Wallet Dev | Debug |
| **stg** | `com.example.bloc_digital_wallet.stg` | Digital Wallet Staging | Debug |
| **prd** | `com.example.bloc_digital_wallet` | Digital Wallet | Release |

**Benefit**: All 3 apps can be installed on the same device simultaneously!

---

## 💻 Using Config in Code

Same as before - no changes needed:

```dart
import 'package:bloc_digital_wallet/config/environment_config.dart';

// Access values
final appName = EnvironmentConfig.appName;
final apiUrl = EnvironmentConfig.fullApiUrl;

// Check environment
if (EnvironmentConfig.isDevelopment) {
  print('Dev mode');
}
```

---

## 🔍 What Gradle Does

### Parses Dart-Defines
```kotlin
// From --dart-define-from-file
val dartEnvironmentVariables = mutableMapOf(
    "DART_DEFINES_APP_NAME" to "Wallet",
    "DART_DEFINES_APP_ID_SUFFIX" to null,
)

// Automatically parsed from Flutter
if (project.hasProperty("dart-defines")) {
    // Decodes base64 encoded values
    // Populates dartEnvironmentVariables
}
```

### Applies to Build
```kotlin
defaultConfig {
    applicationId = "com.example.bloc_digital_wallet"
    applicationIdSuffix = dartEnvironmentVariables["DART_DEFINES_APP_ID_SUFFIX"]
    versionNameSuffix = dartEnvironmentVariables["DART_DEFINES_APP_ID_SUFFIX"]
    resValue("string", "app_name", dartEnvironmentVariables["DART_DEFINES_APP_NAME"])
}
```

---

## 🎯 Key Files Modified

### Created
- `secureFiles/signing/debug.keystore` - Debug signing
- `secureFiles/signing/keystore.properties.template` - Production signing template
- `secureFiles/signing/README.md` - Signing documentation

### Updated
- `android/app/build.gradle.kts` - Added dart-defines parsing + flavors
- `android/app/src/main/AndroidManifest.xml` - Uses `@string/app_name`
- `secureFiles/*/environment-configs.json` - Added `APP_ID_SUFFIX`
- `.vscode/launch.json` - Added `--flavor` argument
- `scripts/buildApk.sh` - Added `--flavor` argument
- `scripts/buildIPA.sh` - Added `--flavor` argument
- `scripts/buildBundle.sh` - Added `--flavor` argument

---

## 🆕 Adding New Environment

### 1. Create Config
```bash
mkdir -p secureFiles/qa
cat > secureFiles/qa/environment-configs.json << 'EOF'
{
  "APP_NAME": "Digital Wallet QA",
  "APP_ID_SUFFIX": ".qa",
  "ENVIRONMENT": "qa",
  "API_BASE_URL": "https://qa-api.example.com",
  ...
}
EOF
```

### 2. Add Android Flavor
Edit `android/app/build.gradle.kts`:
```kotlin
productFlavors {
    create("qa") {
        dimension = "default"
        signingConfig = signingConfigs.getByName("development")
    }
}
```

### 3. Add VS Code Config
```json
{
  "name": "Digital Wallet (qa-debug)",
  "program": "lib/main.dart",
  "args": [
    "--dart-define-from-file",
    "secureFiles/qa/environment-configs.json",
    "--flavor",
    "qa"
  ]
}
```

### 4. Run
```bash
flutter run --flavor qa \
  --dart-define-from-file=secureFiles/qa/environment-configs.json
```

---

## ⚠️ Important Notes

### Security
```gitignore
# Already in .gitignore
secureFiles/
secureFiles/**/*.json
secureFiles/signing/
```

**NEVER commit:**
- `secureFiles/signing/*.keystore`
- `secureFiles/signing/keystore.properties`
- `secureFiles/*/environment-configs.json`

### iOS Flavors
iOS **does not** use product flavors the same way. The `--flavor` argument is passed but iOS builds use the same bundle ID. For iOS, you would need to:
1. Create separate schemes in Xcode (optional)
2. Or use xcconfig files to customize per environment
3. Or accept same bundle ID for all environments

---

## 📚 Documentation

- **[ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md)** - Complete guide (updated)
- **[ENVIRONMENT_QUICK_START.md](ENVIRONMENT_QUICK_START.md)** - Quick reference (updated)
- **[secureFiles/signing/README.md](../../secureFiles/signing/README.md)** - Signing setup

---

## ✅ What You Get

### Development Benefits
✅ Install dev, stg, prd apps side-by-side on same device  
✅ Different app icons possible (via flavor)  
✅ Different Firebase projects per flavor  
✅ Automatic signing (debug for dev/stg, release for prd)  
✅ Dynamic app names and IDs  

### Production Benefits
✅ Separate release signing for production  
✅ ProGuard rules applied correctly  
✅ Proper app store submission  
✅ Environment-specific configurations  

---

## 🎉 Summary

Your project now matches the **flutter_digital_wallet** setup:

1. **Android Flavors**: dev, stg, prd with proper signing
2. **Dart-Defines**: All config from JSON files
3. **Dynamic Values**: App name, ID suffix parsed by Gradle
4. **Single Codebase**: One `main.dart` for all environments
5. **VS Code Ready**: Just press F5 and select environment

**All benefits of both approaches combined! 🚀**

---

**Last Updated**: 2026-01-11  
**Matches**: flutter_digital_wallet project structure  
**Status**: ✅ Production Ready

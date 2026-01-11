# Environment Setup - Quick Reference

**TL;DR: This project uses `--dart-define-from-file` instead of Flutter flavors**

---

## 🚀 Quick Start

### Run in VS Code
1. Press **F5** or **Cmd+Shift+D**
2. Select environment:
   - `Digital Wallet (dev-debug)` ← Start here
   - `Digital Wallet (stg-debug)`
   - `Digital Wallet (prd-release)`

### Run from Terminal
```bash
# Development
flutter run --dart-define-from-file=secureFiles/dev/environment-configs.json

# Staging
flutter run --dart-define-from-file=secureFiles/stg/environment-configs.json

# Production
flutter run --dart-define-from-file=secureFiles/prd/environment-configs.json --release
```

---

## 📁 Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Single entry point (no flavors!) |
| `lib/config/environment_config.dart` | Config helper class |
| `secureFiles/dev/environment-configs.json` | Dev config ⚠️ gitignored |
| `secureFiles/stg/environment-configs.json` | Staging config ⚠️ gitignored |
| `secureFiles/prd/environment-configs.json` | Production config ⚠️ gitignored |
| `.vscode/launch.json` | VS Code run configurations |

---

## 💻 Using Config in Code

```dart
import 'package:bloc_digital_wallet/config/environment_config.dart';

// Get values
final appName = EnvironmentConfig.appName;
final apiUrl = EnvironmentConfig.fullApiUrl;

// Check environment
if (EnvironmentConfig.isDevelopment) {
  // Dev-only code
}

if (EnvironmentConfig.isProduction) {
  // Production code
}

// Conditional logging
if (EnvironmentConfig.enableLogging) {
  logger.log('Something happened');
}
```

---

## 🔧 Configuration Keys

**In `secureFiles/{env}/environment-configs.json`:**

```json
{
  "APP_NAME": "Digital Wallet Dev",
  "APP_SUFFIX": "dev",
  "ENVIRONMENT": "development",
  "API_BASE_URL": "https://dev-api.example.com",
  "API_VERSION": "v1",
  "ENABLE_LOGGING": "true",
  "ENABLE_ANALYTICS": "false",
  "SHOW_DEBUG_BANNER": "true"
}
```

---

## 📦 Building

```bash
# APK
./scripts/buildApk.sh

# IPA
./scripts/buildIPA.sh

# App Bundle
./scripts/buildBundle.sh
```

⚠️ **Set environment first in `scripts/buildConfigs/.env.info`**

---

## 🆕 Add New Environment

1. **Create config file:**
   ```bash
   mkdir -p secureFiles/new-env
   cp secureFiles/dev/environment-configs.json secureFiles/new-env/
   # Edit values
   ```

2. **Add to VS Code** (`.vscode/launch.json`):
   ```json
   {
     "name": "Digital Wallet (new-env-debug)",
     "type": "dart",
     "program": "lib/main.dart",
     "args": [
       "--dart-define-from-file",
       "secureFiles/new-env/environment-configs.json"
     ]
   }
   ```

That's it! No Android/iOS changes needed.

---

## 🔐 Security

**⚠️ NEVER commit `secureFiles/` to git!**

Already in `.gitignore`:
```gitignore
secureFiles/
secureFiles/**/*.json
```

---

## ❓ Troubleshooting

### App using default values?
- Check file path in launch config
- Verify JSON is valid
- Run `flutter clean`

### Wrong environment showing?
- Check selected run configuration in VS Code
- Verify correct `--dart-define-from-file` path

### File not found?
- Ensure file exists: `ls secureFiles/dev/`
- Check file permissions
- Try absolute path

---

## 📚 Full Documentation

See **[ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md)** for complete guide.

---

**Key Benefits:**
- ✅ No Android/iOS flavor configuration needed
- ✅ Single entry point (`main.dart`)
- ✅ Easy to add environments (just JSON)
- ✅ Type-safe configuration
- ✅ CI/CD friendly

**vs Traditional Flavors:**
| This Approach | Flavors |
|--------------|---------|
| 1 JSON file | Android + iOS configs |
| No platform code | Schemes, build types, etc. |
| 5 minutes setup | 1-2 hours setup |
| Easy debugging | Complex debugging |

---

**Last Updated**: 2026-01-11

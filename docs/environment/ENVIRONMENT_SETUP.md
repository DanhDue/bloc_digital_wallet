# Environment Setup Guide

**Complete guide for managing multiple environments using `--dart-define-from-file`**

---

## 🎯 Overview

This project uses **environment-based configuration** instead of traditional Flutter flavors. This approach:

- ✅ Simpler than flavors (no Android/iOS flavor configuration needed)
- ✅ Works with single codebase entry point (`lib/main.dart`)
- ✅ Easy to add new environments
- ✅ Configuration via JSON files
- ✅ Type-safe access via `EnvironmentConfig` class

---

## 📁 Project Structure

```
bloc_digital_wallet/
├── lib/
│   ├── main.dart                          # Single entry point
│   └── config/
│       └── environment_config.dart        # Environment configuration helper
├── secureFiles/                           # ⚠️ Never commit to git!
│   ├── dev/
│   │   └── environment-configs.json       # Development config
│   ├── stg/
│   │   └── environment-configs.json       # Staging config
│   └── prd/
│       └── environment-configs.json       # Production config
├── .vscode/
│   └── launch.json                        # VS Code launch configurations
└── scripts/
    ├── buildApk.sh                        # Build Android APK
    ├── buildIPA.sh                        # Build iOS IPA
    └── buildBundle.sh                     # Build Android App Bundle
```

---

## 🔧 Available Environments

### 1. Development (dev)
- **API**: `https://dev-api.example.com`
- **Features**: Debug banner, extensive logging
- **Use for**: Local development, testing

### 2. Staging (stg)
- **API**: `https://stg-api.example.com`
- **Features**: Debug banner, logging, analytics enabled
- **Use for**: QA testing, pre-production validation

### 3. Production (prd)
- **API**: `https://api.example.com`
- **Features**: No debug banner, minimal logging, analytics enabled
- **Use for**: Production release

---

## 🚀 Running the App

### Via VS Code

1. Open VS Code
2. Go to **Run and Debug** (Cmd+Shift+D / Ctrl+Shift+D)
3. Select a configuration:
   - `Digital Wallet (dev-debug)` - Development debug
   - `Digital Wallet (stg-debug)` - Staging debug
   - `Digital Wallet (prd-release)` - Production release
4. Press **F5** or click **Start Debugging**

### Via Command Line

#### Development
```bash
flutter run \
  --dart-define-from-file=secureFiles/dev/environment-configs.json
```

#### Staging
```bash
flutter run \
  --dart-define-from-file=secureFiles/stg/environment-configs.json
```

#### Production
```bash
flutter run \
  --dart-define-from-file=secureFiles/prd/environment-configs.json \
  --release
```

---

## 📦 Building for Release

### Android APK

```bash
# Set environment in scripts/buildConfigs/.env.info
# BUILD_FLAVOR=dev|stg|prd
./scripts/buildApk.sh
```

### iOS IPA

```bash
# Set environment in scripts/buildConfigs/.env.info
# BUILD_FLAVOR=dev|stg|prd
./scripts/buildIPA.sh
```

### Android App Bundle

```bash
# Set environment in scripts/buildConfigs/.env.info
# BUILD_FLAVOR=dev|stg|prd
./scripts/buildBundle.sh
```

---

## ⚙️ Configuration Files

### Environment Config JSON Structure

**File**: `secureFiles/{env}/environment-configs.json`

```json
{
  "APP_NAME": "Digital Wallet Dev",
  "APP_SUFFIX": "dev",
  "ENVIRONMENT": "development",
  "API_BASE_URL": "https://dev-api.example.com",
  "API_VERSION": "v1",
  "ENABLE_LOGGING": "true",
  "ENABLE_ANALYTICS": "false",
  "SHOW_DEBUG_BANNER": "true",
  "FIREBASE_OPTIONS": {
    "apiKey": "your-api-key",
    "projectId": "your-project-id",
    "messagingSenderId": "your-sender-id",
    "appId": "your-app-id"
  }
}
```

### Available Configuration Keys

| Key | Type | Description |
|-----|------|-------------|
| `APP_NAME` | String | App display name |
| `APP_SUFFIX` | String | Environment suffix (dev/stg/prd) |
| `ENVIRONMENT` | String | Environment name (development/staging/production) |
| `API_BASE_URL` | String | Base URL for API |
| `API_VERSION` | String | API version |
| `ENABLE_LOGGING` | Boolean | Enable console logging |
| `ENABLE_ANALYTICS` | Boolean | Enable analytics tracking |
| `SHOW_DEBUG_BANNER` | Boolean | Show debug banner |
| `FIREBASE_OPTIONS` | Object | Firebase configuration |

---

## 💻 Using Environment Config in Code

### Import the Config

```dart
import 'package:bloc_digital_wallet/config/environment_config.dart';
```

### Access Configuration

```dart
// App name
final appName = EnvironmentConfig.appName;

// API URL
final apiUrl = EnvironmentConfig.apiBaseUrl;
final fullApiUrl = EnvironmentConfig.fullApiUrl; // includes version

// Check environment
if (EnvironmentConfig.isDevelopment) {
  print('Running in development mode');
}

if (EnvironmentConfig.isProduction) {
  // Production-only code
}

// Logging
if (EnvironmentConfig.enableLogging) {
  print('Log something');
}
```

### Print All Configuration

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Print environment config (only in dev/stg)
  EnvironmentConfig.printConfig();
  
  runApp(const MyApp());
}
```

---

## 🔐 Security Best Practices

### ⚠️ IMPORTANT: Never Commit Sensitive Files

Add to `.gitignore`:

```gitignore
# Environment configurations
secureFiles/
secureFiles/**/*.json
scripts/buildConfigs/.env.info

# Keep only templates
!secureFiles/README.md
!secureFiles/**/environment-configs.json.template
```

### Secure Storage

1. **Local Development**: Keep files in `secureFiles/` folder (gitignored)
2. **CI/CD**: Store as encrypted secrets in your CI/CD platform
3. **Team Sharing**: Use secure password managers or secret management tools

### Environment Variables

For CI/CD, you can also use environment variables:

```bash
export APP_NAME="Digital Wallet Dev"
export API_BASE_URL="https://dev-api.example.com"

# Then use --dart-define instead
flutter build apk \
  --dart-define=APP_NAME="$APP_NAME" \
  --dart-define=API_BASE_URL="$API_BASE_URL"
```

---

## 🆕 Adding a New Environment

### 1. Create Config File

```bash
mkdir -p secureFiles/new-env
touch secureFiles/new-env/environment-configs.json
```

### 2. Add Configuration

Copy from existing environment and modify values.

### 3. Add VS Code Launch Config

Edit `.vscode/launch.json`:

```json
{
  "name": "Digital Wallet (new-env-debug)",
  "request": "launch",
  "type": "dart",
  "program": "lib/main.dart",
  "args": [
    "--dart-define-from-file",
    "secureFiles/new-env/environment-configs.json"
  ]
}
```

### 4. Update Build Scripts

Add new environment to `scripts/buildConfigs/.env.info` if needed.

---

## 🔍 Debugging

### Check Current Environment

The app displays current environment in:
1. **Console output** on startup (if logging enabled)
2. **App bar** (in dev/stg builds)
3. **Home screen** with colored indicator

### Verify Configuration

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Print all config
  EnvironmentConfig.printConfig();
  
  // Check specific values
  print('API: ${EnvironmentConfig.fullApiUrl}');
  print('Is Production: ${EnvironmentConfig.isProduction}');
  
  runApp(const MyApp());
}
```

### Common Issues

#### 1. Config not loading

**Problem**: Default values are used instead of config file values.

**Solution**: 
- Check file path in launch configuration
- Verify JSON is valid (use JSON validator)
- Ensure no trailing commas in JSON

#### 2. Wrong environment

**Problem**: App shows wrong environment.

**Solution**:
- Check `--dart-define-from-file` path in launch args
- Verify correct environment selected in VS Code
- Clean build: `flutter clean && flutter pub get`

#### 3. Can't find config file

**Problem**: File not found error.

**Solution**:
- Ensure file exists: `ls -la secureFiles/dev/`
- Check file permissions: `chmod 644 secureFiles/dev/environment-configs.json`
- Use absolute path if needed

---

## 📝 Example: API Configuration

### 1. Define in Config File

`secureFiles/dev/environment-configs.json`:
```json
{
  "API_BASE_URL": "https://dev-api.example.com",
  "API_VERSION": "v1",
  "API_TIMEOUT": "30000"
}
```

### 2. Add to EnvironmentConfig

`lib/config/environment_config.dart`:
```dart
class EnvironmentConfig {
  static const String apiTimeout = String.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: '30000',
  );
  
  static int get apiTimeoutMs => int.parse(apiTimeout);
}
```

### 3. Use in Dio Setup

```dart
final dio = Dio(
  BaseOptions(
    baseUrl: EnvironmentConfig.fullApiUrl,
    connectTimeout: Duration(milliseconds: EnvironmentConfig.apiTimeoutMs),
    headers: {
      'Accept': 'application/json',
    },
  ),
);
```

---

## 🎯 Benefits of This Approach

### vs Traditional Flavors

| Feature | This Approach | Traditional Flavors |
|---------|---------------|---------------------|
| Setup complexity | ⭐⭐ (Simple) | ⭐⭐⭐⭐⭐ (Complex) |
| Android config | ✅ Not needed | ❌ Required |
| iOS config | ✅ Not needed | ❌ Required (schemes) |
| Entry points | ✅ Single `main.dart` | ❌ Multiple files |
| Add environment | ✅ JSON file only | ❌ Android + iOS changes |
| CI/CD friendly | ✅ Very easy | ⭐⭐⭐ Moderate |

### Advantages

1. **Simple Configuration**: Just JSON files
2. **No Platform Code**: No Android/iOS flavor setup needed
3. **Easy to Add**: New environments = new JSON file
4. **Type-Safe**: Compile-time constant values
5. **Flexible**: Can switch environments without rebuilding
6. **CI/CD Ready**: Easy to inject via environment variables

---

## 📚 Related Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - Overall architecture
- [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) - Feature implementation
- [DOUBLE_CHECK_GUIDE.md](DOUBLE_CHECK_GUIDE.md) - Quality checks

---

## 🤝 Team Workflow

### For Developers

1. **Setup**: Get `environment-configs.json` files from team
2. **Develop**: Use dev environment in VS Code
3. **Test**: Switch to stg environment for testing
4. **Never commit**: Keep `secureFiles/` in `.gitignore`

### For CI/CD

1. **Store secrets** in CI/CD platform (GitHub Secrets, GitLab CI/CD variables)
2. **Create files** in build pipeline
3. **Build** with `--dart-define-from-file`
4. **Clean up** after build

### For QA

1. **Request builds** with specific environment
2. **Verify** environment indicator in app
3. **Test** against correct API endpoints

---

## ❓ FAQ

### Q: Can I use flavors AND dart-define?

**A**: Yes, but it adds unnecessary complexity. This approach replaces the need for flavors.

### Q: How do I change API URL without rebuilding?

**A**: You can't change compile-time constants. But you can:
1. Use remote config (Firebase Remote Config)
2. Add runtime config override for dev builds

### Q: What if I need different app icons?

**A**: You can:
1. Use `flutter_launcher_icons` with different configs
2. Script icon replacement in build scripts
3. Use dynamic icon changing packages

### Q: How do I handle different bundle IDs?

**A**: For iOS, you can use different build configurations. For Android, you can use `--dart-define` to set application ID dynamically in `build.gradle.kts`.

---

**Last Updated**: 2026-01-11  
**Maintained By**: DanhDue ExOICTIF

---

**Remember**: Keep your environment files secure! 🔐

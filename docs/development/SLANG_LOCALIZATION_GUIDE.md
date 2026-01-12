# Slang Localization Guide

**Comprehensive guide for using slang for multilingual support in bloc_digital_wallet**

---

## 🎯 Overview

This project uses [slang](https://pub.dev/packages/slang) and [slang_flutter](https://pub.dev/packages/slang_flutter) for type-safe, compile-time checked localization with support for:

- **English (en)** - Base locale
- **Vietnamese (vi)** - Secondary locale

---

## 📁 Project Structure

```
bloc_digital_wallet/
├── assets/locales/
│   ├── en.i18n.json         # English translations (base)
│   ├── vi.i18n.json         # Vietnamese translations
│   ├── en_US.json           # Legacy (kept for reference)
│   └── vn_VI.json           # Legacy (kept for reference)
├── lib/generated/
│   ├── translations.dart    # Main translations file
│   ├── translations_en.g.dart
│   └── translations_vi.g.dart
└── build.yaml               # slang configuration
```

---

## 🚀 Quick Start

### Accessing Translations

There are two ways to access translations in your widgets:

#### Method A: Simple (No Rebuild on Locale Change)

```dart
import 'package:bloc_digital_wallet/generated/translations.dart';

// Use directly with `t`
final text = t.authWelcomeBack;
final email = t.authEmail;
```

#### Method B: Context Extension (Rebuilds on Locale Change) ✅ **Recommended**

```dart
import 'package:bloc_digital_wallet/generated/translations.dart';

// In widget build method
@override
Widget build(BuildContext context) {
  return Text(context.t.authWelcomeBack);
}
```

**Always use `context.t` in widgets** to ensure proper rebuilding when locale changes.

---

## 📝 Adding New Translations

### Step 1: Add Keys to JSON Files

**English** (`assets/locales/en.i18n.json`):
```json
{
  "myNewKey": "My new text in English",
  "myNestedKey": {
    "title": "Nested Title",
    "description": "Nested Description"
  }
}
```

**Vietnamese** (`assets/locales/vi.i18n.json`):
```json
{
  "myNewKey": "Văn bản mới bằng tiếng Việt",
  "myNestedKey": {
    "title": "Tiêu đề lồng nhau",
    "description": "Mô tả lồng nhau"
  }
}
```

### Step 2: Run Code Generation

```bash
# Using melos (recommended)
melos genAlls

# OR using build_runner directly
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 3: Verify Generated Files

The `build.yaml` is configured to generate `translations.dart` directly. Verify the files exist:

```bash
ls lib/generated/translations*
# Should show:
# - translations.dart
# - translations_en.g.dart
# - translations_vi.g.dart
```

**If you see a file without `.dart` extension**, remove it:
```bash
rm lib/generated/translations  # Remove file without extension
```

### Step 4: Use in Code

```dart
// Simple key
Text(context.t.myNewKey)

// Nested key
Text(context.t.myNestedKey.title)
Text(context.t.myNestedKey.description)
```

---

## 🔧 Advanced Usage

### Plurals

**In JSON**:
```json
{
  "items": {
    "zero": "No items",
    "one": "One item",
    "other": "{count} items"
  }
}
```

**In Code**:
```dart
Text(context.t.items(count: 0))  // "No items"
Text(context.t.items(count: 1))  // "One item"
Text(context.t.items(count: 5))  // "5 items"
```

### Parameterized Strings

**In JSON**:
```json
{
  "welcome": "Welcome, {name}!",
  "balance": "Your balance is {amount} {currency}"
}
```

**In Code**:
```dart
Text(context.t.welcome(name: 'John'))
Text(context.t.balance(amount: '1000', currency: 'USD'))
```

### Rich Text (with Builders)

**In JSON**:
```json
{
  "termsAndConditions": "I agree to the {terms} and {privacy}",
  "@termsAndConditions": {
    "placeholders": {
      "terms": {},
      "privacy": {}
    }
  }
}
```

**In Code**:
```dart
RichText(
  text: TextSpan(
    children: [
      TextSpan(text: context.t.termsAndConditions(
        terms: (_) => TextSpan(
          text: 'Terms of Service',
          style: TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()..onTap = () {
            // Handle tap
          },
        ),
        privacy: (_) => TextSpan(
          text: 'Privacy Policy',
          style: TextStyle(color: Colors.blue),
        ),
      )),
    ],
  ),
)
```

---

## 🌐 Changing Locale at Runtime

### Set Locale Programmatically

```dart
import 'package:bloc_digital_wallet/generated/translations.dart';

// Set to Vietnamese
await LocaleSettings.setLocale(AppLocale.vi);

// Set to English
await LocaleSettings.setLocale(AppLocale.en);

// Use device locale
await LocaleSettings.useDeviceLocale();
```

### Create Language Selector

```dart
class LanguageSelectorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<AppLocale>(
      value: LocaleSettings.currentLocale,
      items: AppLocale.values.map((locale) {
        return DropdownMenuItem(
          value: locale,
          child: Text(locale.languageCode),
        );
      }).toList(),
      onChanged: (AppLocale? newLocale) async {
        if (newLocale != null) {
          await LocaleSettings.setLocale(newLocale);
        }
      },
    );
  }
}
```

---

## 📋 Naming Conventions

### Keys Should Be

- **Descriptive**: `authWelcomeBack` not `text1`
- **Grouped by Feature**: `auth*`, `profile*`, `wallet*`
- **CamelCase**: `authLoginToContinue` not `auth_login_to_continue`

### Examples

```json
{
  "authWelcomeBack": "Welcome Back",
  "authLoginToContinue": "Login to continue",
  "authEmail": "Email",
  "authPassword": "Password",
  "authForgotPassword": "Forgot Password?",
  
  "profileTitle": "Profile",
  "profileEditButton": "Edit Profile",
  
  "walletBalance": "Balance",
  "walletSendButton": "Send",
  "walletReceiveButton": "Receive"
}
```

---

## 🔍 Best Practices

### ✅ DO

1. **Use `context.t` in widgets** for automatic rebuilding
2. **Group related keys** by feature/module
3. **Use parameters** for dynamic content
4. **Keep translations consistent** between languages
5. **Add new keys to ALL locale files** at the same time

```dart
// ✅ Good
Text(context.t.authWelcomeBack)
Text(context.t.authEmail)
Text(context.t.authPassword)

// ✅ Good - Parameterized
Text(context.t.welcome(name: user.name))
```

### ❌ DON'T

1. **Don't use hardcoded strings** in UI
2. **Don't forget to add keys to all locales**
3. **Don't use `t` directly in StatefulWidgets** (use `context.t` instead)
4. **Don't forget to regenerate** after changes

```dart
// ❌ Bad - Hardcoded
Text('Welcome Back')

// ❌ Bad - Missing locale
// Only added to en.i18n.json, forgot vi.i18n.json

// ❌ Bad - Using `t` in widget
class MyWidget extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Text(t.authEmail); // Won't rebuild on locale change
  }
}
```

---

## 🛠️ Configuration Files

### build.yaml

```yaml
targets:
  $default:
    builders:
      slang_build_runner:
        enabled: true
        options:
          base_locale: en
          fallback_strategy: base_locale
          input_directory: assets/locales
          input_file_pattern: .i18n.json
          output_directory: lib/generated
          output_file_name: translations
          output_format: single_file
          string_interpolation: dart
          translate_var_regex: '{([^}]+)}'
          flat_map: false
          key_case: null
          key_map_case: camel
          param_case: camel
          timestamp: true
          translation_class_visibility: public
```

### pubspec.yaml

```yaml
dependencies:
  slang: ^4.0.0
  slang_flutter: ^4.0.0

dev_dependencies:
  slang_build_runner: ^4.0.0
  build_runner: ^2.10.4
```

---

## 🐛 Troubleshooting

### Issue: `part of 'translations'` Error

**Error Message**:
```
Error: Using 'lib/generated/translations_en.g.dart' as part of 'package:bloc_digital_wallet/generated/translations.dart' 
but its 'part of' declaration says 'package:bloc_digital_wallet/generated/translations'.
```

**Solution**: The `build.yaml` needs `.dart` extension in `output_file_name`:

```yaml
# build.yaml
slang_build_runner:
  options:
    output_file_name: translations.dart  # ✅ Include .dart
    # NOT: output_file_name: translations  # ❌ Missing extension
```

Then regenerate:
```bash
rm lib/generated/translations*
flutter pub run build_runner build --delete-conflicting-outputs
```

**Root Cause**: Without `.dart` in config, generated files have `part of 'translations'` instead of `part of 'translations.dart'`.

### Issue: `translations.dart` Not Found

**Solution**: Check if file exists with correct extension:

```bash
ls lib/generated/translations*
```

If you see both `translations` (no extension) and `translations.dart`, remove the one without extension:

```bash
rm lib/generated/translations
```

### Issue: Translations Not Updating

**Solution**: Run code generation and restart app:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### Issue: `context.t` Not Recognized

**Solution**: Ensure you've wrapped your app with `TranslationProvider`:

```dart
@override
Widget build(BuildContext context) {
  return TranslationProvider(
    child: MaterialApp.router(
      // ...
    ),
  );
}
```

### Issue: Locale Not Changing

**Solution**: Initialize locale in `main()`:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale(); // Add this
  runApp(const MyApp());
}
```

---

## 📊 Current Translation Keys

### Authentication Module

| Key | English | Vietnamese |
|-----|---------|-----------|
| `authWelcomeBack` | Welcome Back | Chào mừng trở lại |
| `authLoginToContinue` | Login to continue | Đăng nhập để tiếp tục |
| `authEmail` | Email | Email |
| `authPassword` | Password | Mật khẩu |
| `authLogin` | Login | Đăng nhập |
| `authSignUp` | Sign up | Đăng ký |
| `authCreateAccount` | Create Account | Tạo tài khoản |
| `authFirstName` | First Name | Tên |
| `authLastName` | Last Name | Họ |
| `authPhoneNumber` | Phone Number | Số điện thoại |
| `authDateOfBirth` | Date of Birth | Ngày sinh |

*See `assets/locales/en.i18n.json` and `vi.i18n.json` for complete list.*

---

## 🎓 Learning Resources

- [slang Documentation](https://pub.dev/packages/slang)
- [slang_flutter Documentation](https://pub.dev/packages/slang_flutter)
- [Flutter Internationalization](https://docs.flutter.dev/accessibility-and-localization/internationalization)

---

## 🚦 Quick Commands Reference

```bash
# Add new translations
1. Edit assets/locales/en.i18n.json
2. Edit assets/locales/vi.i18n.json
3. Run: melos genAlls
4. If needed: mv lib/generated/translations lib/generated/translations.dart
5. Use in code: context.t.yourNewKey

# Change locale at runtime
await LocaleSettings.setLocale(AppLocale.vi);  # Vietnamese
await LocaleSettings.setLocale(AppLocale.en);  # English
await LocaleSettings.useDeviceLocale();        # System locale

# Get current locale
final currentLocale = LocaleSettings.currentLocale;

# Get supported locales
final locales = AppLocaleUtils.supportedLocales;
```

---

## ✅ Checklist for Adding New Feature Translations

- [ ] Identify all user-facing strings in the feature
- [ ] Add keys to `assets/locales/en.i18n.json`
- [ ] Add translations to `assets/locales/vi.i18n.json`
- [ ] Run `melos genAlls`
- [ ] Fix file extension if needed (`mv translations translations.dart`)
- [ ] Replace hardcoded strings with `context.t.keyName`
- [ ] Test in both English and Vietnamese
- [ ] Run `flutter analyze --no-fatal-infos`
- [ ] Verify no errors

---

**Last Updated**: 2026-01-12  
**Status**: ✅ Complete  
**Locales Supported**: English (en), Vietnamese (vi)  
**Total Translation Keys**: 263+ per locale

# Native Security Package

Platform-specific security implementations for the Bloc Digital Wallet, including biometric authentication and secure storage.

## Features

- **Biometric Authentication** - Face ID, Touch ID, Fingerprint support
- **Secure Storage** - Platform-native secure key storage
- **Root/Jailbreak Detection** - Device integrity checks

## Platforms

- **iOS** - Keychain, LocalAuthentication
- **Android** - Keystore, BiometricPrompt

## Usage

```dart
import 'package:native_security/native_security.dart';

// Check biometric availability
final isAvailable = await NativeSecurity.isBiometricAvailable();

// Authenticate
final result = await NativeSecurity.authenticate();
```

## Structure

```
lib/
├── native_security.dart    # Main barrel export
android/                    # Android native implementation
ios/                        # iOS native implementation
```

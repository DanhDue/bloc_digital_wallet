# Environment & Flavors Setup Guide

**Guide for managing environments and flavors in Digital Wallet**

---

## 🎯 Architecture Overview

Digital Wallet combines **Native Flavors** (for signing, bundle identifiers, and app names) with **`--dart-define-from-file`** (for secure runtime configurations).

### Supported Environments
- **`dev` (Development)**: Debug certificates, test APIs, verbose logging.
- **`stg` (Staging / UAT)**: Pre-production APIs, analytics enabled.
- **`prd` (Production)**: Release signing, production APIs, obfuscation.

---

## 📁 Configuration Structure

```
secureFiles/
├── dev/
│   └── environment-configs.json   # Development API keys and endpoints
├── stg/
│   └── environment-configs.json   # Staging API keys and endpoints
├── prd/
│   └── environment-configs.json   # Production API keys and endpoints
└── signing/                       # Keystores & provisioning profiles
```

> [!WARNING]
> The `secureFiles/` directory contains sensitive credentials and is strictly excluded from Git.
> Use `bash scripts/secrets_ops.sh decode` or the `d3nexus:check_secure_files` skill to provision secure files.

### Sample `environment-configs.json`
```json
{
  "APP_NAME": "Digital Wallet Dev",
  "APP_ID_SUFFIX": ".dev",
  "APP_SUFFIX": "dev",
  "ENVIRONMENT": "development",
  "API_BASE_URL": "http://127.0.0.1:8888/",
  "API_VERSION": "v1",
  "ENABLE_LOGGING": "true",
  "ENABLE_ANALYTICS": "false",
  "ENABLE_SSL_PINNING": "false",
  "SHOW_DEBUG_BANNER": "true"
}
```

---

## 🚀 Running & Building by Environment

### 1. Running Locally (VS Code / Terminal)

```bash
# Development
flutter run --flavor dev --dart-define-from-file=secureFiles/dev/environment-configs.json

# Staging
flutter run --flavor stg --dart-define-from-file=secureFiles/stg/environment-configs.json

# Production
flutter run --flavor prd --dart-define-from-file=secureFiles/prd/environment-configs.json
```

### 2. Building Artifacts

```bash
# Android APK
./scripts/buildApk.sh dev
./scripts/buildApk.sh prd

# Android App Bundle (AAB)
./scripts/buildBundle.sh prd

# iOS IPA
./scripts/buildIPA.sh prd
```

---

## 🛠️ Skills & Automation

Use the following agent skills for automated environment configuration:
- `d3nexus:check_secure_files` — Verify all required environment JSON files and certificates exist.
- `d3nexus:copy_secure_configurations` — Synchronize google-services and plist files into native directories.
- `d3nexus:setup_variants` — Re-configure flavors and schemes if modifying package bundle IDs.

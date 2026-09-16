# Networking Architecture

This document describes the networking architecture for the `Digital Wallet` project. It outlines how the core network infrastructure interacts with feature modules while strictly adhering to Clean Architecture principles.

---

## Table of Contents
- [1. Core Philosophy](#1-core-philosophy)
- [2. Networking Architecture Diagram](#2-networking-architecture-diagram)
- [3. Core Components](#3-core-components)
- [4. Decentralized AppUri & Path Parameters](#4-decentralized-appuri--path-parameters)
- [5. Dependency Injection (DI)](#5-dependency-injection-di)
- [6. SSL Pinning Architecture](#6-ssl-pinning-architecture)

---

## 1. Core Philosophy

The networking layer in this project is split into two distinct areas:
1.  **Infrastructure (The `network` package)**: Handles the heavy lifting (HTTP clients, SSL, interceptors, error mapping). It is entirely agnostic to business features.
2.  **Implementation (Feature Modules)**: Each feature module defines its own endpoints, API clients, and response models.

> [!CRITICAL]
> **The Dependency Rule:** The `network` package MUST NEVER depend on or know about feature modules (e.g., `scanner`, `wallet`). Feature modules depend on the `network` package for core utilities.

---

## 2. Networking Architecture Diagram

The following diagram illustrates how the App Layer, Feature Modules, and Network Package interact:

```mermaid
flowchart TD
    subgraph App_Layer ["App Layer (Presentation / Setup)"]
        UI["UI / View"]
        BLoC["BLoC / State Management"]
        AppDI["Global DI Container"]
    end

    subgraph Feature_Module ["Feature Module (e.g. Wallet, Scanner)"]
        Repo["RepositoryImpl"]
        DS["RemoteDataSource"]
        Client["Retrofit Client\n(e.g. WalletClient)"]
        ModuleDI["NetworkModule\n(data/di/)"]
        ModuleURI["{Feature}Uri\n(e.g. WalletUri)"]
    end

    subgraph Network_Package ["Network Package (Infrastructure)"]
        DioFactory["DioFactory"]
        AuthInterceptor["AuthInterceptor"]
        SslConfig["SSL Configuration"]
        BaseModels["BaseResponseObject<T>"]
    end

    UI --> BLoC
    BLoC --> Repo
    Repo --> DS
    DS --> Client
    
    AppDI ..->|"Registers"| ModuleDI
    ModuleDI ..->|"Provides Dio &\nbuilds BaseUrl"| Client
    Client -.->|"Reads paths"| ModuleURI
    
    Client -->|"Makes HTTP Requests"| DioFactory
    DioFactory --> AuthInterceptor
    DioFactory --> SslConfig
    Client -.->|"Parses Response"| BaseModels
```

---

## 3. Core Components

### 2.1 The `network` Package
Located in `packages/network/`, this package provides:
-   **`DioFactory`**: Configures the base `Dio` instance with timeouts, logging, and interceptors.
-   **Interceptors**: 
    -   `AuthInterceptor`: Automatically injects Bearer tokens and handles `401 Unauthorized` token refreshing logic.
    -   `TalkerDioLogger`: Logs network requests/responses for debugging.
-   **Security**: Modular SSL Pinning architecture (`AutoSslConfiguration`, `HardenedSslPinning`, `NoSslPinning`, `DebugSslConfiguration`, `SslFingerprintSource`, `StaticFingerprintSource`).
-   **Base Models**: `BaseResponseObject<T>` used to parse standard API wrapper responses.

### 2.2 Feature Module Clients
Located in `packages/{feature}/lib/data/datasources/remote/`:
-   We use **Retrofit** (`@RestApi`) to generate type-safe HTTP clients.
-   Clients are defined as `abstract class {Feature}Client` and generated via `build_runner`.

---

## 4. Decentralized AppUri & Path Parameters

To prevent the `network` package from becoming a bottleneck "God Class", URI constants are strictly decentralized.

### The Rule
Each module **must own** its API endpoints. There is no global `AppUri` for feature endpoints.

### ✅ Correct Pattern (Per-Module URI)
1.  Create `data/datasources/remote/{feature}_uri.dart`.
2.  Define module-specific paths and parameters inside.

```dart
// packages/wallet/lib/data/datasources/remote/wallet_uri.dart
class WalletUri {
  static const String wallets = 'wallets';
  static const String tokens = 'tokens';
  static const String accounts = 'accounts';
  
  // Feature-specific path parameters
  static const String pathAddress = '/{address}'; 
}
```

Usage in the Retrofit Client:
```dart
import 'package:wallet/data/datasources/remote/wallet_uri.dart';

@RestApi()
abstract class TokenClient {
  factory TokenClient(Dio dio, {String? baseUrl}) = _TokenClient;

  @GET('/${WalletUri.accounts}${WalletUri.pathAddress}')
  Future<BaseResponseObject<List<TokenListModel>>> getTokenAccounts(
    @Path("address") String address,
  );
}
```

### ❌ Incorrect Pattern
-   **DO NOT** add feature strings (e.g., `static const String wallets = 'wallets';`) to `packages/network/lib/app_uri.dart`.
-   **DO NOT** create a global `UriPathParameters` class in the network package.

---

## 5. Dependency Injection (DI)

Retrofit clients require a `Dio` instance and an explicit `baseUrl`. 

> [!WARNING]
> **Layer Violation Risk:** Network DI modules MUST be placed in the `data/di/` directory of the feature package, NOT in `lib/di/`. The `lib/di/` folder is reserved strictly for assembling the module's dependencies via `configureModuleDependencies()`.

### Example Implementation

```dart
// packages/wallet/lib/data/di/network_module.dart
import 'package:network/extensions/string_ext.dart';
import 'package:wallet/data/datasources/remote/wallet_uri.dart';

@module
abstract class WalletNetworkModule {
  @lazySingleton
  TokenClient tokenClient(Dio dio) =>
      TokenClient(dio, baseUrl: WalletUri.tokens.buildAppUri());
}
```

### Key DI Rules:
1.  **Class Naming**: Must be `{Feature}NetworkModule` (e.g., `WalletNetworkModule`).
2.  **Explicit BaseUrl**: Always use `{Feature}Uri.service.buildAppUri()` to pass the `baseUrl`. Never instantiate a client with just `Dio` because the default Dio `baseUrl` might not match your specific microservice path.
3.  **Extension**: `.buildAppUri()` is provided by importing `package:network/extensions/string_ext.dart`.

---

## 6. SSL Pinning Architecture

The networking layer implements a decoupled, fail-closed SSL Pinning architecture that completely isolates native dependencies from the core infrastructure package (`network`).

### 6.1 Design Principles

1.  **Pure Dart Core (`packages/network`)**:
    -   The `network` package does **NOT** depend on `native_security` or any FFI / platform channels.
    -   Defines an abstract contract `SslFingerprintSource` and pure-Dart implementations (`StaticFingerprintSource`).
    -   Ensures `network` remains 100% unit-testable without native mocking and platform-agnostic (iOS, Android, macOS, Linux, Windows, Web).

2.  **App Composition Layer (`lib/di/`)**:
    -   The native FFI binding (`NativeSecurityFingerprintSource`) lives in the application layer (`lib/di/native_security_fingerprint_source.dart`), bridging `NativeSecurity.getAllowedFingerprints()` into the `SslFingerprintSource` contract.
    -   `AppNetworkModule` injects `AutoSslConfiguration(source: const NativeSecurityFingerprintSource())` into the global DI container.

3.  **Fail-Closed Security**:
    -   If a host has no fingerprints configured, or if the native FFI call fails, `fingerprintsFor(host)` returns an empty list (`[]`).
    -   An empty fingerprint list immediately rejects the handshake (`accepts() == false`).

---

### 6.2 SSL Strategies & Lifecycle

```mermaid
flowchart TD
    BuildMode{"Build Mode?"}
    BuildMode -->|kDebugMode| Debug["DebugSslConfiguration\n(Accepts all certs for dev/proxy)"]
    BuildMode -->|Non-Debug| CheckPinning{"ENABLE_SSL_PINNING &&\nsource != null?"}
    
    CheckPinning -->|Yes| Hardened["HardenedSslPinning\n(Validates leaf cert fingerprint)"]
    CheckPinning -->|No| NoPin["NoSslPinning\n(System Trust Store)"]
```

| Strategy | When Used | Behavior |
| :--- | :--- | :--- |
| **`DebugSslConfiguration`** | `kDebugMode == true` | Disables certificate checking, facilitating Charles/Fiddler proxying and local development. |
| **`HardenedSslPinning`** | Non-debug with `ENABLE_SSL_PINNING=true` and an active `SslFingerprintSource` | Configures `SecurityContext(withTrustedRoots: false)` to bypass OS CA trust and triggers `badCertificateCallback` for every certificate. Matches `base64(sha256(cert.der))` against pinned fingerprints. |
| **`NoSslPinning`** | Non-debug when pinning is disabled or no fingerprint source provided | Relies on standard platform/OS root CA validation (browser-grade TLS). |
| **`AutoSslConfiguration`** | Default injector | Selects dynamically between `DebugSslConfiguration`, `HardenedSslPinning`, and `NoSslPinning`. |

---

### 6.3 Certificate Fingerprint Format

Certificates are evaluated by hashing the leaf certificate's DER bytes using SHA-256 and encoding the result in standard Base64:

$$\text{Fingerprint} = \text{Base64}(\text{SHA-256}(\text{cert.der}))$$

```dart
static String fingerprintOf(X509Certificate cert) =>
    base64.encode(sha256.convert(cert.der).bytes);
```

---

### 6.4 Swapping Fingerprint Sources

#### 1. Native FFI Source (Production Default)
```dart
// lib/di/native_security_fingerprint_source.dart
class NativeSecurityFingerprintSource implements SslFingerprintSource {
  const NativeSecurityFingerprintSource();

  @override
  List<String> fingerprintsFor(String host) {
    try {
      return NativeSecurity.getAllowedFingerprints();
    } catch (_) {
      return const <String>[]; // Fail-closed on FFI error
    }
  }
}
```

#### 2. Pure Dart / Static / Per-Host Source (Tests / Multi-Backend)
```dart
const source = StaticFingerprintSource(
  anyHost: ['sha256/base64_global_fingerprint=='],
  byHost: {
    'api.payment-gateway.com': ['sha256/base64_gateway_fingerprint=='],
    'api.auth-service.com': ['sha256/base64_auth_fingerprint=='],
  },
);

final sslConfig = HardenedSslPinning(source: source);
```


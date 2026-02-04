# Network Package

Networking infrastructure for the Bloc Digital Wallet including Dio configuration, SSL handling, and Retrofit base setup.

## Features

- **Dio Configuration** - Pre-configured Dio instance with interceptors
- **SSL/TLS** - Certificate pinning and secure connections
- **Retrofit Base** - Base client configuration for API calls
- **Error Handling** - Network error types and handlers

## Usage

```dart
import 'package:network/network.dart';

// Access configured Dio instance
final dio = getIt<Dio>();

// Use with Retrofit clients
final client = MyApiClient(dio, baseUrl: 'https://api.example.com');
```

## Structure

```
lib/
├── network.dart        # Main barrel export
└── src/
    ├── di/             # Network DI modules
    ├── interceptors/   # Dio interceptors
    └── clients/        # Base API clients
```

---
name: handle_api_request
description: Automate the end-to-end process of handling a new API request, from model generation to Data Source integration.
---

# Handle API Request Skill

This skill guides the process of implementing a new API request in the wallet module, ensuring all layers are correctly updated.

> [!IMPORTANT]
> **Import Convention**: Always use **full package paths** (e.g., `import 'package:bloc_digital_wallet/core/network/app_uri.dart';`) instead of relative imports (e.g., `import '../../core/network/app_uri.dart';`).

## 1. Analyze Request & Response

1.  **Identify Endpoint**: Method (GET/POST/etc.) and Path (e.g., `api/v1/tokens/accounts/{address}`).
2.  **Analyze JSON**: Map the response data to Freezed models.

## 2. Generate Models

Follow the `json_to_freezed_model` skill guidelines to create:
- Root object (e.g., `TokenAccountObject`)
- Nested objects (e.g., `MintTokenObject`)

Place models in: `lib/features/{module}/data/models/`

## 3. Network Configuration

### Update `AppUri`
Add the endpoint constant to `lib/core/network/app_uri.dart`.

```dart
static const String endpointName = 'endpoint_path';
```

### Create/Update Client

Define the request in the module's Retrofit client.

**Naming Convention**:
- If the prompt specifies a client name (e.g., "token client"), use that: `token_client.dart`.
- If no client name is specified, use the module name: `{module}_client.dart` (e.g., `wallet_client.dart`).

The client should be located in `lib/features/{module}/data/datasources/remote/`.

```dart
@GET('/${AppUri.endpointName}/{param}')
Future<BaseResponseObject<T>> getSomething({
  @Path('param') required String param,
});
```

### Update `NetworkModule`
Register the client in `lib/di/network_module.dart` if it's new.

```dart
@singleton
YourClient provideYourClient(Dio dio) => YourClient(dio, baseUrl: AppUri.service.buildAppUri()!);
```

## 4. Update Remote Data Source

1.  **Interface**: Add the method to the `RemoteDataSource` interface.
2.  **Implementation**: Inject the client and implement the method.

```dart
@override
Future<BaseResponseObject<T>> getSomething(String param) {
  return apiClient.getSomething(param: param);
}
```

## 5. Finalize

1.  **Generate Code**: Run `melos genAlls`.
2.  **Verify**: Run `fvm flutter analyze --no-fatal-infos`.

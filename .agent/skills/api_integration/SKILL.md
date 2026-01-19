---
name: api_integration
description: Automate the end-to-end process of handling a new API request, from model generation to Data Source integration.
conversation_mode: Fast
---

## SKILL MAPPING RULES

**IF** user provides:
- A CURL command or raw HTTP request details.
- A JSON response with a request to "handle", "integrate", or "implement" the API.
- A functional description (e.g., "Add Token Accounts API") along with endpoint details.
- A request to create a "client" or "datasource" for a specific API endpoint.

**THEN** follow this skill (`api_integration`):
1.  **Skip PLANNING** and `implementation_plan.md` creation.
2.  **Proceed directly to EXECUTION** following the steps below.

# API Integration Skill

This skill automates the process of implementing a new API request, ensuring all layers (models, clients, data sources, and DI) are correctly updated according to project standards.

> [!IMPORTANT]
> **Execute Immediately**: When this skill is requested, skip the `PLANNING` phase and `implementation_plan.md` creation. Proceed directly to `EXECUTION`. This skill requires zero verifications or confirmations before starting work.

> [!IMPORTANT]
> **Import Convention**: Always use **full package paths** (e.g., `import 'package:bloc_digital_wallet/core/network/app_uri.dart';`) instead of relative imports (e.g., `import '../../core/network/app_uri.dart';`).

## 1. Analysis Phase

1.  **Extract endpoint details**: Method, path, and parameters from the provided description or CURL.
2.  **Analyze JSON response**: Identify all objects and fields for model generation.

## 2. Model Generation

Use the `json_to_freezed_model` skill guidelines:
1.  **Create Freezed models** for all objects in `lib/features/{module}/data/models/`.
2.  **Apply strict naming**: All models must use `abstract class` and include `@JsonKey` for every field.
3.  **Snake Case mapping**: Ensure JSON snake_case fields are correctly mapped to camelCase Dart properties.

## 3. Network Layer Implementation

1.  **AppUri**: Add endpoint path constants to `lib/core/network/app_uri.dart`.
2.  **Retrofit Client**:
    - If the prompt specifies a client name (e.g., "token client"), use that: `token_client.dart`.
    - If no client name is specified, use the module name: `{module}_client.dart` (e.g., `wallet_client.dart`).
    - Create or update the module's client in `lib/features/{module}/data/datasources/`.
    - Use the `@RestApi()` and `@GET/@POST/etc.` annotations.
    - Wrap responses with `BaseResponseObject<T>`.
3.  **Dependency Injection**:
    - Register new clients in `lib/di/network_module.dart` using the `@singleton` or `@LazySingleton` annotation.
    - Use `AppUri` constants to build base URLs.

## 4. Data Layer Integration

1.  **Remote Data Source Interface**: Add the new method returning `Future<Either<Failure, BaseResponseObject<T>>>`.
2.  **Remote Data Source Implementation**:
    - Ensure the class uses `with SafeCallApiMixin`.
    - Implement the method using `safeApiCall(() => client.method())`.
    - **Formatting rule**: Prefer single-line arrow syntax with wrapped return type, for example:

      ```dart
      Future<Either<Failure, BaseResponseObject<List<TokenAccountObject>>>>
          getTokenAccounts({required String address}) =>
              safeApiCall(() => _client.getTokenAccounts(address));
      ```

## 5. Verification & Finalization

1.  **Run Code Gen**: Execute `melos genAlls`.
2.  **Clean Analysis**: Run `fvm flutter analyze --no-fatal-infos` and ensure zero issues.
3.  **Finalization**: Create an `ai_integration_{retrofit_client_name}.md` artifact in the `.docs/` folder showing the changes and verification proof.

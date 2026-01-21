# AI Integration: Token Client

## 1. Overview
Implemented `TokenClient` to fetch token accounts from the `/api/v1/tokens/accounts/{address}` endpoint.

## 2. Changes

### Models
- Created `MintTokenObject` (`lib/features/wallet/data/models/mint_token_object.dart`)
- Created `TokenAccountObject` (`lib/features/wallet/data/models/token_account_object.dart`)
- Used `freezed` with `abstract class` and `@JsonKey`.

### Client
- Created `TokenClient` (`lib/features/wallet/data/datasources/remote/token_client.dart`)
- Endpoint: `@GET('/${AppUri.accounts}/{address}')`

### Dependency Injection
- Updated `NetworkModule` (`lib/di/network_module.dart`)
- Registered `TokenClient` with explicit `baseUrl`.

### Remote Data Source
- Updated `WalletRemoteDataSource` (`lib/features/wallet/data/datasources/wallet_remote_datasource.dart`)
- Used `TokenClient` to implement `getTokenAccounts`.

## 3. Verification

### Code Generation
- Ran `melos genAlls` (via build_runner).
- Generated `.freezed.dart` and `.g.dart` files.

### Tests
- Passed `test/features/wallet/data/models/token_account_object_test.dart`.

### Analysis
- Ran `fvm flutter analyze --no-fatal-infos`.

# API Integration: Network Client

## 1. Overview
Integrated `NetworkClient` to retrieve network list from `https://digital-wallet-93c4ba68a41d.herokuapp.com/api/v1/network`.

## 2. Changes
- **AppUri**: Added `network` constant.
- **Models**: Created `NetworkObject` (Freezed).
- **Client**: Created `NetworkClient` (Retrofit) with explicitly empty endpoint.
- **DataSource**: Updated `WalletRemoteDataSource` to include `getNetworks`.
- **DI**: Registered `NetworkClient` in `NetworkModule` with explicit `baseUrl`.

## 3. Verification
> [!WARNING]
> Automated verification (code generation and analysis) failed due to FVM permission errors on the host environment:
> `/Users/danhdue/fvm/versions/3.38.7/bin/internal/update_engine_version.sh: line 64: ... Operation not permitted`

### Implemented Files
- [network_object.dart](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/lib/features/wallet/data/models/network_object.dart)
- [network_client.dart](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/lib/features/wallet/data/datasources/remote/network_client.dart)
- [wallet_remote_datasource.dart](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/lib/features/wallet/data/datasources/wallet_remote_datasource.dart)
- [network_module.dart](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/lib/di/network_module.dart)

# API Integration Report: Health Check Client

Integration of the Health Check and BaseUrl APIs for the `onboard` module.

## Summary of Changes

### Models Created
- `BaseUrlObject`: Data model for app base URL configuration.

### Network Layer
- `HealthCheckClient`: Retrofit client for handling `GET` requests to `/healthz/` and `/baseUrl/`.
- `NetworkModule`: Registered `HealthCheckClient` as a singleton.
- `AppUri`: Added `baseUrl` constant and utilized `healthz`.

### Data Layer
- `OnboardRemoteDataSource`: Added `healthCheck` and `getBaseUrl` methods using `SafeCallApiMixin`.

## Files Modified/Created

- [NEW] [base_url_object.dart](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/lib/features/onboard/data/models/base_url_object.dart)
- [NEW] [health_check_client.dart](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/lib/features/onboard/data/datasources/health_check_client.dart)
- [MODIFY] [app_uri.dart](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/lib/core/network/app_uri.dart)
- [MODIFY] [network_module.dart](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/lib/di/network_module.dart)
- [MODIFY] [onboard_remote_datasource.dart](file:///Users/danhdue/AllProjects/sample/bloc_digital_wallet/lib/features/onboard/data/datasources/onboard_remote_datasource.dart)

## Verification Results

### Code Generation
- Successfully ran `melos genAlls`.
- `health_check_client.g.dart` and `base_url_object.g.dart` generated correctly.

### Static Analysis
- Ran `fvm flutter analyze --no-fatal-infos`.
- Result: **0 errors, 0 warnings** in the modified files.

## API Details
### Health Check
- **Endpoint**: `GET /healthz/`
- **Response**: `BaseResponseObject<dynamic>`

### Base URL
- **Endpoint**: `GET /baseUrl/`
- **Response**: `BaseResponseObject<List<BaseUrlObject>>`
- **Sample Data**: `{"app_id": "...", "base_url": "...", "updated_at": ...}`

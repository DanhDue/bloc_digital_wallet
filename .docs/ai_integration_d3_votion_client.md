# AI Integration: D3Votion Client

**Client Name**: `d3_votion_client.dart`
**Feature**: `d3_votion`
**Date**: 2026-05-21

## 1. API Analysis

- **Endpoint**: `GET /api/v1/d3votion`
- **Query Parameters**: `word`
- **Response Structure**:
  ```json
  {
    "word": "single",
    "definition": "...",
    "ipa": "/.../",
    "samples": [
      {
        "text": "...",
        "vietnamese_text": "...",
        "audio_link": "..."
      }
    ]
  }
  ```
- **Deviation**: The API does NOT wrap the response in `BaseResponseObject`. A direct model `D3VotionResObject` was used.

## 2. Implementation Details

- **AppUri**: Added `static const String d3Votion = 'd3votion';`
- **Models**:
    - `D3VotionResObject` (root)
    - `D3VotionSampleObject` (nested)
- **Client**:
    ```dart
    @RestApi()
    abstract class D3VotionClient {
      @GET('')
      Future<D3VotionResObject> getD3Votion(@Query("word") String word);
    }
    ```
- **DI**: Registered `D3VotionClient` in `NetworkModule` with `baseUrl: AppUri.d3Votion.buildAppUri()!`.

## 3. Verification

- **Code Generation**: `build_runner` executed successfully.
- **Files Generated**:
    - `d3_votion_res_object.freezed.dart`
    - `d3_votion_res_object.g.dart`
    - `d3_votion_client.g.dart`
- **Routing**: `D3VotionRoute` registered in `AppRouter`.

import os

file_path = ".devtool/features/todo/http_caching_etag.md"
content = """---
id: http_caching_etag
status: todo
epic: "translation-management"
---
# Phase 3: Test & Implement HTTP Caching (ETag / 304 Not Modified)
- Thêm tham số `@Header('If-None-Match') String? eTag` vào API `TranslationClient.getLocalizationOverrides`.
- Trong `FetchTranslationUseCase`, lấy checksum hiện tại của local cache để truyền vào tham số `eTag`.
- Xử lý việc trả về HTTP 304 Not Modified trong `SettingsRemoteDataSource` hoặc thông qua Interceptor để không bị bắt nhầm thành `ServerFailure`.
- Viết các Unit Test tương ứng để xác minh.
"""

with open(file_path, "w") as f:
    f.write(content)

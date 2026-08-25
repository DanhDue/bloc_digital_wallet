---
id: "http_caching_etag"
status: "done"
priority: "high"
assignee: null
epic: "translation-management"
dueDate: null
created: "2026-08-21T09:44:38.615Z"
modified: "2026-08-21T10:53:33.327Z"
completedAt: "2026-08-21T10:53:33.327Z"
labels: []
order: "a0"
---
# Phase 3: Test & Implement HTTP Caching (ETag / 304 Not Modified)

Dựa trên việc phân tích file `translation_sync_use_cases.md` và đối chiếu với mã nguồn hiện tại ở phía mobile app (cụ thể là `FetchTranslationUseCase`, `SettingsRemoteDataSource`, và `TranslationClient`), đây là kết quả kiểm tra:

### ✅ Các trường hợp Mobile App ĐÃ XỬ LÝ ĐÚNG:

1. **EC1, EC2, EC3 (Server trả về** `mode="full"` **thay vì delta):**
   - Mã nguồn trong `FetchTranslationUseCase` đã xử lý chuẩn. Nếu `item.mode == 'full'` (hoặc khi thiết bị mất local cache), app sẽ bỏ qua bước gọi `DeepMergeUtils` và tiến hành lưu đè (overwrite) toàn bộ JSON mới.
2. **EC6 (Nhận Empty Delta khi không có thay đổi):**
   - Đã xử lý đúng. Nếu bản delta trả về rỗng `{}`, hàm `DeepMergeUtils.deepMerge(cachedJson, {})` vẫn hoạt động bình thường, không làm hỏng dữ liệu cũ.
3. **EC4 (Lỗi trả về từ Server khi ngôn ngữ bị vô hiệu hoá):**
   - Xử lý tốt thông qua `SafeCallApiMixin`. Nếu server trả về lỗi `success=False` hoặc mã HTTP lỗi, hàm sẽ bắt thành `ServerFailure` và tiến trình `FetchTranslationUseCase` sẽ dừng lại an toàn mà không xoá cache hiện có.

---

### ❌ Trường hợp Mobile App CHƯA XỬ LÝ (Thiếu hụt logic):

App hiện tại **bỏ quên hoàn toàn** Use Case 3 (**UC3: Cơ chế HTTP Caching - ETag / 304 Not Modified**). Cụ thể, hệ thống chưa được tích hợp luồng gửi checksum lên Server để tận dụng ETag.

**Các bước triển khai (Todo):**

- \[x\] Thêm tham số `@Header('If-None-Match') String? eTag` vào API `TranslationClient.getLocalizationOverrides`.
- \[x\] Trong `FetchTranslationUseCase`, lấy checksum hiện tại của local cache để truyền vào tham số `eTag`.
- \[x\] Xử lý việc trả về HTTP 304 Not Modified trong `SettingsRemoteDataSource` hoặc thông qua Interceptor để không bị bắt nhầm thành `ServerFailure`.
- \[x\] Viết các Unit Test tương ứng để xác minh các logic trên.
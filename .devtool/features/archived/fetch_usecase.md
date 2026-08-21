---
id: "fetch_usecase"
status: "todo"
priority: "medium"
assignee: null
epic: "translation-management"
dueDate: null
created: "2026-08-21T09:02:50.664Z"
modified: "2026-08-21T09:16:46.101Z"
completedAt: "2026-08-21T09:16:46.101Z"
labels: []
order: "a4"
---
# Phase 3: Test & Implement FetchTranslationUseCase
Đảm bảo xoá cache cũ, lưu đè JSON mới và cập nhật version.
Đảm bảo luồng đọc cache, gộp, xoá key, xác thực checksum hợp lệ.
Edge cases: Checksum không khớp gọi lại API tải bản Full. Không tìm thấy file cache local gọi tải bản Full.
Triển khai FetchTranslationUseCase.
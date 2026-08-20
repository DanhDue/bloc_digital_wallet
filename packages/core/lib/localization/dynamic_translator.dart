// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// Lớp tiện ích giúp tra cứu trực tiếp các key động từ API (ví dụ trạng thái Enum từ server)
/// mà chưa từng được khai báo trong Slang lúc compile.
class DynamicTranslator {
  static Map<String, dynamic> _rawTranslations = {};

  /// Cập nhật từ điển động. Hàm này đã được gọi tự động bên trong
  /// [LocalizationManager.applyDynamicTranslations], bạn không cần gọi thủ công.
  static void updateJson(Map<String, dynamic> json) {
    _rawTranslations = json;
  }

  /// Tra cứu một key hoàn toàn tự do từ server.
  /// Hỗ trợ cả nested key (ví dụ: "status.warning.scam")
  static String translate(String key) {
    if (key.isEmpty) return key;

    final parts = key.split('.');
    dynamic current = _rawTranslations;

    for (final part in parts) {
      if (current is Map && current.containsKey(part)) {
        current = current[part];
      } else {
        return key; // Fallback: Nếu không tìm thấy, trả về chính key đó
      }
    }

    return current?.toString() ?? key;
  }
}

# Mobile System Design: Các vấn đề và giải pháp khi xử lý Refresh Token

Tổng hợp các vấn đề về concurrency, bảo mật và triển khai cụ thể với Django Ninja Backend cho cơ chế Refresh Token.

## 1. Các vấn đề (Issues) và Giải pháp (Solutions)

### Vấn đề 1: Race Condition (Concurrency)
* **Mô tả:** Khi Access Token hết hạn, nhiều API request diễn ra đồng thời cùng gặp lỗi 401. Client gọi API `refresh-token` nhiều lần cùng lúc. Request thứ 2 sẽ thất bại do token cũ đã bị request 1 xoay vòng, gây logout oan.
* **Giải pháp:** **Locking & Queueing (trong Interceptor)**.
    * Dùng cờ `isRefreshing`.
    * Nếu đang refresh, đưa các request đến sau vào hàng đợi (Queue).
    * Sau khi refresh thành công, retry lại toàn bộ request trong hàng đợi với token mới.

### Vấn đề 2: Infinite Loop (Vòng lặp chết)
* **Mô tả:** API Refresh cũng bị lỗi (401/403) nhưng Interceptor lại tưởng là lỗi thường và tiếp tục gọi refresh lại, gây treo app.
* **Giải pháp:** **Whitelist & Error Checking**.
    * Kiểm tra nếu request gây lỗi chính là API `refresh-token` thì không retry.
    * Thực hiện **Force Logout** nếu làm mới thất bại.

### Vấn đề 3: Token Rotation & Security
* **Mô tả:** Refresh Token bị lộ và có thời hạn quá dài, hacker có thể dùng mãi mãi.
* **Giải pháp:** **Refresh Token Rotation (Xoay vòng)**.
    * Server cấp cả Access Token mới VÀ Refresh Token mới mỗi lần refresh.
    * Refresh Token cũ bị hủy/đưa vào blacklist ngay lập tức.
    * Nếu Refresh Token cũ bị dùng lại -> Server thu hồi toàn bộ chuỗi token.

### Vấn đề 4: Lưu trữ (Storage)
* **Mô tả:** Lưu plain text trong SharedPreferences/UserDefaults không an toàn.
* **Giải pháp:** **Secure Storage**.
    * Android: EncryptedSharedPreferences.
    * iOS: Keychain Services.
    * Flutter: `flutter_secure_storage`.

---

## 2. Tóm tắt chiến lược triển khai

| Vấn đề | Giải pháp cốt lõi |
| :--- | :--- |
| **Nhiều request lỗi cùng lúc** | Dùng **Mutex/Lock** và **Queue** trong Interceptor. |
| **Refresh Token cũng bị lỗi** | Chặn refresh nếu url là endpoint refresh. Force Logout. |
| **Token bị đánh cắp** | **Refresh Token Rotation** (Dùng 1 lần rồi bỏ). |
| **Lộ token trên thiết bị** | Lưu trong **Keychain/Keystore**. |

---

## 3. Phân chia trách nhiệm (Mobile vs Backend)

### Backend (Server)
* **Chủ đạo:** Thiết lập luật chơi và bảo mật.
* Cấp phát Refresh Token mới khi nhận request.
* Đưa token cũ vào Blacklist.
* Phát hiện hành vi bất thường (dùng lại token cũ) để thu hồi tài khoản.

### Mobile App (Client)
* **Phối hợp:** Đảm bảo luồng hoạt động trơn tru.
* **Xử lý Concurrency:** Đảm bảo chỉ gửi 1 request refresh tại một thời điểm.
* **Cập nhật Storage:** Quan trọng nhất trong Token Rotation là phải lưu đè **Refresh Token mới** vào bộ nhớ ngay khi nhận được phản hồi. Nếu client vẫn giữ token cũ, lần refresh sau sẽ bị server chặn.

---

## 4. Triển khai với Django Ninja & Ninja JWT

Thư viện `ninja-jwt` hỗ trợ sẵn Token Rotation nhưng cần kích hoạt thủ công.

### Cấu hình `settings.py`:

1.  **Thêm App Blacklist:**
    ```python
    INSTALLED_APPS = [
        # ...
        'ninja_jwt',
        'ninja_jwt.token_blacklist', # Bắt buộc
    ]
    ```
    *(Chạy `python manage.py migrate` sau bước này)*

2.  **Bật tính năng Rotation:**
    ```python
    from datetime import timedelta

    NINJA_JWT = {
        'ACCESS_TOKEN_LIFETIME': timedelta(minutes=5),
        'REFRESH_TOKEN_LIFETIME': timedelta(days=7),
        
        # Kích hoạt xoay vòng
        'ROTATE_REFRESH_TOKENS': True,
        'BLACKLIST_AFTER_ROTATION': True, 
        
        'UPDATE_LAST_LOGIN': False,
        'ALGORITHM': 'HS256',
    }
    ```

### Lưu ý cho Mobile App:
Khi Backend bật `ROTATE_REFRESH_TOKENS = True`, API response sẽ trả về cấu trúc mới. Mobile App cần parse và lưu lại cả `refresh` token mới, thay vì chỉ lưu `access` token như mặc định.

---

## 5. Lưu ý quan trọng cho Auth Interceptor

**Tuyệt đối không gửi Token khi gọi API Login/Register.**

Trong logic của `onRequest` (Interceptor), cần kiểm tra URL request. Nếu là API Login hoặc Register (Public Endpoints), **KHÔNG** được đính kèm header `Authorization`.

* **Lý do:**
    1.  **Tránh xung đột:** Nếu token cũ còn lưu trong máy nhưng đã hết hạn, gửi kèm nó lên API Login sẽ khiến Server trả về 401. Điều này kích hoạt logic Refresh Token một cách vô lý (refresh trong khi user đang cố login).
    2.  **Đảm bảo Session mới:** Login là hành động khởi tạo phiên làm việc mới, Server cần trả về cặp Access + Refresh token mới hoàn toàn mà không bị ảnh hưởng bởi token cũ.
* **Cách làm:** Tạo danh sách **Whitelist** (ví dụ: `/login`, `/register`). Nếu URL nằm trong danh sách này, bỏ qua bước gắn token.

---

## 6. Chiến lược Xử lý Logout (Logout Strategy)

Để đảm bảo kết nối an toàn và ngăn chặn vòng lặp lỗi, hệ thống sẽ tự động kích hoạt **Logout** (đăng xuất) trong 3 trường hợp cụ thể sau đây (được triển khai trong `AuthInterceptor`):

### 1. Thất bại khi Retry (Persistent Failure)
*   **Điều kiện:** Request API trả về lỗi 401, mặc dù request này đã được đánh dấu là `is_retry` (đã thử refresh token 1 lần trước đó).
*   **Cơ chế:**
    1.  Interceptor kiểm tra cờ `is_retry` trong `requestOptions.extra`.
    2.  Nếu tồn tại, hệ thống hiểu rằng dù đã có token mới, server vẫn từ chối.
    3.  **Hành động:** Gọi `logout()` ngay lập tức để ngắt phiên làm việc lỗi.

### 2. Refresh Token Hết hạn hoặc Không hợp lệ (Dead Session)
*   **Điều kiện:** Khi gọi API `refresh-token` để lấy Access Token mới, chính API này cũng trả về lỗi (401 Unauthorized hoặc 403 Forbidden).
*   **Cơ chế:**
    1.  Khối `try-catch` bao quanh call API refresh bắt được lỗi.
    2.  Điều này đồng nghĩa Refresh Token hiện tại đã hết hạn (expired) hoặc bị thu hồi (revoked).
    3.  **Hành động:** Xóa toàn bộ token trong Local Storage và gọi `logout()`.

### 3. Không tìm thấy Refresh Token (Missing Token)
*   **Điều kiện:** Request gặp lỗi 401 nhưng khi kiểm tra Local Storage thì không có Refresh Token (null).
*   **Cơ chế:**
    1.  Hệ thống không thể thực hiện quy trình làm mới do thiếu token nguồn.
    2.  **Hành động:** Xóa sạch dữ liệu rác (nếu có) và gọi `logout()`.

> **Lưu ý:** Việc xử lý logout cần được thực hiện qua một `AuthStreamService` hoặc cơ chế tương tự để thông báo cho toàn bộ ứng dụng (UI layers) chuyển hướng về màn hình Login ngay lập tức.
# Security Rules

## 🔐 Data Handling
- **Sensitive Data**: NEVER hardcode API keys, tokens, or PII.
- **Storage**: Use `flutter_secure_storage` for tokens (access/refresh).
- **Logging**: NEVER log raw HTTP bodies containing passwords or tokens.

## 🌐 Network Security
- **SSL**: All API calls must use `https://`.
- **Timeouts**: All clients must have connection/receive timeouts configured.
- **Error Handling**: Do not expose stack traces to the UI.

## 🛡️ Input Validation
- **Forms**: Validate all user input on client side (length, format) AND server side (if mock server).
- **Injection**: Use parameterized queries if interacting with local DB (Drift/Sqflite).

---
id: "task_03_native_security_ssl_pinning_verification"
status: "done"
priority: "high"
assignee: null
epic: "system_theme_sync"
dueDate: null
created: "2026-09-17T22:25:00+07:00"
modified: "2026-09-17T15:35:56Z"
completedAt: "2026-09-17T15:35:56Z"
labels: ["native_security", "network", "ssl-pinning", "security", "tdd"]
order: "a3"
---

# Task 03: Native Security SSL Pinning Obfuscation & Verification

## Context & Objectives
Ensure the mobile security layer in `packages/native_security` and `packages/network` reliably validates backend TLS certificates during non-debug runs (`--profile` / `--release` with `ENABLE_SSL_PINNING=true`):
1. Verify `packages/native_security/ios/native_security/Sources/native_security_ffi/native_security.cpp` stores the active obfuscated SHA-256 fingerprint for `*.herokuapp.com` (`k9HqKHp7CLk410cHWxSuIB6q1sbvRQ3rjgSZ2NwzkvA=`).
2. Retain backup pin slots (`pin2`, `pin3`) for future certificate rotation resilience per OWASP MASVS guidelines.
3. Provide automated native C++ test verification and Dart unit tests in `packages/native_security/test/` and `packages/network/test/ssl/` ensuring that FFI lookup succeeds and `HardenedSslPinning.accepts()` functions as expected.

---

## BDD Acceptance Criteria

```gherkin
Feature: Native Security SSL Pinning Verification

  Scenario: get_ssl_pin_1 unscrambles the active server certificate fingerprint
    Given the compiled native_security binary
    When get_ssl_pin_1() is executed
    Then it returns "k9HqKHp7CLk410cHWxSuIB6q1sbvRQ3rjgSZ2NwzkvA="

  Scenario: NativeSecurity.getAllowedFingerprints() returns non-empty list of fingerprints
    Given a platform supporting FFI execution
    When NativeSecurity.getAllowedFingerprints() is called
    Then it returns a list of 3 string fingerprints
    And the first element equals "k9HqKHp7CLk410cHWxSuIB6q1sbvRQ3rjgSZ2NwzkvA="

  Scenario: HardenedSslPinning accepts certificate matching active fingerprint
    Given a leaf X509Certificate whose base64 SHA-256 fingerprint is "k9HqKHp7CLk410cHWxSuIB6q1sbvRQ3rjgSZ2NwzkvA="
    When HardenedSslPinning.accepts(cert, "digital-wallet-93c4ba68a41d.herokuapp.com") is evaluated
    Then it returns true

  Scenario: HardenedSslPinning rejects unknown certificate (fail-closed)
    Given an untrusted leaf certificate with an unknown fingerprint
    When HardenedSslPinning.accepts(cert, "digital-wallet-93c4ba68a41d.herokuapp.com") is evaluated
    Then it returns false
    And logs warning "SSL Pinning failed for digital-wallet-93c4ba68a41d.herokuapp.com — fingerprint mismatch"
```

---

## TDD Implementation Steps

### 1. QA Red Team (Test Authoring)
- Verify `packages/native_security/test/native_security_test.dart` handles platform FFI or fallback gracefully.
- Add test in `packages/network/test/ssl/ssl_strategies_test.dart` testing `HardenedSslPinning` with the real server fingerprint string.
- Create automated C++ verification check in `test/security/` or run native compilation check.

### 2. TDD Master (Implementation)
- Ensure `packages/native_security/ios/native_security/Sources/native_security_ffi/native_security.cpp` has:
  ```cpp
  FFI_EXPORT const char *get_ssl_pin_1() {
    static const uint8_t pin1_scrambled[] = {
        0xc1, 0x93, 0xe2, 0xdb, 0xe1, 0xe2, 0xda, 0x9d, 0xe9, 0xe6, 0xc1,
        0x9e, 0x9b, 0x9a, 0xc9, 0xe2, 0xfd, 0xd2, 0xf9, 0xdf, 0xe3, 0xe8,
        0x9c, 0xdb, 0x9b, 0xd9, 0xc8, 0xdc, 0xf8, 0xfb, 0x99, 0xd8, 0xc0,
        0xcd, 0xf9, 0xf0, 0x98, 0xe4, 0xdd, 0xd0, 0xc1, 0xdc, 0xeb, 0x97};
    static char buffer1[64];
    unscramble(pin1_scrambled, sizeof(pin1_scrambled), buffer1);
    return buffer1;
  }
  ```

### 3. System Integration & Verification
- Compile native C++ with `clang++` and run assertion test.
- Run `fvm flutter test packages/network/test/ssl/ssl_strategies_test.dart`.
- Run `fvm flutter analyze packages/native_security packages/network`.

---

## Definition of Done (DoD)
- [ ] Active rotated certificate fingerprint is correctly encoded and unscrambled.
- [ ] Backup pins are preserved.
- [ ] `HardenedSslPinning` unit tests pass with zero failures.
- [ ] Zero static analysis warnings.

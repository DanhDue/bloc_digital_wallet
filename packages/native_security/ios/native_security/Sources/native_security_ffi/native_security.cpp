// Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

#include "native_security.h"
#include <stdlib.h>

// Simple XOR key for obfuscation
#define XOR_KEY 0xAA

FFI_EXPORT void unscramble(const uint8_t *input, int len, char *output) {
  for (int i = 0; i < len; i++) {
    output[i] = (char)(input[i] ^ XOR_KEY);
  }
  output[len] = '\0';
}

FFI_EXPORT const char *get_secure_value(const uint8_t *scrambled, int len) {
  static char buffer[256];
  unscramble(scrambled, len, buffer);
  return buffer;
}

// Example specific getters if needed, but we can also make it generic
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

FFI_EXPORT const char *get_ssl_pin_2() {
  static const uint8_t pin2_scrambled[] = {
      0xc2, 0x93, 0xd0, 0xff, 0x99, 0xe2, 0xf8, 0xc1, 0xe9, 0xc0, 0xe3,
      0xd9, 0x9a, 0xcd, 0xfc, 0xfc, 0xe0, 0xfb, 0xc8, 0xf8, 0xdc, 0xc7,
      0xfe, 0xd2, 0xe0, 0xf0, 0xf3, 0xc6, 0xcd, 0xe0, 0xf0, 0xff, 0xf9,
      0xf3, 0xcb, 0x9a, 0xc2, 0xfb, 0xdc, 0xe2, 0xe0, 0xdd, 0xf3, 0x97};
  static char buffer2[64];
  unscramble(pin2_scrambled, sizeof(pin2_scrambled), buffer2);
  return buffer2;
}

FFI_EXPORT const char *get_ssl_pin_3() {
  static const uint8_t pin3_scrambled[] = {
      0xe6, 0xe5, 0xd3, 0x9a, 0xfd, 0xc0, 0xfd, 0xed, 0xee, 0xdf, 0xf2,
      0xed, 0xcc, 0xfb, 0xdd, 0x9e, 0xe4, 0xde, 0xfc, 0xf9, 0x9e, 0xfb,
      0x9e, 0xe1, 0xec, 0xe3, 0xe2, 0xf2, 0xfe, 0xcf, 0xfd, 0xdb, 0x93,
      0x85, 0xe3, 0x9d, 0xff, 0xd8, 0x9d, 0x81, 0xde, 0xc5, 0x9e, 0x97};
  static char buffer3[64];
  unscramble(pin3_scrambled, sizeof(pin3_scrambled), buffer3);
  return buffer3;
}

// Link anchor (Phase 5 — flutter_super_app_template, task_14 spike finding).
//
// Under SwiftPM the FFI object file is a member of a static archive, and
// the app linker drops any archive member nothing references at link
// time. `__attribute__((used))` on the functions only stops the
// *compiler* dropping them — the linker still omits the whole unreferenced
// member, and `DynamicLibrary.executable()/.process()` then fails. A
// load-time `constructor` that touches every exported function makes this
// translation unit a linker root, so the member is pulled into the app
// binary and the `get_ssl_pin_*` symbols stay in its export table through
// `-dead_strip` in Release builds. `NativeSecurityPlugin.register(with:)`
// force-references them from Swift as a second, independent anchor.
__attribute__((constructor)) static void native_security_link_anchor(void) {
  volatile const void *keep1 = (const void *)get_ssl_pin_1();
  volatile const void *keep2 = (const void *)get_ssl_pin_2();
  volatile const void *keep3 = (const void *)get_ssl_pin_3();
  (void)keep1;
  (void)keep2;
  (void)keep3;
}

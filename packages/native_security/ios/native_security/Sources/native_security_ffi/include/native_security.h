/*
 * Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.
 */

/*
 * coverage:ignore-file
 */

#ifndef NATIVE_SECURITY_H
#define NATIVE_SECURITY_H

#include <stdint.h>

#if defined(_WIN32)
#define FFI_EXPORT __declspec(dllexport)
#else
#define FFI_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

#ifdef __cplusplus
extern "C" {
#endif

FFI_EXPORT const char *get_ssl_pin_1();
FFI_EXPORT const char *get_ssl_pin_2();
FFI_EXPORT const char *get_ssl_pin_3();
FFI_EXPORT void unscramble(const uint8_t *input, int len, char *output);

#ifdef __cplusplus
}
#endif

#endif // NATIVE_SECURITY_H

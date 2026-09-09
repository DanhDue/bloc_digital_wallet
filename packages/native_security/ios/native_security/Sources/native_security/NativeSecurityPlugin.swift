// Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import Flutter
import UIKit
import native_security_ffi

public class NativeSecurityPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // Composition root. `native_security` is an ffiPlugin — there is no
    // Pigeon channel or PlatformView to register here. This entry point
    // exists only to force-reference the C symbols from Swift, a second
    // link anchor alongside the `__attribute__((constructor))` anchor in
    // `native_security.cpp` (task_14 spike), so the FFI static-archive
    // member is guaranteed into the app binary and `get_ssl_pin_*` stays
    // reachable via `DynamicLibrary.executable()/.process()`.
    _ = get_ssl_pin_1()
    _ = get_ssl_pin_2()
    _ = get_ssl_pin_3()
  }
}

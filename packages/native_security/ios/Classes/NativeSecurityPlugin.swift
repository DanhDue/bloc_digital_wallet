// Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import Flutter
import UIKit

public class NativeSecurityPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // Force the linker to keep C symbols by referencing them
    // The functions are declared in native_security.h
    _ = get_ssl_pin_1()
    _ = get_ssl_pin_2()
    _ = get_ssl_pin_3()
  }
}

// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// Centralized configuration for the Shell component across Enterprise and Lean modes.
class ShellConfig {
  const ShellConfig._();

  // shell:config-defaults:begin
  static const int tabCount = 3;
  static const int defaultTabIndex = 2;
  static const bool hasScannerTab = true;
  // shell:config-defaults:end
  // shell:config-lean:begin
  // static const int tabCount = 2;
  // static const int defaultTabIndex = 1;
  // static const bool hasScannerTab = false;
  // shell:config-lean:end
}

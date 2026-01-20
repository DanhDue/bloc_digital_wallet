// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// Splash screen animation constants
class SplashConstants {
  SplashConstants._();

  /// Minimum splash screen display duration
  static const minSplashDuration = Duration(seconds: 8);

  /// Delay before triggering AnimatedVisibility (allows first frame)
  static const visibilityDelay = Duration(milliseconds: 50);

  /// Delay before starting lottie animation (after visibility animation)
  static const lottieDelay = Duration(milliseconds: 1500);

  /// Outer container scale animation duration
  static const containerEnterDuration = Duration(milliseconds: 888);

  /// Inner lottie fade+scale animation duration
  static const lottieEnterDuration = Duration(milliseconds: 1500);

  /// Title text animation duration
  static const titleDuration = Duration(milliseconds: 888);
}

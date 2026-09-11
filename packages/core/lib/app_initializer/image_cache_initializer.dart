// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/app_initializer/app_initializer.dart';
import 'package:flutter/painting.dart';

/// Configures global Flutter [ImageCache] limits to prevent unconstrained graphical
/// RAM accumulation and Out-Of-Memory (OOM) crashes on low/mid-tier devices.
class ImageCacheInitializer implements AppInitializer {
  /// Default max cached image entry count (100 items).
  static const int kDefaultMaximumSize = 100;

  /// Default max cached images byte size ceiling (50MB).
  static const int kDefaultMaximumSizeBytes = 50 * 1024 * 1024;

  final int maximumSize;
  final int maximumSizeBytes;

  const ImageCacheInitializer({
    this.maximumSize = kDefaultMaximumSize,
    this.maximumSizeBytes = kDefaultMaximumSizeBytes,
  });

  @override
  Future<void> init() async {
    PaintingBinding.instance.imageCache.maximumSize = maximumSize;
    PaintingBinding.instance.imageCache.maximumSizeBytes = maximumSizeBytes;
  }
}

// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_platform/platform.dart';
import 'package:core/app_initializer/app_initializer.dart';
import 'package:flutter/widgets.dart';

/// Monitors operating system memory pressure events (e.g. Android Low Memory Killer,
/// iOS Jetsam) and immediately triggers framework cache evictions while broadcasting
/// [LowMemoryEvent] over [AppEventBus] to decoupled Mini App subscribers.
class MemoryPressureObserver with WidgetsBindingObserver implements AppInitializer {
  final AppEventBus? eventBus;
  final ImageCache? imageCache;
  final WidgetsBinding? binding;

  MemoryPressureObserver({this.eventBus, this.imageCache, this.binding});

  /// Registers this observer with [WidgetsBinding] during application bootstrapping.
  @override
  Future<void> init() async {
    (binding ?? WidgetsBinding.instance).addObserver(this);
  }

  /// Removes this observer from [WidgetsBinding].
  void dispose() {
    (binding ?? WidgetsBinding.instance).removeObserver(this);
  }

  /// Intercepts OS low memory pressure signals.
  ///
  /// 1. Flushes Flutter's internal graphics/image cache (both live and dead bitmaps).
  /// 2. Publishes [LowMemoryEvent] onto [AppEventBus] for Mini Apps to drop local caches.
  @override
  void didHaveMemoryPressure() {
    final cache = imageCache ?? PaintingBinding.instance.imageCache;
    cache.clear();
    cache.clearLiveImages();
    eventBus?.publish(const LowMemoryEvent());
  }
}

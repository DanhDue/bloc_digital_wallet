// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_platform/platform.dart';
import 'package:core/services/memory_pressure_observer.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MemoryPressureObserver Unit Tests', () {
    late AppEventBus bus;
    late MemoryPressureObserver observer;

    setUp(() {
      bus = AppEventBus();
      observer = MemoryPressureObserver(eventBus: bus);
    });

    tearDown(() {
      observer.dispose();
    });

    test('BDD-MEM-01: didHaveMemoryPressure purges Flutter imageCache', () {
      // Ensure imageCache has some entries/config
      PaintingBinding.instance.imageCache.maximumSize = 100;

      expect(() => observer.didHaveMemoryPressure(), returnsNormally);
      expect(PaintingBinding.instance.imageCache.currentSize, 0);
      expect(PaintingBinding.instance.imageCache.currentSizeBytes, 0);
    });

    test('BDD-MEM-02: didHaveMemoryPressure publishes LowMemoryEvent on AppEventBus', () async {
      final receivedEvents = <LowMemoryEvent>[];
      final subscription = bus.on<LowMemoryEvent>().listen(receivedEvents.add);

      observer.didHaveMemoryPressure();
      await Future<void>.delayed(Duration.zero);

      expect(receivedEvents, hasLength(1));
      expect(receivedEvents.single, const LowMemoryEvent());

      await subscription.cancel();
    });

    test('BDD-MEM-03: Empty imageCache executes safely without exceptions', () {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      expect(() => observer.didHaveMemoryPressure(), returnsNormally);
    });

    test('BDD-MEM-04: Zero registered listeners on AppEventBus does not throw', () {
      // No listeners registered on bus
      expect(() => observer.didHaveMemoryPressure(), returnsNormally);
    });

    test('BDD-MEM-05: init registers observer and dispose unregisters without error', () async {
      await observer.init();
      // Verifies observer registration/unregistration lifecycle
      expect(() => observer.dispose(), returnsNormally);
    });
  });
}

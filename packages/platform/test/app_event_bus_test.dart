// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_platform/app_event_bus.dart';
import 'package:app_platform/platform.dart' as platform;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

class _TestEventA extends AppEvent {
  const _TestEventA(this.value);

  final int value;
}

class _TestEventB extends AppEvent {
  const _TestEventB();
}

void main() {
  group('AppEventBus', () {
    late AppEventBus bus;

    setUp(() {
      bus = AppEventBus();
    });

    test('a single subscriber receives a published event', () async {
      final received = <_TestEventA>[];
      final subscription = bus.on<_TestEventA>().listen(received.add);

      bus.publish(const _TestEventA(1));
      await Future<void>.delayed(Duration.zero);

      expect(received, hasLength(1));
      expect(received.single.value, 1);

      await subscription.cancel();
    });

    test('on<T>() filters out events of unrelated types', () async {
      final receivedA = <_TestEventA>[];
      final subscription = bus.on<_TestEventA>().listen(receivedA.add);

      bus.publish(const _TestEventB());
      bus.publish(const _TestEventA(42));
      await Future<void>.delayed(Duration.zero);

      expect(receivedA, hasLength(1));
      expect(receivedA.single.value, 42);

      await subscription.cancel();
    });

    test(
      'multiple subscribers each independently receive a published event',
      () async {
        final receivedFirst = <_TestEventA>[];
        final receivedSecond = <_TestEventA>[];
        final subscriptionFirst = bus.on<_TestEventA>().listen(
          receivedFirst.add,
        );
        final subscriptionSecond = bus.on<_TestEventA>().listen(
          receivedSecond.add,
        );

        bus.publish(const _TestEventA(7));
        await Future<void>.delayed(Duration.zero);

        expect(receivedFirst, hasLength(1));
        expect(receivedSecond, hasLength(1));
        expect(receivedFirst.single.value, 7);
        expect(receivedSecond.single.value, 7);

        await subscriptionFirst.cancel();
        await subscriptionSecond.cancel();
      },
    );

    test('publishing before any subscription does not throw', () {
      expect(() => bus.publish(const _TestEventA(99)), returnsNormally);
    });
  });

  group('AppEventBus DI registration', () {
    final getIt = GetIt.instance;

    tearDown(() async {
      await getIt.reset();
    });

    test(
      'is resolvable via getIt after platform.configureModuleDependencies',
      () {
        platform.configureModuleDependencies(getIt);

        expect(getIt.isRegistered<AppEventBus>(), isTrue);
        expect(getIt<AppEventBus>(), isA<AppEventBus>());
      },
    );

    test('is registered as a singleton', () {
      platform.configureModuleDependencies(getIt);

      expect(identical(getIt<AppEventBus>(), getIt<AppEventBus>()), isTrue);
    });
  });
}

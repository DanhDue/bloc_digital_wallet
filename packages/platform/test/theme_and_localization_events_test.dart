// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_platform/app_event_bus.dart';
import 'package:flutter_test/flutter_test.dart';

/// ### BDD SCENARIOS
///
/// Feature: Platform Theme & Localization Infrastructure Events
///   As the core application platform
///   I want typed AppEvents for ThemeModeChanged and AppLanguageChanged
///   So that decoupled packages can reactively synchronize UI state via AppEventBus
///
/// Scenario 1: ThemeModeChanged supports value equality and hashing
///   Given two ThemeModeChanged instances with the same isDarkMode boolean
///   When comparing them with equals operator
///   Then they should be equal and have identical hashCodes
///
/// Scenario 2: AppLanguageChanged supports value equality and hashing
///   Given two AppLanguageChanged instances with the same languageCode
///   When comparing them with equals operator
///   Then they should be equal and have identical hashCodes
///
/// Scenario 3: Publishing ThemeModeChanged delivers typed event to filtered subscribers
///   Given an AppEventBus with a subscriber on ThemeModeChanged
///   When ThemeModeChanged(isDarkMode: true) is published
///   Then subscriber receives exactly one ThemeModeChanged with isDarkMode == true
///
/// Scenario 4: Publishing AppLanguageChanged delivers typed event to filtered subscribers
///   Given an AppEventBus with a subscriber on AppLanguageChanged
///   When AppLanguageChanged(languageCode: 'vi') is published
///   Then subscriber receives exactly one AppLanguageChanged with languageCode == 'vi'
///
/// Scenario 5: Stream isolation and cancellation
///   Given subscriptions to ThemeModeChanged and AppLanguageChanged
///   When ThemeModeChanged is published
///   Then AppLanguageChanged subscriber receives nothing
///   When subscription is cancelled
///   Then further published events are not received
void main() {
  group('ThemeModeChanged & AppLanguageChanged BDD / TDD Scenarios', () {
    test('Scenario 1: ThemeModeChanged supports value equality and hashing', () {
      const event1 = ThemeModeChanged(isDarkMode: true);
      const event2 = ThemeModeChanged(isDarkMode: true);
      const event3 = ThemeModeChanged(isDarkMode: false);

      expect(event1, equals(event2));
      expect(event1.hashCode, equals(event2.hashCode));
      expect(event1, isNot(equals(event3)));
    });

    test('Scenario 2: AppLanguageChanged supports value equality and hashing', () {
      const event1 = AppLanguageChanged(languageCode: 'vi');
      const event2 = AppLanguageChanged(languageCode: 'vi');
      const event3 = AppLanguageChanged(languageCode: 'en');

      expect(event1, equals(event2));
      expect(event1.hashCode, equals(event2.hashCode));
      expect(event1, isNot(equals(event3)));
    });

    test('Scenario 3: Publishing ThemeModeChanged delivers to on<ThemeModeChanged>()', () async {
      final bus = AppEventBus();
      final received = <ThemeModeChanged>[];
      final subscription = bus.on<ThemeModeChanged>().listen(received.add);

      bus.publish(const ThemeModeChanged(isDarkMode: true));
      await Future<void>.delayed(Duration.zero);

      expect(received, hasLength(1));
      expect(received.first.isDarkMode, isTrue);

      await subscription.cancel();
    });

    test('Scenario 4: Publishing AppLanguageChanged delivers to on<AppLanguageChanged>()', () async {
      final bus = AppEventBus();
      final received = <AppLanguageChanged>[];
      final subscription = bus.on<AppLanguageChanged>().listen(received.add);

      bus.publish(const AppLanguageChanged(languageCode: 'vi'));
      await Future<void>.delayed(Duration.zero);

      expect(received, hasLength(1));
      expect(received.first.languageCode, 'vi');

      await subscription.cancel();
    });

    test('Scenario 5: Stream isolation and cancellation', () async {
      final bus = AppEventBus();
      final themeEvents = <ThemeModeChanged>[];
      final langEvents = <AppLanguageChanged>[];

      final themeSub = bus.on<ThemeModeChanged>().listen(themeEvents.add);
      final langSub = bus.on<AppLanguageChanged>().listen(langEvents.add);

      bus.publish(const ThemeModeChanged(isDarkMode: false));
      await Future<void>.delayed(Duration.zero);

      expect(themeEvents, hasLength(1));
      expect(langEvents, isEmpty);

      await themeSub.cancel();
      bus.publish(const ThemeModeChanged(isDarkMode: true));
      await Future<void>.delayed(Duration.zero);

      expect(themeEvents, hasLength(1), reason: 'Cancelled subscription must not receive new events');

      await langSub.cancel();
    });
  });
}

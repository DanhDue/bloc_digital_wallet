// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_platform/platform.dart';
import 'package:d3_nexus_shield/deeplink/deep_link_auth_guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeepLinkAuthGuard', () {
    late AppEventBus eventBus;
    late DeepLinkAuthGuard authGuard;
    late bool isAuthenticated;
    late List<DeepLinkPayload> dispatchedPayloads;
    late int requireLoginCallCount;

    setUp(() {
      eventBus = AppEventBus();
      isAuthenticated = false;
      dispatchedPayloads = [];
      requireLoginCallCount = 0;

      authGuard = DeepLinkAuthGuard(
        eventBus: eventBus,
        isAuthenticated: () => isAuthenticated,
        onRequireLogin: () {
          requireLoginCallCount++;
        },
      );
    });

    tearDown(() {
      authGuard.dispose();
    });

    test('Public Route: Passes through directly even when unauthenticated', () {
      isAuthenticated = false;
      const publicPayload = DeepLinkPayload(
        path: DeepLinkRoutes.settings,
        targetTab: 2,
        isProtected: false,
      );

      authGuard.evaluate(
        publicPayload,
        onAllowed: (payload) {
          dispatchedPayloads.add(payload);
        },
      );

      expect(dispatchedPayloads, [publicPayload]);
      expect(requireLoginCallCount, 0);
      expect(authGuard.pendingPayload, isNull);
    });

    test('Protected Route: Passes through directly when authenticated', () {
      isAuthenticated = true;
      const protectedPayload = DeepLinkPayload(
        path: DeepLinkRoutes.wallet,
        targetTab: null,
        isProtected: true,
      );

      authGuard.evaluate(
        protectedPayload,
        onAllowed: (payload) {
          dispatchedPayloads.add(payload);
        },
      );

      expect(dispatchedPayloads, [protectedPayload]);
      expect(requireLoginCallCount, 0);
      expect(authGuard.pendingPayload, isNull);
    });

    test('Protected Route: Diverts to login and stores pending payload when unauthenticated', () {
      isAuthenticated = false;
      const protectedPayload = DeepLinkPayload(
        path: DeepLinkRoutes.wallet,
        targetTab: null,
        isProtected: true,
      );

      authGuard.evaluate(
        protectedPayload,
        onAllowed: (payload) {
          dispatchedPayloads.add(payload);
        },
      );

      expect(dispatchedPayloads, isEmpty);
      expect(requireLoginCallCount, 1);
      expect(authGuard.pendingPayload, protectedPayload);
    });

    test(
      'Post-Login Resume: Automatically resumes pending payload when LoginSuccessEvent is received',
      () async {
        isAuthenticated = false;
        const protectedPayload = DeepLinkPayload(
          path: DeepLinkRoutes.wallet,
          targetTab: null,
          isProtected: true,
        );

        authGuard.evaluate(
          protectedPayload,
          onAllowed: (payload) {
            dispatchedPayloads.add(payload);
          },
        );

        expect(dispatchedPayloads, isEmpty);
        expect(authGuard.pendingPayload, protectedPayload);

        // Simulate user successfully logging in
        isAuthenticated = true;
        eventBus.publish(const LoginSuccessEvent(userId: 'user_123'));
        await Future<void>.delayed(Duration.zero);

        // Now it should be dispatched and cleared
        expect(dispatchedPayloads, [protectedPayload]);
        expect(authGuard.pendingPayload, isNull);
      },
    );

    test('UserLoggedOut: Clears pending payload if user logs out', () async {
      isAuthenticated = false;
      const protectedPayload = DeepLinkPayload(
        path: DeepLinkRoutes.wallet,
        targetTab: null,
        isProtected: true,
      );

      authGuard.evaluate(
        protectedPayload,
        onAllowed: (payload) {
          dispatchedPayloads.add(payload);
        },
      );

      expect(authGuard.pendingPayload, protectedPayload);

      // User session invalidated
      eventBus.publish(const UserLoggedOut());
      await Future<void>.delayed(Duration.zero);

      expect(authGuard.pendingPayload, isNull);
      expect(dispatchedPayloads, isEmpty);
    });
  });
}

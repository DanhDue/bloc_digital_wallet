// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_platform/platform.dart';
import 'package:d3_nexus_shield/deeplink/deep_link_navigator.dart';
import 'package:d3_nexus_shield/shell/shell_action.dart';
import 'package:d3_nexus_shield/shell/shell_bloc.dart';

class MockStackRouter extends Mock implements StackRouter {}

class MockShellBloc extends Mock implements ShellBloc {}

class FakePageRouteInfo extends Fake implements PageRouteInfo {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
    registerFallbackValue(const ShellAction.started());
  });

  late MockStackRouter mockRouter;
  late MockShellBloc mockShellBloc;
  late DeepLinkNavigator navigator;

  setUp(() {
    mockRouter = MockStackRouter();
    mockShellBloc = MockShellBloc();

    when(() => mockRouter.push(any())).thenAnswer((_) async => null);

    navigator = DeepLinkNavigator(
      shellBlocProvider: () => mockShellBloc,
      appRouter: mockRouter,
      routeResolvers: {'/settings/languages': (payload) => FakePageRouteInfo()},
    );
  });

  group('DeepLinkNavigator Smart Hybrid Navigation', () {
    test('Root Tab Route (/scanner): Dispatches ShellAction.tabChanged(1)', () async {
      const payload = DeepLinkPayload(path: DeepLinkRoutes.scanner, targetTab: 1);

      await navigator.navigate(payload);

      verify(() => mockShellBloc.onAction(const ShellAction.tabChanged(1))).called(1);
      verifyNever(() => mockRouter.push(any()));
    });

    test('Root Tab Route (/settings): Dispatches ShellAction.tabChanged(2)', () async {
      const payload = DeepLinkPayload(path: DeepLinkRoutes.settings, targetTab: 2);

      await navigator.navigate(payload);

      verify(() => mockShellBloc.onAction(const ShellAction.tabChanged(2))).called(1);
      verifyNever(() => mockRouter.push(any()));
    });

    test('Nested Route (/settings/languages): Invokes appRouter.push(...)', () async {
      const payload = DeepLinkPayload(path: '/settings/languages');

      await navigator.navigate(payload);

      verify(() => mockRouter.push(any())).called(1);
      verifyNever(() => mockShellBloc.onAction(any()));
    });

    test(
      'Invalid Route (/unknown/path): Fallback gracefully to ShellAction.tabChanged(0)',
      () async {
        const payload = DeepLinkPayload(path: '/unknown/path', isFallback: true);

        await navigator.navigate(payload);

        verify(() => mockShellBloc.onAction(const ShellAction.tabChanged(0))).called(1);
        verifyNever(() => mockRouter.push(any()));
      },
    );
  });
}

// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/ssl/ssl.dart';
import 'package:talker_flutter/talker_flutter.dart';

class _FakeCert implements X509Certificate {
  _FakeCert(this._der);
  final List<int> _der;
  @override
  Uint8List get der => Uint8List.fromList(_der);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late Talker talker;
  setUp(() => talker = Talker());

  group('StaticFingerprintSource', () {
    test('.empty() carries nothing', () {
      expect(const StaticFingerprintSource.empty().isEmpty, isTrue);
      expect(const StaticFingerprintSource.empty().fingerprintsFor('a.com'), isEmpty);
    });

    test('merges anyHost with host-specific entries', () {
      const src = StaticFingerprintSource(
        anyHost: ['ANY'],
        byHost: {
          'api.foo.com': ['FOO1', 'FOO2'],
        },
      );
      expect(src.fingerprintsFor('api.foo.com'), ['ANY', 'FOO1', 'FOO2']);
      expect(src.fingerprintsFor('other.com'), ['ANY']);
      expect(src.isEmpty, isFalse);
    });
  });

  group('AutoSslConfiguration.releaseStrategy', () {
    const src = StaticFingerprintSource(anyHost: ['X']);

    test('pinning on + source ⇒ HardenedSslPinning', () {
      expect(
        AutoSslConfiguration.releaseStrategy(pinningEnabled: true, source: src),
        isA<HardenedSslPinning>(),
      );
    });

    test('pinning off ⇒ NoSslPinning', () {
      expect(
        AutoSslConfiguration.releaseStrategy(pinningEnabled: false, source: src),
        isA<NoSslPinning>(),
      );
    });

    test('pinning on but no source ⇒ NoSslPinning', () {
      expect(
        AutoSslConfiguration.releaseStrategy(pinningEnabled: true, source: null),
        isA<NoSslPinning>(),
      );
    });
  });

  group('configure()', () {
    test('NoSslPinning leaves the adapter untouched', () {
      final dio = Dio();
      const NoSslPinning().configure(dio, talker);
      expect((dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient, isNull);
    });

    test('HardenedSslPinning installs a createHttpClient hook', () {
      final dio = Dio();
      HardenedSslPinning(
        source: const StaticFingerprintSource(anyHost: ['X']),
      ).configure(dio, talker);
      expect((dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient, isNotNull);
    });
  });

  group('HardenedSslPinning.accepts (the badCertificateCallback body)', () {
    final der = utf8.encode('leaf-cert-bytes');
    final pin = HardenedSslPinning(
      source: StaticFingerprintSource(
        byHost: {
          'api.foo.com': [HardenedSslPinning.fingerprintOf(_FakeCert(der))],
        },
      ),
    );

    test('accepts a matching fingerprint for a pinned host', () {
      expect(pin.accepts(_FakeCert(der), 'api.foo.com'), isTrue);
    });

    test('rejects a mismatching fingerprint', () {
      expect(pin.accepts(_FakeCert(utf8.encode('other')), 'api.foo.com'), isFalse);
    });

    test('rejects a host with no configured fingerprints (fail-closed)', () {
      expect(pin.accepts(_FakeCert(der), 'unpinned.com'), isFalse);
    });
  });
}

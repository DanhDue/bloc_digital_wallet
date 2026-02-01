// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:convert';
import 'dart:io';

import 'package:bloc_digital_wallet/config/environment_config.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:native_security/native_security.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DioFactory {
  final Talker _talker;

  Duration _connectTimeout = const Duration(minutes: 1);
  Duration _receiveTimeout = const Duration(minutes: 1);

  DioFactory(this._talker);

  DioFactory withConnectTimeout(Duration timeout) {
    _connectTimeout = timeout;
    return this;
  }

  DioFactory withReceiveTimeout(Duration timeout) {
    _receiveTimeout = timeout;
    return this;
  }

  Dio? _dio;

  Dio get dio {
    _dio ??= _createDio();
    return _dio!;
  }

  Dio _createDio() {
    final baseUrl = EnvironmentConfig.apiBaseUrl;

    final dioInstance = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    if (EnvironmentConfig.enableLogging) {
      dioInstance.interceptors.add(
        TalkerDioLogger(
          talker: _talker,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: false,
            printRequestData: true,
            printResponseData: true,
          ),
        ),
      );
    }

    // AuthInterceptor is added via Dependency Injection in NetworkModule

    // True SSL Pinning implementation
    if (!kIsWeb) {
      if (kDebugMode) {
        // Allow self-signed certificates in debug mode for development
        (dioInstance.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        };
      } else {
        (dioInstance.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
          // withTrustedRoots: false ensures that NO system-trusted CAs are used.
          // This forces badCertificateCallback to be called for ALL certificates,
          // allowing us to manually validate even "valid" CA-signed certificates.
          final client = HttpClient(context: SecurityContext(withTrustedRoots: false));
          client.badCertificateCallback = (X509Certificate cert, String host, int port) {
            // Hardened fingerprints from C++ via FFI package
            List<String> hardenedFingerprints = [];
            try {
              hardenedFingerprints = NativeSecurity.getAllowedFingerprints();
              _talker.debug('Hardened fingerprints loaded: $hardenedFingerprints');
            } catch (e) {
              _talker.error('Failed to load hardened fingerprints via FFI', e);
            }

            // Calculate the SHA-256 digest of the DER-encoded certificate
            final hash = sha256.convert(cert.der);

            // Encode to Base64 to match standard fingerprint formats
            final fingerprint = base64.encode(hash.bytes);

            _talker.debug('Handshake fingerprint: $fingerprint');

            final isValid = hardenedFingerprints.contains(fingerprint);
            if (!isValid) {
              _talker.warning('SSL Pinning failed for $host. Fingerprint mismatch.');
            }
            return isValid;
          };
          return client;
        };
      }
    }

    return dioInstance;
  }
}

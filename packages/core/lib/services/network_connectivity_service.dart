// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Represents the network connection reachability status.
enum NetworkStatus { online, offline, unknown }

/// Abstract contract for monitoring network connectivity and true internet reachability.
abstract class INetworkConnectivityService {
  /// Stream broadcasting network reachability updates.
  Stream<NetworkStatus> get onStatusChanged;

  /// Returns true if currently connected to the internet with reachability.
  Future<bool> get isConnected;

  /// Disposes active subscriptions and resources.
  void dispose();
}

/// Hybrid connectivity service combining OS interface detection (via [Connectivity])
/// and real socket reachability probing (via [InternetConnection]).
class NetworkConnectivityService implements INetworkConnectivityService {
  NetworkConnectivityService({
    Connectivity? connectivity,
    Future<bool> Function()? checkInternetAccess,
    Duration debounceDuration = const Duration(milliseconds: 500),
  }) : _connectivity = connectivity ?? Connectivity(),
       _checkInternetAccess =
           checkInternetAccess ?? (() => InternetConnection().hasInternetAccess),
       _debounceDuration = debounceDuration {
    _init();
  }

  final Connectivity _connectivity;
  final Future<bool> Function() _checkInternetAccess;
  final Duration _debounceDuration;

  final StreamController<NetworkStatus> _statusController =
      StreamController<NetworkStatus>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _debounceTimer;
  NetworkStatus _currentStatus = NetworkStatus.unknown;

  @override
  Stream<NetworkStatus> get onStatusChanged => _statusController.stream;

  @override
  Future<bool> get isConnected async {
    if (_currentStatus != NetworkStatus.unknown) {
      return _currentStatus == NetworkStatus.online;
    }
    return _checkInternetAccess();
  }

  void _init() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityResultsReceived,
    );
  }

  void _onConnectivityResultsReceived(List<ConnectivityResult> results) {
    if (_debounceDuration > Duration.zero) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(_debounceDuration, () => _handleConnectivityResults(results));
    } else {
      _handleConnectivityResults(results);
    }
  }

  Future<void> _handleConnectivityResults(List<ConnectivityResult> results) async {
    final isHardwareDisconnected =
        results.isEmpty || results.every((r) => r == ConnectivityResult.none);

    if (isHardwareDisconnected) {
      _updateStatus(NetworkStatus.offline);
      return;
    }

    // Probe true internet reachability to eliminate captive portal false positives
    final hasAccess = await _checkInternetAccess();
    final status = hasAccess ? NetworkStatus.online : NetworkStatus.offline;
    _updateStatus(status);
  }

  void _updateStatus(NetworkStatus status) {
    _currentStatus = status;
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _connectivitySubscription?.cancel();
    _statusController.close();
  }
}

// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
// TODO: Uncomment when adding action handlers
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_digital_wallet/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/network_selection/network_selection_action.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/network_selection/network_selection_event.dart';
import 'package:bloc_digital_wallet/features/wallet/data/models/network_object.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/network_selection/network_selection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// NetworkSelection BLoC
/// ============================================================================
/// The BLoC processes Actions and emits States/Events.
///
/// HOW TO EXTEND:
/// 1. Add use case dependencies via constructor injection
/// 2. Register action handlers in constructor using handleAction methods
/// 3. Implement handler methods that emit new states/events
///
/// EXAMPLE - Adding use case and handler:
/// ```dart
/// @injectable
/// class NetworkSelectionBloc extends MviBloc<...> {
///   final GetNetworkSelectionUseCase _getNetworkSelectionUseCase;
///
///   NetworkSelectionBloc(this._getNetworkSelectionUseCase)
///       : super(const NetworkSelectionInitial()) {
///     handleActionDroppable<LoadNetworkSelectionAction>(_onLoad);
///   }
///
///   Future<void> _onLoad(
///     LoadNetworkSelectionAction action,
///     Emitter<NetworkSelectionState> emit,
///   ) async {
///     emit(const NetworkSelectionLoading());
///     final result = await _getNetworkSelectionUseCase();
///     result.fold(
///       (failure) => emit(NetworkSelectionError(failure.message)),
///       (data) => emit(NetworkSelectionSuccess(data)),
///     );
///   }
/// }
/// ```
///
/// ACTION HANDLER TYPES:
/// - handleActionDroppable: Drops new actions while processing (default)
/// - handleActionSequential: Queues actions, processes one at a time
/// - handleActionConcurrent: Processes actions concurrently
/// ============================================================================

@injectable
class NetworkSelectionBloc
    extends MviBloc<NetworkSelectionAction, NetworkSelectionState, NetworkSelectionEvent> {
  final WalletRemoteDataSource _walletRemoteDataSource;

  List<NetworkObject> _allNetworks = [];

  NetworkSelectionBloc(this._walletRemoteDataSource) : super(const NetworkSelectionInitial()) {
    handleActionDroppable<LoadNetworkSelectionAction>(_onLoad);
    handleActionDroppable<SearchNetworkSelectionAction>(_onSearch);
  }

  Future<void> _onLoad(
    LoadNetworkSelectionAction action,
    Emitter<NetworkSelectionState> emit,
  ) async {
    emit(const NetworkSelectionLoading());
    final result = await _walletRemoteDataSource.getNetworks();
    result.fold((failure) => emit(NetworkSelectionError(failure.message)), (data) {
      _allNetworks = data.data ?? [];
      emit(NetworkSelectionSuccess(_allNetworks));
    });
  }

  Future<void> _onSearch(
    SearchNetworkSelectionAction action,
    Emitter<NetworkSelectionState> emit,
  ) async {
    final query = action.query.toLowerCase().trim();
    if (query.isEmpty) {
      emit(NetworkSelectionSuccess(_allNetworks));
      return;
    }

    final filtered = _allNetworks.where((element) {
      final name = element.name?.toLowerCase() ?? '';
      return name.contains(query);
    }).toList();

    emit(NetworkSelectionSuccess(filtered));
  }
}

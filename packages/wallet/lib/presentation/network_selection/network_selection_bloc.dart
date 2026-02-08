// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:framework/framework.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/data/datasources/remote/network_selection_remote_datasource.dart';
import 'package:wallet/domain/entities/network_selection_entity.dart';
import 'package:wallet/presentation/network_selection/network_selection_action.dart';
import 'package:wallet/presentation/network_selection/network_selection_event.dart';
import 'package:wallet/presentation/network_selection/network_selection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@injectable
class NetworkSelectionBloc
    extends MviBloc<NetworkSelectionAction, NetworkSelectionState, NetworkSelectionEvent> {
  final NetworkSelectionRemoteDataSource _dataSource;

  List<NetworkSelectionEntity> _allNetworks = [];

  NetworkSelectionBloc(this._dataSource) : super(const NetworkSelectionState()) {
    on<NetworkSelectionAction>(_onAction);
  }

  Future<void> _onAction(
    NetworkSelectionAction action,
    Emitter<NetworkSelectionState> emit,
  ) async {
    await action.when(load: () => _onLoad(emit), search: (query) => _onSearch(query, emit));
  }

  Future<void> _onLoad(Emitter<NetworkSelectionState> emit) async {
    emit(state.copyWith(status: NetworkSelectionStatus.loading));
    final result = await _dataSource.getNetworks();
    result.fold(
      (failure) => emit(
        state.copyWith(status: NetworkSelectionStatus.failure, errorMessage: failure.message),
      ),
      (networks) {
        _allNetworks = networks;
        emit(
          state.copyWith(
            status: NetworkSelectionStatus.success,
            uiModel: state.uiModel.copyWith(networks: networks),
          ),
        );
      },
    );
  }

  Future<void> _onSearch(String query, Emitter<NetworkSelectionState> emit) async {
    final trimmedQuery = query.toLowerCase().trim();
    if (trimmedQuery.isEmpty) {
      emit(
        state.copyWith(
          uiModel: state.uiModel.copyWith(networks: _allNetworks, searchQuery: query),
        ),
      );
      return;
    }

    final filtered = _allNetworks.where((element) {
      final name = element.name?.toLowerCase() ?? '';
      return name.contains(trimmedQuery);
    }).toList();

    emit(
      state.copyWith(
        uiModel: state.uiModel.copyWith(networks: filtered, searchQuery: query),
      ),
    );
  }
}

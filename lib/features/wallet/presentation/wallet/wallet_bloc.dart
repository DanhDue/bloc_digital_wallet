// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/usecases/get_wallet_usecase.dart';
import '../../domain/usecases/get_all_wallets_usecase.dart';
import 'wallet_action.dart';
import 'wallet_state.dart';
import 'wallet_event.dart';

@injectable
class WalletBloc extends MviBloc<WalletAction, WalletState, WalletEvent> {
  final GetWalletUseCase getWalletUseCase;
  final GetAllWalletsUseCase getAllWalletsUseCase;

  WalletBloc({required this.getWalletUseCase, required this.getAllWalletsUseCase})
    : super(const WalletInitial()) {
    // Register action handlers
    handleAction(null, _onLoadAllWallets);
    handleAction(null, _onLoadWallet);
    handleAction(null, _onCreateWallet);
    handleAction(null, _onUpdateWallet);
    handleAction(null, _onDeleteWallet);
    handleAction(null, _onRefreshWallets);
  }

  /// Single entry point for all actions (Following Android pattern)
  /// This is the ONLY method View should call
  @override
  void onAction(WalletAction action) {
    add(action);
  }

  Future<void> _onLoadAllWallets(LoadAllWalletsAction action, Emitter<WalletState> emit) async {
    emit(const WalletLoading());

    final result = await getAllWalletsUseCase();

    result.fold(
      (failure) {
        emit(WalletError(failure.message));
        emitEvent(ShowErrorMessage(failure.message));
      },
      (items) {
        if (items.isEmpty) {
          emit(const WalletEmpty());
        } else {
          emit(WalletsLoaded(items));
        }
      },
    );
  }

  Future<void> _onLoadWallet(LoadWalletAction action, Emitter<WalletState> emit) async {
    emit(const WalletLoading());

    final result = await getWalletUseCase(action.id);

    result.fold((failure) {
      emit(WalletError(failure.message));
      emitEvent(ShowErrorMessage(failure.message));
    }, (item) => emit(WalletLoaded(item)));
  }

  Future<void> _onCreateWallet(CreateWalletAction action, Emitter<WalletState> emit) async {
    // TODO: Implement create logic
    emitEvent(const ShowSuccessMessage('Created successfully'));
  }

  Future<void> _onUpdateWallet(UpdateWalletAction action, Emitter<WalletState> emit) async {
    // TODO: Implement update logic
    emitEvent(const ShowSuccessMessage('Updated successfully'));
  }

  Future<void> _onDeleteWallet(DeleteWalletAction action, Emitter<WalletState> emit) async {
    // TODO: Implement delete logic
    emitEvent(const ShowSuccessMessage('Deleted successfully'));
  }

  Future<void> _onRefreshWallets(RefreshWalletsAction action, Emitter<WalletState> emit) async {
    // Reload all items
    add(const LoadAllWalletsAction());
  }
}

// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:wallet/domain/usecases/get_token_accounts_usecase.dart';

import 'models/token_list_ui_model.dart';

/// TokenListBloc using BaseInfiniteListBloc for paginated token loading
@injectable
class TokenListBloc extends BaseInfiniteListBloc<TokenListUiModel> {
  final GetTokenAccountsUseCase _getTokenAccountsUseCase;

  String? _walletAddress;

  TokenListBloc(this._getTokenAccountsUseCase);

  void updateWalletAddress(String address) {
    _walletAddress = address;
    add(const InfiniteListFetchFirstPage());
  }

  @override
  Future<List<TokenListUiModel>> fetchItems({required int page, required int limit}) async {
    // For now, return data on first page only (API returns all tokens at once)
    if (page > 0) return [];

    if (_walletAddress == null || _walletAddress!.isEmpty) return [];

    final result = await _getTokenAccountsUseCase(_walletAddress!);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (tokens) => tokens.map(TokenListUiModel.fromEntity).toList(),
    );
  }
}

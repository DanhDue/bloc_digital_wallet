// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/core/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_digital_wallet/di/injection.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/core/components/infinite_list/base_infinite_list_event.dart';
import 'package:bloc_digital_wallet/core/components/infinite_list/base_infinite_list_state.dart';
import 'package:bloc_digital_wallet/features/wallet/domain/entities/token_account_entity.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/token_list/widgets/token_item_view.dart';
import 'token_list_bloc.dart';
import 'package:bloc_digital_wallet/features/wallet/domain/entities/wallet_entity.dart';

@RoutePage()
class TokenListPage extends StatelessWidget {
  final WalletEntity? wallet;

  const TokenListPage({super.key, this.wallet});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(wallet?.address),
      create: (_) => getIt<TokenListBloc>()..updateWalletAddress(wallet?.address ?? ''),
      child: BlocBuilder<TokenListBloc, BaseInfiniteListState<TokenAccountEntity>>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<TokenListBloc>().add(const InfiniteListRefresh());
              // Wait for refresh to complete
              await context.read<TokenListBloc>().stream.firstWhere(
                (s) => !s.isRefreshing && s.status != InfiniteListStatus.loading,
              );
            },
            // Only show loading on initial load (not during refresh)
            child: state.status == InfiniteListStatus.loading && !state.isRefreshing
                ? Container(
                    color: context.appThemes.white,
                    child: const Center(
                      child: Column(children: [SizedBox(height: 36), CustomLoadingWidget()]),
                    ),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      color: context.appThemes.white,
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          // Error state
                          if (state.status == InfiniteListStatus.failure)
                            Padding(
                              padding: const .symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  state.errorMessage ?? 'Error loading tokens',
                                  style: context.appThemes.bodyMedium.copyWith(
                                    color: context.appThemes.errorColor,
                                  ),
                                ),
                              ),
                            ),

                          // Empty state
                          if (state.status == InfiniteListStatus.success && state.items.isEmpty)
                            Padding(
                              padding: const .symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  'No tokens found',
                                  style: context.appThemes.bodyMedium.copyWith(
                                    color: context.appThemes.textSecondaryColor,
                                  ),
                                ),
                              ),
                            ),

                          // Token list (wrap content)
                          if (state.items.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.items.length,
                              itemBuilder: (context, index) {
                                final token = state.items[index];
                                return TokenItemView(
                                  token: token,
                                  isFirst: index == 0,
                                  onTap: () {
                                    // TODO: Navigate to token detail
                                  },
                                );
                              },
                            ),

                          // Loading more indicator
                          if (state.isLoadingMore)
                            const Padding(
                              padding: .symmetric(vertical: 8),
                              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

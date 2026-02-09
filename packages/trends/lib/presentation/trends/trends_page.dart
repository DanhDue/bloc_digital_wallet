// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:trends/presentation/trends/trends_action.dart';
import 'package:trends/presentation/trends/trends_bloc.dart';
import 'package:trends/presentation/trends/trends_event.dart';
import 'package:trends/presentation/trends/trends_state.dart';
import 'package:trends/presentation/trends/widgets/coin_market_item.dart';
import 'package:trends/presentation/trends/widgets/trends_search_bar.dart';
import 'package:trends/trends_strings.dart';

@RoutePage()
class TrendsPage extends BaseMviPage<TrendsBloc, TrendsAction, TrendsState, TrendsEvent> {
  const TrendsPage({super.key});

  @override
  TrendsAction? get initialAction => const TrendsAction.started();

  @override
  Widget handleState(BuildContext context, TrendsState state) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            children: [
              TrendsSearchBar(
                onChanged: (value) => context.read<TrendsBloc>().add(TrendsAction.search(value)),
                history: state.searchHistory,
                onFocusChanged: (focused) => context.read<TrendsBloc>().add(
                  TrendsAction.searchFocusChanged(isFocused: focused),
                ),
                onMicTap: () => context.read<TrendsBloc>().add(const TrendsAction.micTap()),
                onHistoryTap: (value) =>
                    context.read<TrendsBloc>().add(TrendsAction.historyTap(value)),
              ),
              const SizedBox(height: 8),
              Expanded(child: _buildContent(context, state)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TrendsState state) {
    switch (state.status) {
      case TrendsStatus.initial:
        return const SizedBox.shrink();
      case TrendsStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case TrendsStatus.failure:
        return _buildError(context, state);
      case TrendsStatus.success:
      case TrendsStatus.loadingMore:
        return _buildCoinList(context, state);
    }
  }

  Widget _buildError(BuildContext context, TrendsState state) {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Text(state.errorMessage ?? TrendsStrings.l10n.trendsError),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<TrendsBloc>().add(const TrendsAction.started()),
            child: Text(TrendsStrings.l10n.trendsRetry),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinList(BuildContext context, TrendsState state) {
    final coins = state.filteredCoins;

    if (coins.isEmpty) {
      return Center(child: Text(TrendsStrings.l10n.trendsNoCoinsFound));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 200 &&
            state.status != TrendsStatus.loadingMore &&
            !state.hasReachedEnd) {
          context.read<TrendsBloc>().add(const TrendsAction.loadMore());
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<TrendsBloc>().add(const TrendsAction.started());
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: coins.length + (state.status == TrendsStatus.loadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= coins.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final coin = coins[index];
            return CoinMarketItem(
              coin: coin,
              isFirst: index == 0,
              onTap: () {
                // Future: Navigate to coin detail
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void handleEvent(BuildContext context, TrendsEvent event) {
    event.when(
      initial: () {
        // Handle side-effect events here (navigation, toasts, etc.)
      },
    );
  }
}

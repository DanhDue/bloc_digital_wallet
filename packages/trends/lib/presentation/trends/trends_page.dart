// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:trends/presentation/trends/models/coin_market_ui_model.dart';
import 'package:trends/presentation/trends/trends_bloc.dart';
import 'package:trends/presentation/trends/trends_event.dart';
import 'package:trends/presentation/trends/trends_state.dart';
import 'package:trends/presentation/trends/widgets/coin_market_item.dart';
import 'package:trends/presentation/trends/widgets/trends_search_bar.dart';
import 'package:trends/trends_strings.dart';
import 'package:ui_kit/components/infinite_list/base_infinite_list_event.dart';
import 'package:ui_kit/components/infinite_list/base_infinite_list_state.dart';
import 'package:ui_kit/widgets/custom_loading_widget.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class TrendsPage extends StatelessWidget {
  const TrendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrendsBloc>(
      create: (_) {
        final bloc = GetIt.instance<TrendsBloc>();
        bloc.add(const InfiniteListFetchFirstPage());
        return bloc;
      },
      child: Scaffold(
        backgroundColor: context.appThemes.backgroundColor,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: const Column(
              children: [
                _TrendsSearchBar(),
                SizedBox(height: 8),
                Expanded(child: _TrendsListContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrendsSearchBar extends StatelessWidget {
  const _TrendsSearchBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrendsBloc, BaseInfiniteListState<CoinMarketUiModel>>(
      buildWhen: (prev, curr) {
        final prevState = prev as TrendsState;
        final currState = curr as TrendsState;
        return prevState.searchHistory != currState.searchHistory ||
            prevState.isSearchFocused != currState.isSearchFocused;
      },
      builder: (context, state) {
        final trendsState = state as TrendsState;
        return TrendsSearchBar(
          onChanged: (value) => context.read<TrendsBloc>().add(TrendsSearch(value)),
          onSubmitted: (value) => context.read<TrendsBloc>().add(TrendsSearchSubmitted(value)),
          history: trendsState.searchHistory,
          onFocusChanged: (focused) =>
              context.read<TrendsBloc>().add(TrendsSearchFocusChanged(isFocused: focused)),
          onMicTap: () => context.read<TrendsBloc>().add(const TrendsMicTap()),
          onHistoryTap: (value) => context.read<TrendsBloc>().add(TrendsHistoryTap(value)),
        );
      },
    );
  }
}

class _TrendsListContent extends StatefulWidget {
  const _TrendsListContent();

  @override
  State<_TrendsListContent> createState() => _TrendsListContentState();
}

class _TrendsListContentState extends State<_TrendsListContent> {
  final _scrollController = ScrollController();
  static const _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TrendsBloc>().add(const InfiniteListFetchNextPage());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - _scrollThreshold);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrendsBloc, BaseInfiniteListState<CoinMarketUiModel>>(
      builder: (context, state) {
        final trendsState = state as TrendsState;

        if (state.status == InfiniteListStatus.initial ||
            (state.status == InfiniteListStatus.loading && state.items.isEmpty)) {
          return const Center(child: CustomLoadingWidget());
        }

        if (state.status == InfiniteListStatus.failure && state.items.isEmpty) {
          return _buildErrorWidget(context, state);
        }

        // Use displayItems for filtering support
        final displayItems = trendsState.displayItems;

        if (displayItems.isEmpty) {
          return Center(child: Text(TrendsStrings.t.trends.search.noCoinsFound));
        }

        // Hide loader if searching
        final showLoader = !state.hasReachedMax && trendsState.searchKeyword.isEmpty;
        final itemCount = showLoader ? displayItems.length + 1 : displayItems.length;

        return RefreshIndicator(
          onRefresh: () async {
            final bloc = context.read<TrendsBloc>();
            bloc.add(const InfiniteListRefresh());
            // Wait for refresh to complete; silently ignore if bloc closes
            try {
              await bloc.stream.firstWhere(
                (s) => !s.isRefreshing && s.status != InfiniteListStatus.loading,
              );
            } on StateError catch (_) {
              // Bloc was closed before refresh completed (e.g. navigation)
            }
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index >= displayItems.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CustomLoadingWidget()),
                );
              }
              return Padding(
                padding: index > 0 ? const EdgeInsets.only(top: 8) : EdgeInsets.zero,
                child: CoinMarketItem(
                  coin: displayItems[index],
                  isFirst: index == 0,
                  onTap: () {
                    // Future: Navigate to coin detail
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, BaseInfiniteListState<CoinMarketUiModel> state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state.errorMessage ?? TrendsStrings.t.trends.error.message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<TrendsBloc>().add(const InfiniteListFetchFirstPage()),
            child: Text(TrendsStrings.t.trends.error.retry),
          ),
        ],
      ),
    );
  }
}

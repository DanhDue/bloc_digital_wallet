// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:transaction/presentation/transaction/bloc/transaction_bloc.dart';
import 'package:transaction/presentation/transaction/transaction_action.dart';
import 'package:transaction/presentation/transaction/transaction_event.dart';
import 'package:transaction/presentation/transaction/transaction_state.dart';
import 'package:transaction/presentation/transaction/ui_models/transaction_list_item.dart';
import 'package:transaction/presentation/transaction/widgets/filter_toggle_widget.dart';
import 'package:transaction/presentation/transaction/widgets/transaction_header_widget.dart';
import 'package:transaction/presentation/transaction/widgets/transaction_item_widget.dart';
import 'package:transaction/presentation/transaction/widgets/wallet_selector_widget.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:transaction/transaction_strings.dart';

@RoutePage()
class TransactionPage
    extends BaseMviPage<TransactionBloc, TransactionAction, TransactionState, TransactionEvent> {
  const TransactionPage({super.key});

  @override
  TransactionAction? get initialAction => const TransactionAction.started();

  @override
  Widget handleState(BuildContext context, TransactionState state) {
    return Scaffold(
      backgroundColor: context.appThemes.white,
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            const WalletSelectorWidget(),
            const SizedBox(height: 24),
            // We need a BlocBuilder here for filter toggle to change independently if we want?
            // But handleState rebuilds on any state change.
            // Since BaseMviPage uses BlocBuilder<B, S>(builder: handleState),
            // the whole handleState is rebuilt.
            // So we don't need nested BlocBuilder unless for optimizing specific parts.
            // But FilterToggle was using buildWhen.
            // Optimization:
            BlocBuilder<TransactionBloc, TransactionState>(
              buildWhen: (p, c) => p.filterIndex != c.filterIndex,
              builder: (context, state) {
                return FilterToggleWidget(
                  selectedIndex: state.filterIndex,
                  onFilterChanged: (index) {
                    context.read<TransactionBloc>().add(TransactionAction.filterChanged(index));
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  // Logic for loading/error/list
                  if (state.isLoading && state.items.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.error != null && state.items.isEmpty) {
                    return Center(child: Text(state.error!));
                  }

                  if (state.items.isEmpty && !state.isLoading) {
                    return Center(child: Text(TransactionStrings.t.noData));
                  }

                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<TransactionBloc>().add(const TransactionAction.refresh()),
                    child: ListView.separated(
                      padding: .zero,
                      itemCount: state.items.length + (state.hasReachedMax ? 0 : 1),
                      separatorBuilder: (_, _) => const SizedBox.shrink(),
                      itemBuilder: (context, index) {
                        if (index >= state.items.length) {
                          context.read<TransactionBloc>().add(const TransactionAction.loadMore());
                          return const Padding(
                            padding: .all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final item = state.items[index];
                        return item.map(
                          header: (h) => TransactionHeaderWidget(title: h.title),
                          transaction: (t) => TransactionItemWidget(
                            transaction: t.transaction,
                            onTap: () => context.read<TransactionBloc>().add(
                              TransactionAction.openTransactionDetail(t.transaction),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

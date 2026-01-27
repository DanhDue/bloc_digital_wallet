// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/core/widgets/custom_loading_widget.dart';
import 'package:bloc_digital_wallet/di/injection.dart';
import 'base_infinite_list_bloc.dart';
import 'base_infinite_list_event.dart';
import 'base_infinite_list_state.dart';

/// Base page for Infinite List UI pattern
/// Handles common states: Loading, Error, Empty, List, Load More, Refresh
abstract class BaseInfiniteListPage<B extends BaseInfiniteListBloc<T>, T> extends StatelessWidget {
  const BaseInfiniteListPage({super.key});

  /// Override to initialize the BLoC (e.g., fetch initial data)
  void onBlocCreated(BuildContext context, B bloc);

  /// Override to return the item widget
  Widget buildItem(BuildContext context, T item, int index);

  /// Configuration properties
  bool get enablePullToRefresh => true;
  bool get enableLoadMore => true;
  Color? get backgroundColor => null;

  /// Custom UI overrides
  Widget buildLoading(BuildContext context) {
    return Container(
      color: backgroundColor ?? context.appThemes.white,
      child: const Center(child: Column(children: [SizedBox(height: 36), CustomLoadingWidget()])),
    );
  }

  Widget buildError(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          message,
          style: context.appThemes.bodyMedium.copyWith(color: context.appThemes.errorColor),
        ),
      ),
    );
  }

  Widget buildEmpty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          'No items found',
          style: context.appThemes.bodyMedium.copyWith(
            color: context.appThemes.textSecondaryColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: (_) {
        final bloc = getIt<B>();
        onBlocCreated(context, bloc);
        return bloc;
      },
      child: Builder(
        builder: (context) {
          return BlocBuilder<B, BaseInfiniteListState<T>>(
            builder: (context, state) {
              Widget child = _buildContentBody(context, state);

              if (enablePullToRefresh) {
                child = RefreshIndicator(
                  onRefresh: () async {
                    context.read<B>().add(const InfiniteListRefresh());
                    await context.read<B>().stream.firstWhere(
                      (s) => !s.isRefreshing && s.status != InfiniteListStatus.loading,
                    );
                  },
                  child: child,
                );
              }

              return child;
            },
          );
        },
      ),
    );
  }

  Widget _buildContentBody(BuildContext context, BaseInfiniteListState<T> state) {
    // Initial loading state (only when not refreshing)
    if (state.status == InfiniteListStatus.loading && !state.isRefreshing) {
      return buildLoading(context);
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        color: backgroundColor ?? context.appThemes.white,
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error state
            if (state.status == InfiniteListStatus.failure)
              buildError(context, state.errorMessage ?? 'Error loading items'),

            // Empty state
            if (state.status == InfiniteListStatus.success && state.items.isEmpty)
              buildEmpty(context),

            // List items
            if (state.items.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  // Trigger load more
                  // Note: Logic here is a bit simplified; typically done in ScrollController listener
                  // But standard ListView builder approach works if we check index
                  if (enableLoadMore &&
                      index >= state.items.length - 1 &&
                      !state.hasReachedMax &&
                      !state.isLoadingMore) {
                    // Adding event safely
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) {
                        context.read<B>().add(const InfiniteListFetchNextPage());
                      }
                    });
                  }

                  return buildItem(context, state.items[index], index);
                },
              ),

            // Loading more indicator
            if (state.isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
          ],
        ),
      ),
    );
  }
}

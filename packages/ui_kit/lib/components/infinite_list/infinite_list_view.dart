// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/custom_loading_widget.dart';
import 'base_infinite_list_bloc.dart';
import 'base_infinite_list_event.dart';
import 'base_infinite_list_state.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, int index);

class InfiniteListView<T, B extends BaseInfiniteListBloc<T>> extends StatefulWidget {
  final ItemBuilder<T> itemBuilder;
  final Widget? emptyBuilder;
  final Widget? errorBuilder;
  final Widget? separatorBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;
  final double scrollThreshold;

  const InfiniteListView({
    super.key,
    required this.itemBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.separatorBuilder,
    this.padding,
    this.scrollController,
    this.scrollThreshold = 200.0,
  });

  @override
  State<InfiniteListView<T, B>> createState() => _InfiniteListViewState<T, B>();
}

class _InfiniteListViewState<T, B extends BaseInfiniteListBloc<T>>
    extends State<InfiniteListView<T, B>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<B>().add(const InfiniteListFetchNextPage());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - widget.scrollThreshold);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, BaseInfiniteListState<T>>(
      builder: (context, state) {
        if (state.status == InfiniteListStatus.initial ||
            (state.status == InfiniteListStatus.loading && state.items.isEmpty)) {
          return const Center(child: CustomLoadingWidget());
        }

        if (state.status == InfiniteListStatus.failure && state.items.isEmpty) {
          return widget.errorBuilder ??
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage ?? 'Something went wrong'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<B>().add(const InfiniteListFetchFirstPage()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
        }

        if (state.items.isEmpty) {
          return widget.emptyBuilder ??
              RefreshIndicator(
                onRefresh: () async {
                  context.read<B>().add(const InfiniteListRefresh());
                  // Wait for refresh to complete or just let the bloc handle it
                  // We can't await easily here without a Completer in the event, but for simple UI it's okay
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(child: Text('No items found')),
                  ),
                ),
              );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<B>().add(const InfiniteListRefresh());
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            padding: widget.padding ?? const EdgeInsets.all(16),
            itemCount: state.hasReachedMax ? state.items.length : state.items.length + 1,
            separatorBuilder: (context, index) =>
                widget.separatorBuilder ?? const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CustomLoadingWidget()),
                );
              }
              return widget.itemBuilder(context, state.items[index], index);
            },
          ),
        );
      },
    );
  }
}

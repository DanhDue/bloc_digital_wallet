// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';
import 'base_infinite_list_event.dart';
import 'base_infinite_list_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

abstract class BaseInfiniteListBloc<T>
    extends Bloc<BaseInfiniteListEvent, BaseInfiniteListState<T>> {
  static const _throttleDuration = Duration(milliseconds: 100);
  static const int _defaultPageSize = 20;

  /// Creates a [BaseInfiniteListBloc] with an optional custom [initialState].
  /// Subclasses can provide their own extended state type.
  BaseInfiniteListBloc({BaseInfiniteListState<T>? initialState})
    : super(initialState ?? BaseInfiniteListState<T>()) {
    on<InfiniteListFetchFirstPage>(_onFetchFirstPage, transformer: restartable());
    on<InfiniteListFetchNextPage>(
      _onFetchNextPage,
      transformer: throttleDroppable(_throttleDuration),
    );
    on<InfiniteListRefresh>(_onRefresh, transformer: restartable());
  }

  /// Override this method to fetch items from your repository
  Future<List<T>> fetchItems({required int page, required int limit});

  Future<void> _onFetchFirstPage(
    InfiniteListFetchFirstPage event,
    Emitter<BaseInfiniteListState<T>> emit,
  ) async {
    emit(
      state.copyWith(
        status: InfiniteListStatus.loading,
        isLoadingMore: false,
        isRefreshing: false,
        hasReachedMax: false,
        items: <T>[],
        errorMessage: null,
      ),
    );

    try {
      final items = await fetchItems(page: 0, limit: _defaultPageSize);
      emit(
        state.copyWith(
          status: InfiniteListStatus.success,
          items: items,
          hasReachedMax: items.length < _defaultPageSize,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: InfiniteListStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchNextPage(
    InfiniteListFetchNextPage event,
    Emitter<BaseInfiniteListState<T>> emit,
  ) async {
    if (state.hasReachedMax || state.isLoadingMore || state.status != InfiniteListStatus.success) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final currentLength = state.items.length;
      final nextPage = (currentLength / _defaultPageSize).floor();

      final newItems = await fetchItems(page: nextPage, limit: _defaultPageSize);

      if (newItems.isEmpty) {
        emit(state.copyWith(hasReachedMax: true, isLoadingMore: false));
      } else {
        emit(
          state.copyWith(
            items: List.of(state.items)..addAll(newItems),
            hasReachedMax: newItems.length < _defaultPageSize,
            isLoadingMore: false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          // We generally don't want to change status to failure here to keep showing the list
          // But we might want to show a snackbar or separate error state
          errorMessage: 'Failed to load more: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRefresh(
    InfiniteListRefresh event,
    Emitter<BaseInfiniteListState<T>> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));

    try {
      final items = await fetchItems(page: 0, limit: _defaultPageSize);
      emit(
        state.copyWith(
          status: InfiniteListStatus.success,
          items: items,
          hasReachedMax: items.length < _defaultPageSize,
          isRefreshing: false,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isRefreshing: false, errorMessage: e.toString()));
    }
  }
}

import 'package:equatable/equatable.dart';

enum InfiniteListStatus { initial, loading, success, failure }

class BaseInfiniteListState<T> extends Equatable {
  final InfiniteListStatus status;
  final List<T> items;
  final bool hasReachedMax;
  final String? errorMessage;
  final bool isRefreshing;
  final bool isLoadingMore;

  const BaseInfiniteListState({
    this.status = InfiniteListStatus.initial,
    this.items = const [],
    this.hasReachedMax = false,
    this.errorMessage,
    this.isRefreshing = false,
    this.isLoadingMore = false,
  });

  BaseInfiniteListState<T> copyWith({
    InfiniteListStatus? status,
    List<T>? items,
    bool? hasReachedMax,
    String? errorMessage,
    bool? isRefreshing,
    bool? isLoadingMore,
  }) {
    return BaseInfiniteListState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    hasReachedMax,
    errorMessage,
    isRefreshing,
    isLoadingMore,
  ];
}

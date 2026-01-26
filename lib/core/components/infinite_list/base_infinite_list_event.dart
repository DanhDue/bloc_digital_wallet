import 'package:equatable/equatable.dart';

sealed class BaseInfiniteListEvent extends Equatable {
  const BaseInfiniteListEvent();

  @override
  List<Object?> get props => [];
}

class InfiniteListFetchFirstPage extends BaseInfiniteListEvent {
  const InfiniteListFetchFirstPage();
}

class InfiniteListFetchNextPage extends BaseInfiniteListEvent {
  const InfiniteListFetchNextPage();
}

class InfiniteListRefresh extends BaseInfiniteListEvent {
  const InfiniteListRefresh();
}

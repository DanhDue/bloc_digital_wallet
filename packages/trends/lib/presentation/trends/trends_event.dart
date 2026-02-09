// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:ui_kit/components/infinite_list/base_infinite_list_event.dart';

/// Search event for filtering coins by keyword.
class TrendsSearch extends BaseInfiniteListEvent {
  final String keyword;

  const TrendsSearch(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

/// Search focus changed event.
class TrendsSearchFocusChanged extends BaseInfiniteListEvent {
  final bool isFocused;

  const TrendsSearchFocusChanged({required this.isFocused});

  @override
  List<Object?> get props => [isFocused];
}

/// History item tapped event.
class TrendsHistoryTap extends BaseInfiniteListEvent {
  final String keyword;

  const TrendsHistoryTap(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

/// Mic button tapped event.
class TrendsMicTap extends BaseInfiniteListEvent {
  const TrendsMicTap();

  @override
  List<Object?> get props => [];
}

/// Search submitted event for adding to history.
class TrendsSearchSubmitted extends BaseInfiniteListEvent {
  final String keyword;

  const TrendsSearchSubmitted(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

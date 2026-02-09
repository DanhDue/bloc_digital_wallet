// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:framework/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trends_action.freezed.dart';

@freezed
abstract class TrendsAction extends BaseAction with _$TrendsAction {
  const factory TrendsAction.started() = _Started;
  const factory TrendsAction.loadMore() = _LoadMore;
  const factory TrendsAction.search(String keyword) = _Search;
  const factory TrendsAction.searchFocusChanged({required bool isFocused}) = _SearchFocusChanged;
  const factory TrendsAction.historyTap(String keyword) = _HistoryTap;
  const factory TrendsAction.micTap() = _MicTap;
  const TrendsAction._() : super();
}

// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:framework/framework.dart';

part 'home_event.freezed.dart';

@freezed
class HomeEvent extends BaseEvent with _$HomeEvent {
  const HomeEvent._();
  const factory HomeEvent.navigateToDetails(String id) = _NavigateToDetails;
  const factory HomeEvent.showError(String message) = _ShowError;
}

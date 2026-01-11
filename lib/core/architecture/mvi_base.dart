// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// Base class for all Actions in MVI pattern
/// Actions represent user interactions or system triggers (INPUT: View → ViewModel)
abstract class BaseAction {
  const BaseAction();
}

/// Base class for all States in MVI pattern
/// States represent the UI state at any given time (DATA: ViewModel → View, Persistent)
abstract class BaseState {
  const BaseState();
}

/// Base class for all Events in MVI pattern
/// Events are one-time side effects (OUTPUT: ViewModel → View, Transient)
/// Examples: Navigation, Toast, Dialog
abstract class BaseEvent {
  const BaseEvent();
}

// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../../../core/architecture/architecture.dart';

/// ============================================================================
/// {{feature_name.pascalCase()}} Events
/// ============================================================================
/// Events are one-time side effects (navigation, snackbar, dialog, etc.)
/// Unlike states, events are consumed once and not persisted.
/// 
/// HOW TO EXTEND:
/// 1. Create event classes for navigation, messages, dialogs
/// 2. Each event should extend {{feature_name.pascalCase()}}Event
/// 3. Handle events in BlocListener (consumed once, not rebuilt on)
/// 
/// EXAMPLE - Adding events:
/// ```dart
/// class NavigateTo{{feature_name.pascalCase()}}DetailEvent extends {{feature_name.pascalCase()}}Event {
///   final String id;
///   const NavigateTo{{feature_name.pascalCase()}}DetailEvent(this.id);
/// }
/// 
/// class Show{{feature_name.pascalCase()}}ErrorEvent extends {{feature_name.pascalCase()}}Event {
///   final String message;
///   const Show{{feature_name.pascalCase()}}ErrorEvent(this.message);
/// }
/// ```
/// 
/// USAGE IN BLOC:
/// ```dart
/// emitEvent(NavigateTo{{feature_name.pascalCase()}}DetailEvent(id));
/// ```
/// ============================================================================

sealed class {{feature_name.pascalCase()}}Event extends BaseEvent {
  const {{feature_name.pascalCase()}}Event();
}

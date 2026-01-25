// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_digital_wallet/di/injection.dart';
import 'mvi_base.dart';
import 'mvi_bloc.dart';

/// ============================================================================
/// MviConsumer - Internal widget for MVI event/state handling
/// ============================================================================
/// Combines BlocConsumer with MVI event stream listening.
class _MviConsumer<B extends MviBloc<dynamic, S, E>, S extends BaseState, E extends BaseEvent>
    extends StatelessWidget {
  const _MviConsumer({required this.builder, required this.onEvent});

  final Widget Function(BuildContext context, S state) builder;
  final void Function(BuildContext context, E event) onEvent;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      listener: (context, state) {
        context.read<B>().events.listen((event) {
          if (!context.mounted) return;
          onEvent(context, event);
        });
      },
      builder: builder,
    );
  }
}

/// ============================================================================
/// BaseMviPage - Abstract base page for MVI pattern
/// ============================================================================
/// Child pages only need to implement MVI-specific methods:
/// - [buildAppBar] - Optional app bar (null for no app bar)
/// - [handleState] - Build UI based on state
/// - [handleEvent] - Handle one-time events (navigation, snackbar)
/// - [onBlocCreated] - Optional initial action dispatch
///
/// Usage:
/// ```dart
/// @RoutePage()
/// class StartPage extends BaseMviPage<StartBloc, StartState, StartEvent> {
///   const StartPage({super.key});
///
///   @override
///   PreferredSizeWidget? buildAppBar(BuildContext context) =>
///       AppBar(title: const Text('Start'));
///
///   @override
///   Widget handleState(BuildContext context, StartState state) {
///     return switch (state) {
///       StartInitial() => const Center(child: Text('Initial')),
///       StartLoading() => const CircularProgressIndicator(),
///     };
///   }
///
///   @override
///   void handleEvent(BuildContext context, StartEvent event) {
///     switch (event) {
///       case ShowMessage(:final message):
///         ScaffoldMessenger.of(context).showSnackBar(...);
///     }
///   }
/// }
/// ```
abstract class BaseMviPage<
  B extends MviBloc<dynamic, S, E>,
  S extends BaseState,
  E extends BaseEvent
>
    extends StatelessWidget {
  const BaseMviPage({super.key});

  /// Override to dispatch initial action when BLoC is created.
  /// Returns null by default (no initial action).
  void Function(B bloc)? get onBlocCreated => null;

  /// Override to return an initial action to dispatch when the BLoC is created.
  BaseAction? get initialAction => null;

  /// Override to provide an app bar. Return null for no app bar.
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  /// Build the UI based on the current state.
  /// This is the main method to implement for rendering UI.
  Widget handleState(BuildContext context, S state);

  /// Handle one-time events (navigation, snackbar, dialog).
  /// Override this to handle events from the BLoC.
  void handleEvent(BuildContext context, E event) {}

  /// Optional: Override to customize the Scaffold body wrapper.
  Widget buildBody(BuildContext context) {
    return _MviConsumer<B, S, E>(onEvent: handleEvent, builder: handleState);
  }

  /// Optional: Override for additional Scaffold properties (FAB, drawer, etc.)
  Widget buildScaffold(BuildContext context) {
    return Scaffold(appBar: buildAppBar(context), body: buildBody(context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: (_) {
        final bloc = getIt<B>();
        onBlocCreated?.call(bloc);
        final action = initialAction;
        if (action != null) {
          bloc.onAction(action);
        }
        return bloc;
      },
      child: Builder(builder: (context) => buildScaffold(context)),
    );
  }
}

// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mvi_base.dart';
import 'mvi_bloc.dart';

/// ============================================================================
/// _MviStatefulConsumer - Internal widget for MVI event/state handling in Stateful Pages
/// ============================================================================
/// ============================================================================
/// _MviStatefulConsumer - Internal widget for MVI state handling in Stateful Pages
/// ============================================================================
class _MviStatefulConsumer<
  B extends MviBloc<dynamic, S, E>,
  S extends BaseState,
  E extends BaseEvent
>
    extends StatelessWidget {
  const _MviStatefulConsumer({required this.builder});

  final Widget Function(BuildContext context, S state) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(builder: builder);
  }
}

/// ============================================================================
/// BaseMviStatefulPage - Abstract base page for MVI pattern with Stateful lifecycle
/// ============================================================================
/// Use this when you need lifecycle methods (initState, dispose, etc.)
///
/// Child pages only need to implement MVI-specific methods:
/// - [state] - Logic state class
/// - [handleState] - Build UI based on state
/// - [handleEvent] - Handle one-time events (navigation, snackbar)
/// - [onBlocCreated] - Optional initial action dispatch
///
/// Usage:
/// ```dart
/// @RoutePage()
/// class DetailPage extends BaseMviStatefulPage<DetailBloc, DetailState, DetailEvent> {
///   const DetailPage({super.key});
///
///   @override
///   BaseMviPageState<DetailBloc, DetailState, DetailEvent, DetailPage> createState() =>
///       _DetailPageState();
/// }
///
/// class _DetailPageState extends BaseMviPageState<DetailBloc, DetailState, DetailEvent, DetailPage> {
///   @override
///   void initState() {
///     super.initState();
///     // Custom init logic
///   }
///
///   @override
///   PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(title: Text('Detail'));
///
///   @override
///   Widget handleState(BuildContext context, DetailState state) {
///     return switch (state) {
///       DetailInitial() => const SizedBox(),
///       DetailLoaded(:final data) => Text(data),
///     };
///   }
///
///   @override
///   void handleEvent(BuildContext context, DetailEvent event) {
///    // Handle events
///   }
/// }
/// ```
abstract class BaseMviStatefulPage<
  B extends MviBloc<dynamic, S, E>,
  S extends BaseState,
  E extends BaseEvent
>
    extends StatefulWidget {
  const BaseMviStatefulPage({super.key});

  @override
  BaseMviPageState<B, S, E, BaseMviStatefulPage<B, S, E>> createState();
}

abstract class BaseMviPageState<
  B extends MviBloc<dynamic, S, E>,
  S extends BaseState,
  E extends BaseEvent,
  W extends BaseMviStatefulPage<B, S, E>
>
    extends State<W> {
  late final B bloc;
  StreamSubscription<E>? _eventSubscription;

  /// Override to dispatch initial action when BLoC is created.
  /// Returns null by default (no initial action).
  void Function(B bloc)? get onBlocCreated => null;

  @override
  void initState() {
    super.initState();
    bloc = GetIt.instance<B>();
    _subscribeToEvents();
    onBlocCreated?.call(bloc);
  }

  void _subscribeToEvents() {
    _eventSubscription = bloc.events.listen((event) {
      if (!mounted) return;
      handleEvent(context, event);
    });
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

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
    return _MviStatefulConsumer<B, S, E>(builder: handleState);
  }

  /// Optional: Override for additional Scaffold properties (FAB, drawer, etc.)
  Widget buildScaffold(BuildContext context) {
    return Scaffold(appBar: buildAppBar(context), body: buildBody(context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>.value(
      value: bloc,
      child: Builder(builder: (context) => buildScaffold(context)),
    );
  }
}

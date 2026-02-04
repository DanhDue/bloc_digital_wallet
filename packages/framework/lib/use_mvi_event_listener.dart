// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mvi_base.dart';
import 'mvi_bloc.dart';

/// Custom hook for listening to MVI Bloc events.
///
/// Automatically subscribes to the bloc's event stream and calls [onEvent]
/// whenever an event is emitted. The subscription is properly cleaned up
/// when the widget is disposed or the bloc changes.
///
/// **Type Parameters:**
/// - [B]: The bloc type (must extend [MviBloc])
/// - [E]: The event type (must extend [BaseEvent])
///
/// **Parameters:**
/// - [onEvent]: Callback function invoked when an event is emitted
///
/// **Example:**
/// ```dart
/// class MyPage extends HookWidget {
///   @override
///   Widget build(BuildContext context) {
///     // Hook for handling one-time events - side effects (navigation, snackbar, dialogs)
///     useMviEventListener<MyBloc, MyEvent>((context, event) {
///       if (event is NavigateToHome) {
///         context.router.push(const HomeRoute());
///       } else if (event is ShowError) {
///         ScaffoldMessenger.of(context).showSnackBar(
///           SnackBar(content: Text(event.message)),
///         );
///       }
///     });
///
///     // BlocBuilder for state-driven UI updates
///     return BlocBuilder<MyBloc, MyState>(
///       builder: (context, state) {
///         return Scaffold(
///           appBar: AppBar(title: const Text('My Page')),
///           body: switch (state) {
///             MyInitial() => const Center(child: Text('Initial State')),
///             MyLoading() => const Center(child: CircularProgressIndicator()),
///             MySuccess(:final data) => ListView(children: [Text(data)]),
///             MyError(:final message) => Center(child: Text('Error: $message')),
///           },
///         );
///       },
///     );
///   }
/// }
/// ```
void useMviEventListener<B extends MviBloc<dynamic, dynamic, E>, E extends BaseEvent>(
  void Function(BuildContext context, E event) onEvent,
) {
  final context = useContext();
  final bloc = context.read<B>();

  useEffect(() {
    final subscription = bloc.events.listen((event) {
      if (!context.mounted) return;
      onEvent(context, event);
    });
    return subscription.cancel;
  }, [bloc]);
}

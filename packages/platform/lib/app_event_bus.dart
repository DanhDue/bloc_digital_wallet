// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:stream_transform/stream_transform.dart';

/// Base class for all cross-feature events published on the [AppEventBus].
///
/// Mini App packages define their own [AppEvent] subclasses in their own
/// barrel files — this package only defines the bus itself, not concrete
/// event types. A subscriber importing another feature's event *type* is
/// acceptable: event classes are data contracts, the same posture as
/// importing a domain entity.
abstract class AppEvent {
  const AppEvent();
}

/// App-wide, typed, broadcast-stream event bus.
///
/// Lets Mini App packages publish and subscribe to cross-feature signals
/// without importing each other directly. Backed by a broadcast
/// [StreamController]: publishing before any subscriber is attached is
/// safe (the event is simply dropped), and every subscriber currently
/// listening receives every published event independently.
@lazySingleton
class AppEventBus {
  final _controller = StreamController<AppEvent>.broadcast();

  /// Publishes [event] to every current subscriber of its runtime type.
  void publish(AppEvent event) => _controller.add(event);

  /// A stream of events of type [T], filtering out all other event types.
  Stream<T> on<T extends AppEvent>() => _controller.stream.whereType<T>();
}

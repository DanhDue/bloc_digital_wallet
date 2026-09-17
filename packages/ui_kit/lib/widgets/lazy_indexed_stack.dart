// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';

/// A performance-optimized [IndexedStack] that lazily instantiates its children.
///
/// Only the child at [index] is built when initially mounted. Other children
/// are deferred as [SizedBox.shrink] until their index is activated.
/// Once a child has been activated, its state is preserved across subsequent
/// tab switches just like a standard [IndexedStack].
class LazyIndexedStack extends StatefulWidget {
  const LazyIndexedStack({
    super.key,
    required this.index,
    this.itemCount,
    this.itemBuilder,
    this.children,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
  }) : assert(
         (itemBuilder != null && itemCount != null) || children != null,
         'Either provide both itemCount and itemBuilder, or provide children.',
       );

  /// Creates a [LazyIndexedStack] that builds children lazily on demand.
  const LazyIndexedStack.builder({
    super.key,
    required this.index,
    required int this.itemCount,
    required NullableIndexedWidgetBuilder this.itemBuilder,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
  }) : children = null;

  /// The index of the active child to display.
  final int index;

  /// The number of children in the stack when using [itemBuilder].
  final int? itemCount;

  /// Called to build each child widget only after its index has been activated.
  final NullableIndexedWidgetBuilder? itemBuilder;

  /// The static list of child widgets (for backwards compatibility).
  final List<Widget>? children;

  /// How to align the non-positioned and partially-positioned children in the stack.
  final AlignmentGeometry alignment;

  /// The text direction with which to resolve [alignment].
  final TextDirection? textDirection;

  /// How to size the non-positioned children in the stack.
  final StackFit sizing;

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  final Set<int> _activatedIndices = <int>{};

  int get _count => widget.itemCount ?? widget.children?.length ?? 0;

  @override
  void initState() {
    super.initState();
    _activateIndex(widget.index);
  }

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _activateIndex(widget.index);
    }
  }

  void _activateIndex(int index) {
    if (_count <= 0) return;
    final clampedIndex = index.clamp(0, _count - 1);
    _activatedIndices.add(clampedIndex);
  }

  Widget _buildChild(BuildContext context, int i) {
    if (!_activatedIndices.contains(i)) {
      return const SizedBox.shrink();
    }
    final builder = widget.itemBuilder;
    if (builder != null) {
      return builder(context, i) ?? const SizedBox.shrink();
    }
    final children = widget.children;
    if (children != null && i < children.length) {
      return children[i];
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final count = _count;
    if (count <= 0) {
      return _buildEmptyStack();
    }

    final clampedIndex = widget.index.clamp(0, count - 1);

    return IndexedStack(
      index: clampedIndex,
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      children: [for (int i = 0; i < count; i++) _buildChild(context, i)],
    );
  }

  Widget _buildEmptyStack() {
    return IndexedStack(
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      index: 0,
      children: const <Widget>[],
    );
  }
}

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
    required this.children,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
  });

  /// The index of the active child to display.
  final int index;

  /// The list of child widgets.
  final List<Widget> children;

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
    if (widget.children.isEmpty) return;
    final clampedIndex = index.clamp(0, widget.children.length - 1);
    _activatedIndices.add(clampedIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return IndexedStack(
        alignment: widget.alignment,
        textDirection: widget.textDirection,
        sizing: widget.sizing,
        index: 0,
        children: const <Widget>[],
      );
    }

    final clampedIndex = widget.index.clamp(0, widget.children.length - 1);

    return IndexedStack(
      index: clampedIndex,
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      children: [
        for (int i = 0; i < widget.children.length; i++)
          _activatedIndices.contains(i) ? widget.children[i] : const SizedBox.shrink(),
      ],
    );
  }
}

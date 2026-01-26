// Copyright (c) 2025, one of the DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';

class KeepAliveWidget extends StatefulWidget {
  const KeepAliveWidget({
    super.key,
    this.child,
    this.safeAreaLeft = false,
    this.safeAreaTop = false,
    this.safeAreaRight = false,
    this.safeAreaBottom = false,
  });

  final Widget? child;
  final bool? safeAreaLeft;
  final bool? safeAreaTop;
  final bool? safeAreaRight;
  final bool? safeAreaBottom;

  @override
  State<KeepAliveWidget> createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      left: widget.safeAreaLeft ?? false,
      top: widget.safeAreaTop ?? false,
      right: widget.safeAreaRight ?? false,
      bottom: widget.safeAreaBottom ?? false,
      child: widget.child ?? Container(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

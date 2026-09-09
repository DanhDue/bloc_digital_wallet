// Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class PrettyAnimatedQrView extends StatefulWidget {
  @protected
  final QrImage qrImage;

  @protected
  final PrettyQrDecoration decoration;

  const PrettyAnimatedQrView({super.key, required this.qrImage, required this.decoration});

  @override
  State<PrettyAnimatedQrView> createState() => PrettyAnimatedQrViewState();
}

class PrettyAnimatedQrViewState extends State<PrettyAnimatedQrView> {
  @protected
  late PrettyQrDecoration previosDecoration;

  @override
  void initState() {
    super.initState();
    previosDecoration = widget.decoration;
  }

  @override
  void didUpdateWidget(covariant PrettyAnimatedQrView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.decoration != oldWidget.decoration) {
      previosDecoration = oldWidget.decoration;
    }
  }

  Future<Uint8List?> exportImageBytes({
    int size = 1024,
    ui.ImageByteFormat format = ui.ImageByteFormat.png,
  }) async {
    final rawData = await widget.qrImage.toImageAsBytes(
      size: size,
      decoration: widget.decoration,
      format: format,
    );
    if (rawData == null) return null;
    return rawData.buffer.asUint8List(rawData.offsetInBytes, rawData.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<PrettyQrDecoration>(
      tween: PrettyQrDecorationTween(begin: previosDecoration, end: widget.decoration),
      curve: Curves.ease,
      duration: const Duration(milliseconds: 240),
      builder: (context, decoration, child) {
        return PrettyQrView(qrImage: widget.qrImage, decoration: decoration);
      },
    );
  }
}

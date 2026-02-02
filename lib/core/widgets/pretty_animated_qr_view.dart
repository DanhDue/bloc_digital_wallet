// Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/config/constants.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
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

  void exportImage(String fileName) async {
    final fileNameWithCreatedTime = "${fileName}_${DateTime.now().millisecond}";
    final rawData = await widget.qrImage.toImageAsBytes(size: 1024, decoration: widget.decoration);
    if (rawData != null) {
      final data = rawData.buffer.asUint8List(rawData.offsetInBytes, rawData.lengthInBytes);
      final result = await ImageGallerySaverPlus.saveImage(
        data,
        quality: 100,
        name: fileNameWithCreatedTime,
      );
      if (result["isSuccess"] == true) {
        SmartDialog.showToast(t.qrCodeIsSaveToGallery, displayTime: ToastDuration.lengthLong);
      }
    }
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

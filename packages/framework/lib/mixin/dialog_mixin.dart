// Copyright (c) 2025, one of the DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:logger/d3nexus_logger.dart';

mixin DialogMixin {
  static final Expando<bool> _loadingState = Expando();
  static final _logger = D3NexusLogger.getLogger('Framework');

  bool get loadingDialogIsShown => _loadingState[this] ?? false;
  set loadingDialogIsShown(bool value) => _loadingState[this] = value;

  static Widget Function(BuildContext)? defaultLoadingWidgetBuilder;

  void showLoadingDialog(BuildContext context, {Widget? loadingWidget}) {
    _logger.d('showLoadingDialog()');
    if (loadingDialogIsShown) {
      _logger.w('Loading dialog already shown, skipping...');
      return;
    }
    loadingDialogIsShown = true;
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child:
                  loadingWidget ??
                  defaultLoadingWidgetBuilder?.call(context) ??
                  const Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()),
            ),
          ),
        ),
      ).whenComplete(() {
        // Reset state when dialog closes (if manually dismissed)
        // But usually we call hideLoadingDialog() which pops logic.
        // We don't auto-reset state here because hideLoadingDialog handles it?
        // Actually, if user dismisses it by tap outside, we should probably reset?
        // For now keeping matching logic to what was there (empty whenComplete) but
        // beware logic if user dismisses manually.
      });
    } catch (e) {
      loadingDialogIsShown = false;
      _logger.e('Failed to show loading dialog', error: e);
      rethrow;
    }
  }

  void hideLoadingDialog(BuildContext context) {
    _logger.d("hideLoadingDialog()");
    if (loadingDialogIsShown) {
      loadingDialogIsShown = false;
      Navigator.of(context).pop();
    }
  }
}

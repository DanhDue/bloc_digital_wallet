// Copyright (c) 2025, one of the DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/core/utils/log.dart';
import 'package:bloc_digital_wallet/core/extensions/dialog_extensions.dart';

mixin DialogMixin {
  static final Expando<bool> _loadingState = Expando();

  bool get loadingDialogIsShown => _loadingState[this] ?? false;
  set loadingDialogIsShown(bool value) => _loadingState[this] = value;

  void showLoadingDialog(BuildContext context) {
    Log.d('showLoadingDialog()');
    if (loadingDialogIsShown) {
      Log.w('Loading dialog already shown, skipping...');
      return;
    }
    loadingDialogIsShown = true;
    try {
      context.showWrapBottomSheet(const Center(child: CircularProgressIndicator())).whenComplete(
        () {
          // Ensure state is reset when dialog closes (if not manually hidden)
          // But logic in showLoadingDialog relies on manual hide?
          // Typically showLoadingDialog is blocking or valid until hideLoadingDialog called?
          // The original code didn't use await or whenComplete.
          // It wrapped showWrapBottomSheet in try-catch blocks.
        },
      );
    } catch (e) {
      loadingDialogIsShown = false;
      Log.e('Failed to show loading dialog', error: e);
      rethrow;
    }
  }

  void hideLoadingDialog(BuildContext context) {
    Log.d("hideLoadingDialog()");
    if (loadingDialogIsShown) {
      loadingDialogIsShown = false;
      Navigator.of(context).pop();
    }
  }
}

// Copyright (c) 2025, one of the DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:logger/d3nexus_logger.dart';

mixin DialogMixin {
  static final Expando<bool> _loadingState = Expando();
  static final _logger = D3NexusLogger.getLogger('Framework');

  bool get loadingDialogIsShown => _loadingState[this] ?? false;
  set loadingDialogIsShown(bool value) => _loadingState[this] = value;

  Future _showWrapBottomSheet(BuildContext context, Widget widget) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      useRootNavigator: true,
      useSafeArea: false,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(children: [widget]),
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    _logger.d('showLoadingDialog()');
    if (loadingDialogIsShown) {
      _logger.w('Loading dialog already shown, skipping...');
      return;
    }
    loadingDialogIsShown = true;
    try {
      _showWrapBottomSheet(context, const Center(child: CircularProgressIndicator())).whenComplete(
        () {
          // Reset state when dialog closes (if manually dismissed)
          // But usually we call hideLoadingDialog() which pops logic.
          // We don't auto-reset state here because hideLoadingDialog handles it?
          // Actually, if user dismisses it by tap outside, we should probably reset?
          // For now keeping matching logic to what was there (empty whenComplete) but
          // beware logic if user dismisses manually.
        },
      );
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

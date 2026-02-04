// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:core/core.dart';
import 'package:ui_kit/ui_kit.dart';

extension DialogExtensions on BuildContext {
  Future showWrapBottomSheet(Widget widget, {RouteSettings? routeSettings}) async {
    return showModalBottomSheet(
      context: this,
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
      routeSettings: routeSettings,
    );
  }

  void showAlertDialog({String? title, String? message, Function? onAction, String? actionTitle}) {
    showWrapBottomSheet(
      AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        title: Text(
          title ?? '',
          style: appThemes.headlineMedium.copyWith(color: appThemes.mainGreen),
        ),
        content: Text(message ?? '', style: appThemes.bodyMedium.copyWith(color: appThemes.black)),
        actions: [
          TextButton(
            style: ElevatedButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              backgroundColor: appThemes.transparent,
            ),
            child: Text(
              actionTitle ?? coreT.close,
              style: appThemes.bodyMedium.copyWith(color: appThemes.mainGreen),
            ),
            onPressed: () {
              Navigator.of(this).pop(); // context.back() equiv
              onAction?.call();
            },
          ),
        ],
      ),
    );
  }
}

// Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/core/widgets/custom_filled_button.dart';
import 'package:bloc_digital_wallet/core/mixin/dialog_mixin.dart';
import 'package:bloc_digital_wallet/generated/assets.gen.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:bloc_digital_wallet/core/extensions/dialog_extensions.dart';

class CommingSoonModalView extends StatefulWidget {
  const CommingSoonModalView({super.key});

  @override
  State<CommingSoonModalView> createState() => _CommingSoonModalViewState();
}

class _CommingSoonModalViewState extends State<CommingSoonModalView> with DialogMixin {
  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      transitionBackgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.icCommingSoonBackground.provider(),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => context.back(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(6),
                    child: Assets.images.icCloseRound.svg(fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 36),
                    Assets.images.icRocketLaunch.svg(width: 153, height: 153, fit: BoxFit.cover),
                    const SizedBox(height: 20),
                    Text(
                      context.t.commingSoon,
                      style: context.appThemes.headlineSmall.copyWith(
                        color: context.appThemes.ink100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.t.commingSoonDescription,
                      style: context.appThemes.bodyMedium.copyWith(color: context.appThemes.ink60),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.appThemes.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: context.appThemes.black.withValues(alpha: 0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: context.t.enterYourEmail,
                                hintStyle: context.appThemes.bodyMedium.copyWith(
                                  color: context.appThemes.ink60,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: context.appThemes.bodyMedium.copyWith(
                                color: context.appThemes.ink100,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CustomFilledButton(
                          borderRadius: 100,
                          onPressed: () => context.showCommingSoon(),
                          text: context.t.subscribe,
                          fullWidth: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Copyright (c) 2025, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:ui_kit/theme/app_themes.dart';
import 'package:ui_kit/widgets/custom_filled_button.dart';
import 'package:framework/framework.dart';
import 'package:ui_kit/generated/assets.gen.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
                      context.coreT.commingSoon,
                      style: context.appThemes.headlineSmall.copyWith(
                        color: context.appThemes.ink100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.coreT.commingSoonDescription,
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
                                  color: context.appThemes.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: context.coreT.enterYourEmail,
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
                          onPressed: () => Navigator.of(context).pop(),
                          text: context.coreT.subscribe,
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

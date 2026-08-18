// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:settings/generated/colors.gen.dart';
import 'package:settings/generated/translations.dart';
import 'package:ui_kit/ui_kit.dart' hide AppColors;
import 'package:core/core.dart';

import 'package:settings/presentation/settings/settings_action.dart';
import 'package:settings/presentation/settings/settings_bloc.dart';
import 'package:settings/presentation/settings/settings_event.dart';
import 'package:settings/presentation/settings/settings_state.dart';
import 'package:settings/presentation/settings/widgets/settings_item_widget.dart';
import 'package:settings/presentation/settings/widgets/settings_section_widget.dart';

@RoutePage()
class SettingsPage
    extends BaseMviPage<SettingsBloc, SettingsAction, SettingsState, SettingsEvent> {
  const SettingsPage({super.key});

  @override
  SettingsAction? get initialAction => const SettingsAction.started();

  @override
  Widget handleState(BuildContext context, SettingsState state) {
    final theme = Theme.of(context);
    final appThemes = theme.extension<AppThemes>();
    final t = context.tSettings.settings;

    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        backgroundColor: AppColors.settingsBg,
        body: _buildBody(context, state, appThemes, t),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SettingsState state,
    AppThemes? appThemes,
    SettingsTranslationsSettingsEn t,
  ) {
    if (state.status == SettingsStatus.loading) {
      return const Center(child: CustomLoadingWidget());
    }

    if (state.status == SettingsStatus.failure) {
      return Center(
        child: Text(
          state.errorMessage ?? t.errorOccurred,
          style: appThemes?.bodyLarge.copyWith(color: appThemes.errorColor),
        ),
      );
    }

    final uiModel = state.uiModel;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Section
          SettingsSectionWidget(
            title: t.account.title,
            children: [
              SettingsItemWidget(
                icon: Icons.person_outline,
                label: t.account.profile, // "Edit Profile"
                iconColor: AppColors.settingsItemBlue,
                iconBackgroundColor: AppColors.settingsItemBlueBg,
                onTap: () => context.read<SettingsBloc>().onAction(
                  const SettingsAction.navigateToProfile(),
                ),
              ),
              SettingsItemWidget(
                icon: Icons.lock_outline,
                label: t.account.changePassword,
                iconColor: AppColors.settingsItemPurple,
                iconBackgroundColor: AppColors.settingsItemPurpleBg,
                onTap: () => context.read<SettingsBloc>().onAction(
                  const SettingsAction.navigateToSecurity(), // Reusing security action for now
                ),
              ),
              SettingsItemWidget(
                icon: Icons.shield_outlined,
                label: t.account.twoFactorAuth,
                showDivider: false,
                iconColor: AppColors.settingsItemDeepPurple,
                iconBackgroundColor: AppColors.settingsItemDeepPurpleBg,
                trailing: SettingsItemTrailing.value,
                value: t.account.twoFactorAuthOn, // "On"
                valueColor: AppColors.settingsItemGreen,
                onTap: () {
                  // Navigate to 2FA settings
                },
              ),
            ],
          ),

          // Preferences Section
          SettingsSectionWidget(
            title: t.preferences.title,
            children: [
              SettingsItemWidget(
                icon: Icons.attach_money,
                label: t.preferences.currency, // "Currency / Units"
                trailing: SettingsItemTrailing.value,
                value: t.preferences.currencyUsd,
                iconColor: AppColors.settingsItemOrange,
                iconBackgroundColor: AppColors.settingsItemOrangeBg,
                onTap: () => _showCurrencyPicker(context),
              ),
              SettingsItemWidget(
                icon: Icons.language,
                label: t.preferences.language,
                trailing: SettingsItemTrailing.value,
                value: LocalizationManager.instance.currentLocale.languageCode == 'vi'
                    ? 'Tiếng Việt'
                    : 'English',
                iconColor: AppColors.settingsItemBlue,
                iconBackgroundColor: AppColors.settingsItemBlueBg,
                onTap: () => _showLanguagePicker(context, t),
              ),
              SettingsItemWidget(
                icon: Icons.dark_mode_outlined,
                label: t.preferences.darkMode,
                trailing: SettingsItemTrailing.toggle,
                isOn: uiModel?.isDarkModeEnabled ?? false,
                showDivider: false,
                iconColor: AppColors.settingsItemGrey,
                iconBackgroundColor: AppColors.settingsItemGreyBg,
                onToggle: (value) => context.read<SettingsBloc>().onAction(
                  SettingsAction.toggleDarkMode(isEnabled: value),
                ),
              ),
            ],
          ),

          // Developer Section
          SettingsSectionWidget(
            title: t.developer.title,
            children: [
              SettingsItemWidget(
                icon: Icons.bug_report_outlined,
                label: t.developer.debugMode,
                trailing: SettingsItemTrailing.toggle,
                isOn: uiModel?.isDeveloperModeEnabled ?? false,
                showDivider: false,
                iconColor: AppColors.settingsItemGreen,
                iconBackgroundColor: AppColors.settingsItemGreenBg,
                onToggle: (value) => context.read<SettingsBloc>().onAction(
                  SettingsAction.toggleDeveloperMode(isEnabled: value),
                ),
              ),
            ],
          ),

          // App Info Section
          SettingsSectionWidget(
            title: t.appInfo.title,
            children: [
              SettingsItemWidget(
                icon: Icons.headset_mic_outlined,
                label: t.appInfo.contactSupport,
                trailing: SettingsItemTrailing.arrow, // Explicitly arrow as per requirement
                iconColor: AppColors.settingsItemBlue,
                iconBackgroundColor: AppColors.settingsItemBlueBg,
                onTap: () {
                  // Contact support action
                },
              ),
              SettingsItemWidget(
                icon: Icons.info_outline,
                label: t.appInfo.aboutApp,
                trailing: SettingsItemTrailing.valueOnly,
                showDivider: false,
                value:
                    uiModel?.appVersion ?? t.appInfo.defaultVersion, // Fallback to example version
                iconColor: AppColors.settingsItemLightGrey,
                iconBackgroundColor: AppColors.settingsItemLightGreyBg,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement logout action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.settingsCardBg,
                  foregroundColor: AppColors.settingsLogoutText,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  shadowColor: AppColors.settingsCardShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: AppColors.settingsLogoutText),
                    const SizedBox(width: 8),
                    Text(
                      t.logout,
                      style: appThemes?.bodyLarge.copyWith(
                        color: AppColors.settingsLogoutText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    // TODO: Implement currency picker dialog
  }

  void _showLanguagePicker(BuildContext context, SettingsTranslationsSettingsEn t) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        final currentLang = LocalizationManager.instance.currentLocale.languageCode;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  t.preferences.language,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: const Text('English'),
                trailing: currentLang == 'en'
                    ? const Icon(Icons.check, color: AppColors.settingsItemBlue)
                    : null,
                onTap: () {
                  context.read<SettingsBloc>().onAction(
                    const SettingsAction.changeLanguage(languageCode: 'en'),
                  );
                  Navigator.pop(bottomSheetContext);
                },
              ),
              ListTile(
                title: const Text('Tiếng Việt'),
                trailing: currentLang == 'vi'
                    ? const Icon(Icons.check, color: AppColors.settingsItemBlue)
                    : null,
                onTap: () {
                  context.read<SettingsBloc>().onAction(
                    const SettingsAction.changeLanguage(languageCode: 'vi'),
                  );
                  Navigator.pop(bottomSheetContext);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  void handleEvent(BuildContext context, SettingsEvent event) {
    switch (event) {
      case SettingsEventInitial():
        break;
      case SettingsEventNavigateToProfile():
        // TODO: Navigate to profile page
        break;
      case SettingsEventNavigateToSecurity():
        // TODO: Navigate to security page
        break;
      case SettingsEventShowError(:final message):
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}

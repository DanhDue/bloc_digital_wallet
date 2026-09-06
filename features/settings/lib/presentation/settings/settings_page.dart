// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framework/framework.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:settings/generated/colors.gen.dart';
import 'package:settings/generated/translations.dart';
import 'package:ui_kit/ui_kit.dart' hide AppColors;
import 'package:core/core.dart';

import 'package:settings/data/datasources/local/settings_local_datasource.dart';
import 'package:settings/presentation/settings/models/settings_ui_model.dart';
import 'package:settings/presentation/settings/settings_action.dart';
import 'package:settings/presentation/settings/settings_bloc.dart';
import 'package:settings/presentation/settings/settings_event.dart';
import 'package:settings/presentation/settings/settings_state.dart';
import 'package:settings/presentation/settings/talker_console_settings.dart';
import 'package:settings/presentation/settings/widgets/settings_item_widget.dart';
import 'package:settings/presentation/settings/widgets/settings_section_widget.dart';
import 'package:settings/data/models/sync/available_language.dart';
import 'package:collection/collection.dart';

@RoutePage()
class SettingsPage extends BaseMviPage<SettingsBloc, SettingsAction, SettingsState, SettingsEvent>
    with DialogMixin {
  const SettingsPage({super.key});

  @override
  SettingsAction? get initialAction => const SettingsAction.started();

  @override
  Widget buildBody(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == SettingsStatus.loading) {
          showLoadingDialog(context, loadingWidget: const CustomLoadingWidget());
        } else {
          hideLoadingDialog(context);
        }
      },
      child: super.buildBody(context),
    );
  }

  @override
  Widget handleState(BuildContext context, SettingsState state) {
    final theme = Theme.of(context);
    final appThemes = theme.extension<AppThemes>();
    final t = context.tSettings.settings;

    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        backgroundColor: appThemes?.backgroundColor ?? theme.scaffoldBackgroundColor,
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
    if (state.status == SettingsStatus.failure) {
      return Center(
        child: Text(
          state.errorMessage ?? t.errorOccurred,
          style: appThemes?.bodyLarge.copyWith(color: appThemes.errorColor),
        ),
      );
    }

    final uiModel = state.uiModel;
    final theme = Theme.of(context);

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
                onTap: () => context.read<SettingsBloc>().onAction(
                  const SettingsAction.navigateToProfile(),
                ),
              ),
              SettingsItemWidget(
                icon: Icons.lock_outline,
                label: t.account.changePassword,
                iconColor: AppColors.settingsItemPurple,
                onTap: () => context.read<SettingsBloc>().onAction(
                  const SettingsAction.navigateToSecurity(), // Reusing security action for now
                ),
              ),
              SettingsItemWidget(
                icon: Icons.shield_outlined,
                label: t.account.twoFactorAuth,
                showDivider: false,
                iconColor: AppColors.settingsItemDeepPurple,
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
                onTap: () => _showCurrencyPicker(context),
              ),
              SettingsItemWidget(
                icon: Icons.language,
                label: t.preferences.language,
                trailing: SettingsItemTrailing.value,
                value: (() {
                  final langName =
                      uiModel?.availableLanguages
                          .where(
                            (l) =>
                                LocalizationManager.instance.resolveLocale(l.languageCode) ==
                                LocalizationManager.instance.currentLocale,
                          )
                          .firstOrNull
                          ?.languageName ??
                      (LocalizationManager.instance.currentLocale.languageCode == 'vi'
                          ? 'Tiếng Việt'
                          : 'English');
                  return langName;
                })(),
                iconColor: AppColors.settingsItemBlue,
                onTap: () => _showLanguagePicker(context, t, uiModel?.availableLanguages ?? []),
              ),
              SettingsItemWidget(
                icon: Icons.dark_mode_outlined,
                label: t.preferences.darkMode,
                trailing: SettingsItemTrailing.toggle,
                isOn: uiModel?.isDarkModeEnabled ?? false,
                showDivider: false,
                iconColor: AppColors.settingsItemGrey,
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
                onToggle: (value) => context.read<SettingsBloc>().onAction(
                  SettingsAction.toggleDeveloperMode(isEnabled: value),
                ),
                onTap: () => _openTalkerConsole(context, uiModel, t),
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
                  backgroundColor: appThemes?.surfaceColor ?? theme.cardColor,
                  foregroundColor: appThemes?.errorColor ?? AppColors.settingsLogoutText,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  shadowColor: appThemes?.shadowColor ?? theme.shadowColor.withValues(alpha: 0.05),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: appThemes?.errorColor ?? AppColors.settingsLogoutText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      t.logout,
                      style: appThemes?.bodyLarge.copyWith(
                        color: appThemes.errorColor,
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

  /// Opens Talker's console screen, with the "Module Logging" and
  /// "Telemetry" toggle sections wired into its ⚙️ settings panel
  /// (`customSettings`) instead of living on this page — see
  /// [buildLoggingCustomSettings].
  Future<void> _openTalkerConsole(
    BuildContext context,
    SettingsUiModel? uiModel,
    SettingsTranslationsSettingsEn t,
  ) async {
    if (uiModel?.isDeveloperModeEnabled != true) return;

    final dataSource = GetIt.I<SettingsLocalDataSource>();
    final moduleToggles = await dataSource.getModuleToggles();
    final appenderToggles = await dataSource.getAppenderToggles();
    if (!context.mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TalkerScreen(
          talker: GetIt.I<Talker>(),
          customSettings: buildLoggingCustomSettings(
            moduleToggles: moduleToggles,
            appenderToggles: appenderToggles,
            appenderLabels: {
              'talker': t.telemetry.appenders.talker,
              'datadog': t.telemetry.appenders.datadog,
              'otel': t.telemetry.appenders.otel,
            },
            moduleLoggingTitle: t.developer.moduleLogging.title,
            telemetryTitle: t.telemetry.title,
            onModuleToggle: (module, isEnabled) async {
              D3NexusLogger.setModuleEnabled(module, isEnabled);
              final current = await dataSource.getModuleToggles();
              await dataSource.saveModuleToggles({...current, module: isEnabled});
            },
            onAppenderToggle: (appenderId, isEnabled) async {
              D3NexusLogger.setAppenderEnabled(appenderId, isEnabled);
              final current = await dataSource.getAppenderToggles();
              await dataSource.saveAppenderToggles({...current, appenderId: isEnabled});
            },
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    SettingsTranslationsSettingsEn t,
    List<AvailableLanguage> availableLanguages,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        final currentLocale = LocalizationManager.instance.currentLocale;

        // Use fallback if the list is empty
        final languagesToDisplay = availableLanguages.isNotEmpty
            ? availableLanguages
            : [
                AvailableLanguage(
                  languageCode: 'en',
                  languageName: 'English',
                  isDefault: true,
                  isActive: true,
                ),
                AvailableLanguage(
                  languageCode: 'vi',
                  languageName: 'Tiếng Việt',
                  isDefault: false,
                  isActive: true,
                ),
              ];

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
              ...languagesToDisplay.map((lang) {
                return ListTile(
                  title: Text(lang.languageName == 'Korean' ? '한국어' : lang.languageName),
                  trailing:
                      LocalizationManager.instance.resolveLocale(lang.languageCode) ==
                          currentLocale
                      ? const Icon(Icons.check, color: AppColors.settingsItemBlue)
                      : null,
                  onTap: () {
                    context.read<SettingsBloc>().onAction(
                      SettingsAction.changeLanguage(languageCode: lang.languageCode),
                    );
                    Navigator.pop(bottomSheetContext);
                  },
                );
              }),
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

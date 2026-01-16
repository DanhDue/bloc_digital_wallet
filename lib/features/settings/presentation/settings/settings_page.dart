// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/environment_config.dart';
import '../../../../config/theme/app_themes.dart';
import '../../../../di/injection.dart';
import 'settings_action.dart';
import 'settings_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';

/// Settings Page - Full MVI feature with 4 states
@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsBloc>()..onAction(const LoadSettingsAction()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: context.appThemes.titleLarge)),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          // Listen to one-time events (navigation, snackbar, dialog)
          // State is passed to access current data during event handling
          context.read<SettingsBloc>().events.listen((event) {
            if (!context.mounted) return;
            _handleEvent(context, state, event);
          });
        },
        builder: (context, state) => _handleState(context, state),
      ),
    );
  }

  Widget _handleState(BuildContext context, SettingsState state) {
    return switch (state) {
      SettingsInitial() => _buildInitial(context),
    };
  }

  void _handleEvent(BuildContext context, SettingsState state, SettingsEvent event) {
    switch (event) {
      case ShowMessage(:final message, :final type):
        final color = switch (type) {
          MessageType.success => context.appThemes.primaryColor,
          MessageType.error => context.appThemes.errorColor,
          MessageType.info => context.appThemes.textSecondaryColor,
        };
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
      case NavigateToProfileEvent():
        context.router.push(const ProfileRoute());
      case NavigateToLoginEvent():
        context.router.root.replaceAll([const LoginRoute()]);
      case NavigateToTalkerEvent():
        context.router.push(const TalkerRoute());
    }
  }

  Widget _buildInitial(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<SettingsBloc>().onAction(const NavigateToProfile());
          },
          child: const Text('Navigate to Profile'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<SettingsBloc>().onAction(const LogoutAction());
          },
          child: const Text('Logout'),
        ),
        if (EnvironmentConfig.enableLogging)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: () {
                context.read<SettingsBloc>().onAction(const NavigateToTalkerAction());
              },
              child: const Text('Open Logs'),
            ),
          ),
      ],
    );
  }
}

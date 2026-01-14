// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  /// ============================================================================
  /// State Handling
  /// ============================================================================
  Widget _handleState(BuildContext context, SettingsState state) {
    return switch (state) {
      SettingsInitial() => _buildInitial(context),
      SettingsLoading() => _buildLoading(context),
      SettingsSuccess(:final data) => _buildSuccess(context, data),
      SettingsError(:final message) => _buildError(context, message),
    };
  }

  /// ============================================================================
  /// Event Handling
  /// ============================================================================
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
    }
  }

  /// ============================================================================
  /// State Widgets
  /// ============================================================================
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
        ElevatedButton(onPressed: () {}, child: const Text('Logout')),
      ],
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildSuccess<T>(BuildContext context, T data) {
    // Handle both single object and list
    final items = data is List ? data : [data];
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: context.appThemes.textSecondaryColor),
            const SizedBox(height: 16),
            Text('No data found', style: context.appThemes.bodyMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: CircleAvatar(child: Text(item.name[0].toUpperCase())),
          title: Text(item.name, style: context.appThemes.bodyLarge),
          subtitle: Text('ID: ${item.id}', style: context.appThemes.bodySmall),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: context.appThemes.errorColor),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: context.appThemes.bodyMedium.copyWith(color: context.appThemes.errorColor),
          ),
        ],
      ),
    );
  }
}

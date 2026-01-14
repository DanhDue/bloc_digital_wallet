// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../di/injection.dart';
import '../../../../config/theme/app_themes.dart';
import '../../domain/entities/{{{feature_name.snakeCase()}}}_entity.dart';
import '{{{feature_name.snakeCase()}}}_bloc.dart';
import '{{{feature_name.snakeCase()}}}_action.dart';
import '{{{feature_name.snakeCase()}}}_state.dart';
import '{{{feature_name.snakeCase()}}}_event.dart';

/// {{feature_name.titleCase()}} Page - Full MVI feature with 4 states
@RoutePage()
class {{feature_name.pascalCase()}}Page extends StatelessWidget {
  const {{feature_name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<{{feature_name.pascalCase()}}Bloc>()
        ..onAction(const Load{{feature_name.pascalCase()}}Action()),
      child: const _{{feature_name.pascalCase()}}View(),
    );
  }
}

class _{{feature_name.pascalCase()}}View extends StatelessWidget {
  const _{{feature_name.pascalCase()}}View();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('{{feature_name.titleCase()}}', style: context.appThemes.titleLarge),
      ),
      body: BlocConsumer<{{feature_name.pascalCase()}}Bloc, {{feature_name.pascalCase()}}State>(
        listener: (context, state) {
          // Listen to one-time events (navigation, snackbar, dialog)
          // State is passed to access current data during event handling
          context.read<{{feature_name.pascalCase()}}Bloc>().events.listen((event) {
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
  Widget _handleState(BuildContext context, {{feature_name.pascalCase()}}State state) {
    return switch (state) {
      {{feature_name.pascalCase()}}Initial() => _buildInitial(context),
      {{feature_name.pascalCase()}}Loading() => _buildLoading(context),
      {{feature_name.pascalCase()}}Success(:final data) => _buildSuccess(context, data),
      {{feature_name.pascalCase()}}Error(:final message) => _buildError(context, message),
    };
  }

  /// ============================================================================
  /// Event Handling
  /// ============================================================================
  void _handleEvent(
    BuildContext context,
    {{feature_name.pascalCase()}}State state,
    {{feature_name.pascalCase()}}Event event,
  ) {
    switch (event) {
      case ShowMessage(:final message, :final type):
        final color = switch (type) {
          MessageType.success => context.appThemes.primaryColor,
          MessageType.error => context.appThemes.errorColor,
          MessageType.info => context.appThemes.textSecondaryColor,
        };
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: color),
        );
    }
  }

  /// ============================================================================
  /// State Widgets
  /// ============================================================================
  Widget _buildInitial(BuildContext context) {
    return Center(
      child: Text('Initial state', style: context.appThemes.bodyMedium),
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

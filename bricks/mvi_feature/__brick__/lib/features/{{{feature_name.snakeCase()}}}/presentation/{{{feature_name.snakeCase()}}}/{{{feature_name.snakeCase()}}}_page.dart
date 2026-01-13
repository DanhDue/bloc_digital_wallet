// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../di/injection.dart';
import '../../../../config/theme/app_themes.dart';
import '{{{feature_name.snakeCase()}}}_bloc.dart';
import '{{{feature_name.snakeCase()}}}_action.dart';
import '{{{feature_name.snakeCase()}}}_state.dart';
import '{{{feature_name.snakeCase()}}}_event.dart';

/// {{feature_name.titleCase()}} Page - uses StatelessWidget + BlocProvider/BlocConsumer
@RoutePage()
class {{feature_name.pascalCase()}}Page extends StatelessWidget {
  const {{feature_name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<{{feature_name.pascalCase()}}Bloc>()
        ..onAction(const Load{{feature_name.pascalCase()}}Action()),
      child: BlocConsumer<{{feature_name.pascalCase()}}Bloc, {{feature_name.pascalCase()}}State>(
        listener: (context, state) {
          context.read<{{feature_name.pascalCase()}}Bloc>().events.listen((event) {
            if (!context.mounted) return;
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
          });
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('{{feature_name.titleCase()}}', style: context.appThemes.titleLarge),
            ),
            body: switch (state) {
              {{feature_name.pascalCase()}}Initial() => Center(
                child: Text('Initial state', style: context.appThemes.bodyMedium),
              ),
              {{feature_name.pascalCase()}}Loading() => const Center(child: CircularProgressIndicator()),
              {{feature_name.pascalCase()}}sLoaded(:final items) => items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: context.appThemes.textSecondaryColor),
                        const SizedBox(height: 16),
                        Text('No data found', style: context.appThemes.bodyMedium),
                      ],
                    ),
                  )
                : ListView.builder(
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
                  ),
              {{feature_name.pascalCase()}}Error(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: context.appThemes.errorColor),
                    const SizedBox(height: 16),
                    Text('Error: $message', style: context.appThemes.bodyMedium.copyWith(color: context.appThemes.errorColor)),
                  ],
                ),
              ),
            },
          );
        },
      ),
    );
  }
}

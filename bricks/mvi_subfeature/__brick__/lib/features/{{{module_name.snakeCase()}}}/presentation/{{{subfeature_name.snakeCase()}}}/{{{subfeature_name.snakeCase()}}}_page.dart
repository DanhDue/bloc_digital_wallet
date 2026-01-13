// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import '../../../../config/theme/app_themes.dart';
import '{{{subfeature_name.snakeCase()}}}_bloc.dart';
import '{{{subfeature_name.snakeCase()}}}_action.dart';
import '{{{subfeature_name.snakeCase()}}}_state.dart';
import '{{{subfeature_name.snakeCase()}}}_event.dart';

/// {{subfeature_name.titleCase()}} page within {{module_name.titleCase()}} module
@RoutePage()
class {{subfeature_name.pascalCase()}}Page extends StatelessWidget {
  const {{subfeature_name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<{{subfeature_name.pascalCase()}}Bloc>()
        ..onAction(const Load{{subfeature_name.pascalCase()}}Action()),
      child: BlocConsumer<{{subfeature_name.pascalCase()}}Bloc, {{subfeature_name.pascalCase()}}State>(
        listener: (context, state) {
          context.read<{{subfeature_name.pascalCase()}}Bloc>().events.listen((event) {
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
              title: Text('{{subfeature_name.titleCase()}}', style: context.appThemes.titleLarge),
            ),
            body: switch (state) {
              {{subfeature_name.pascalCase()}}Initial() => Center(
                child: Text('Initial state', style: context.appThemes.bodyMedium),
              ),
              {{subfeature_name.pascalCase()}}Loading() => const Center(child: CircularProgressIndicator()),
              {{subfeature_name.pascalCase()}}Success(:final items) => items.isEmpty
                  ? Center(
                      child: Text('No data found', style: context.appThemes.bodyMedium),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          title: Text(item.toString(), style: context.appThemes.bodyLarge),
                        );
                      },
                    ),
              {{subfeature_name.pascalCase()}}Error(:final message) => Center(
                child: Text('Error: $message', style: context.appThemes.bodyMedium.copyWith(color: context.appThemes.errorColor)),
              ),
            },
          );
        },
      ),
    );
  }
}

// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import '../../../../config/theme/app_themes.dart';
import 'profile_bloc.dart';
import 'profile_action.dart';
import 'profile_state.dart';
import 'profile_event.dart';

/// Profile page within Settings module
@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileBloc>()..onAction(const LoadProfileAction()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          context.read<ProfileBloc>().events.listen((event) {
            if (!context.mounted) return;
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
            }
          });
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text('Profile', style: context.appThemes.titleLarge)),
            body: switch (state) {
              ProfileInitial() => Center(
                child: Text('Initial state', style: context.appThemes.bodyMedium),
              ),
              ProfileLoading() => const Center(child: CircularProgressIndicator()),
              ProfileSuccess(:final items) =>
                items.isEmpty
                    ? Center(child: Text('No data found', style: context.appThemes.bodyMedium))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            title: Text(item.toString(), style: context.appThemes.bodyLarge),
                          );
                        },
                      ),
              ProfileError(:final message) => Center(
                child: Text(
                  'Error: $message',
                  style: context.appThemes.bodyMedium.copyWith(
                    color: context.appThemes.errorColor,
                  ),
                ),
              ),
            },
          );
        },
      ),
    );
  }
}

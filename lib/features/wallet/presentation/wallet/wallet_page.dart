// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../di/injection.dart';
import '../../../../config/theme/app_themes.dart';
import 'wallet_bloc.dart';
import 'wallet_action.dart';
import 'wallet_state.dart';
import 'wallet_event.dart';

/// Wallet Page - uses StatelessWidget + BlocProvider/BlocConsumer
/// All UI state is managed in the BLoC, not with setState()
@RoutePage()
class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WalletBloc>()..onAction(const LoadAllWalletsAction()),
      child: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          // Listen to events for side effects (one-time actions)
          context.read<WalletBloc>().events.listen((event) {
            if (!context.mounted) return;
            switch (event) {
              case ShowSuccessMessage(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: context.appThemes.primaryColor,
                  ),
                );
              case ShowErrorMessage(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message), backgroundColor: context.appThemes.errorColor),
                );
              case NavigateToWalletDetail():
                // TODO: Implement navigation
                break;
              case NavigateBack():
                context.router.maybePop();
            }
          });
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Wallet', style: context.appThemes.titleLarge),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<WalletBloc>().onAction(const RefreshWalletsAction());
                  },
                ),
              ],
            ),
            body: switch (state) {
              WalletInitial() => Center(
                child: Text('Press refresh to load data', style: context.appThemes.bodyMedium),
              ),
              WalletLoading() => const Center(child: CircularProgressIndicator()),
              WalletEmpty() => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: context.appThemes.textSecondaryColor),
                    const SizedBox(height: 16),
                    Text('No wallets found', style: context.appThemes.bodyMedium),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<WalletBloc>().onAction(const RefreshWalletsAction());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              WalletsLoaded(:final items) => RefreshIndicator(
                onRefresh: () async {
                  context.read<WalletBloc>().onAction(const RefreshWalletsAction());
                },
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(item.name[0].toUpperCase())),
                      title: Text(item.name, style: context.appThemes.bodyLarge),
                      subtitle: Text('ID: ${item.id}', style: context.appThemes.bodySmall),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Navigate to detail
                      },
                    );
                  },
                ),
              ),
              WalletError(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: context.appThemes.errorColor),
                    const SizedBox(height: 16),
                    Text(
                      'Error: $message',
                      style: context.appThemes.bodyMedium.copyWith(
                        color: context.appThemes.errorColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<WalletBloc>().onAction(const RefreshWalletsAction());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              _ => const Center(child: Text('Unknown state')),
            },
          );
        },
      ),
    );
  }
}

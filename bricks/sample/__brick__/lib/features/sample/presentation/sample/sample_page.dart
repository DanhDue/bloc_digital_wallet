// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../di/injection.dart';
import '../../../../config/theme/app_themes.dart';
import 'sample_bloc.dart';
import 'sample_action.dart';
import 'sample_state.dart';
import 'sample_event.dart';

/// Sample Sample Page demonstrating full MVI pattern
@RoutePage()
class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SampleBloc>()
        ..onAction(const LoadAllSamplesAction()),
      child: BlocConsumer<SampleBloc, SampleState>(
        listener: (context, state) {
          context.read<SampleBloc>().events.listen((event) {
            if (!context.mounted) return;
            switch (event) {
              case ShowMessage(:final message, :final type):
                final color = switch (type) {
                  MessageType.success => context.appThemes.primaryColor,
                  MessageType.error => context.appThemes.errorColor,
                  MessageType.warning => Colors.orange,
                  MessageType.info => context.appThemes.textSecondaryColor,
                };
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message), backgroundColor: color),
                );
              case NavigateToSampleDetail(:final id):
                // TODO: Navigate to detail page
                debugPrint('Navigate to detail: $id');
              case NavigateToCreateSample():
                // TODO: Navigate to create page
                debugPrint('Navigate to create');
              case NavigateToEditSample(:final id):
                // TODO: Navigate to edit page
                debugPrint('Navigate to edit: $id');
              case NavigateBack():
                context.router.maybePop();
              case ShowConfirmDialog(:final title, :final message):
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                );
            }
          });
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Sample', style: context.appThemes.titleLarge),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<SampleBloc>().onAction(
                      const RefreshSamplesAction(),
                    );
                  },
                ),
              ],
            ),
            body: switch (state) {
              SampleInitial() => Center(
                child: Text('Initial state', style: context.appThemes.bodyMedium),
              ),
              SampleLoading() => const Center(child: CircularProgressIndicator()),
              SampleCreating() => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Creating...'),
                  ],
                ),
              ),
              SampleDeleting(:final id) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text('Deleting $id...'),
                  ],
                ),
              ),
              SampleEmpty() => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: context.appThemes.textSecondaryColor),
                    const SizedBox(height: 16),
                    Text('No data found', style: context.appThemes.bodyMedium),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<SampleBloc>().onAction(
                          const RefreshSamplesAction(),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              SamplesLoaded(:final items) => RefreshIndicator(
                onRefresh: () async {
                  context.read<SampleBloc>().onAction(
                    const RefreshSamplesAction(),
                  );
                },
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(item.name[0].toUpperCase())),
                      title: Text(item.name, style: context.appThemes.bodyLarge),
                      subtitle: Text('ID: ${item.id}', style: context.appThemes.bodySmall),
                      trailing: PopupMenuButton(
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              context.read<SampleBloc>().onAction(
                                UpdateSampleAction(id: item.id, name: item.name),
                              );
                            case 'delete':
                              context.read<SampleBloc>().onAction(
                                DeleteSampleAction(item.id),
                              );
                          }
                        },
                      ),
                      onTap: () {
                        context.read<SampleBloc>().onAction(
                          LoadSampleAction(item.id),
                        );
                      },
                    );
                  },
                ),
              ),
              SampleLoaded(:final item) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Detail: ${item.name}', style: context.appThemes.headlineSmall),
                    Text('ID: ${item.id}', style: context.appThemes.bodyMedium),
                  ],
                ),
              ),
              SampleCreated(:final item) => Center(
                child: Text('Created: ${item.name}', style: context.appThemes.bodyMedium),
              ),
              SampleError(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: context.appThemes.errorColor),
                    const SizedBox(height: 16),
                    Text('Error: $message', style: context.appThemes.bodyMedium.copyWith(color: context.appThemes.errorColor)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<SampleBloc>().onAction(
                          const RefreshSamplesAction(),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            },
            floatingActionButton: FloatingActionButton(
              heroTag: 'sample_fab',
              onPressed: () {
                context.read<SampleBloc>().onAction(
                  const CreateSampleAction(name: 'New Item'),
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

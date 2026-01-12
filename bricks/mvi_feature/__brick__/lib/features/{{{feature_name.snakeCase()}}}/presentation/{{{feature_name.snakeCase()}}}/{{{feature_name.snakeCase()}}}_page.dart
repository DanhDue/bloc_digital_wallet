// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '{{{feature_name.snakeCase()}}}_bloc.dart';
import '{{{feature_name.snakeCase()}}}_action.dart';
import '{{{feature_name.snakeCase()}}}_state.dart';
import '{{{feature_name.snakeCase()}}}_event.dart';

@RoutePage()
class {{feature_name.pascalCase()}}Page extends StatefulWidget {
  const {{feature_name.pascalCase()}}Page({super.key});

  @override
  State<{{feature_name.pascalCase()}}Page> createState() => _{{feature_name.pascalCase()}}PageState();
}

class _{{feature_name.pascalCase()}}PageState extends State<{{feature_name.pascalCase()}}Page> {
  @override
  void initState() {
    super.initState();
    // Load data on init using single entry point
    context.read<{{feature_name.pascalCase()}}Bloc>().onAction(const LoadAll{{feature_name.pascalCase()}}sAction());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{feature_name.titleCase()}}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Single entry point: onAction()
              context
                  .read<{{feature_name.pascalCase()}}Bloc>()
                  .onAction(const Refresh{{feature_name.pascalCase()}}sAction());
            },
          ),
        ],
      ),
      body: BlocConsumer<{{feature_name.pascalCase()}}Bloc, {{feature_name.pascalCase()}}State>(
        // Listen to events (side effects - one-time)
        listener: (context, state) {
          context.read<{{feature_name.pascalCase()}}Bloc>().events.listen((event) {
            switch (event) {
              case ShowSuccessMessage():
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(event.message),
                    backgroundColor: Colors.green,
                  ),
                );
              case ShowErrorMessage():
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(event.message),
                    backgroundColor: Colors.red,
                  ),
                );
              case NavigateTo{{feature_name.pascalCase()}}Detail():
                // TODO: Implement navigation
                break;
              case NavigateBack():
                Navigator.of(context).pop();
            }
          });
        },
        // Build UI based on state
        builder: (context, state) {
          return switch (state) {
            {{feature_name.pascalCase()}}Initial() => const Center(
                child: Text('Press refresh to load data'),
              ),
            {{feature_name.pascalCase()}}Loading() => const Center(
                child: CircularProgressIndicator(),
              ),
            {{feature_name.pascalCase()}}Empty() => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inbox, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No {{feature_name.lowerCase()}}s found'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<{{feature_name.pascalCase()}}Bloc>()
                            .onAction(const Refresh{{feature_name.pascalCase()}}sAction());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            {{feature_name.pascalCase()}}sLoaded(:final items) => RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<{{feature_name.pascalCase()}}Bloc>()
                      .onAction(const Refresh{{feature_name.pascalCase()}}sAction());
                },
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(item.name[0].toUpperCase()),
                      ),
                      title: Text(item.name),
                      subtitle: Text('ID: ${item.id}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Navigate to detail
                      },
                    );
                  },
                ),
              ),
            {{feature_name.pascalCase()}}Error(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: $message',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<{{feature_name.pascalCase()}}Bloc>()
                            .onAction(const Refresh{{feature_name.pascalCase()}}sAction());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            _ => const Center(child: Text('Unknown state')),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

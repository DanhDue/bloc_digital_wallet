// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_bloc.dart';
import 'home_action.dart';
import 'home_state.dart';
import 'home_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load data on init using single entry point
    context.read<HomeBloc>().onAction(const LoadAllHomesAction());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Single entry point: onAction()
              context.read<HomeBloc>().onAction(const RefreshHomesAction());
            },
          ),
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        // Listen to events (side effects - one-time)
        listener: (context, state) {
          context.read<HomeBloc>().events.listen((event) {
            switch (event) {
              case ShowSuccessMessage():
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(event.message), backgroundColor: Colors.green),
                );
              case ShowErrorMessage():
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(event.message), backgroundColor: Colors.red),
                );
              case NavigateToHomeDetail():
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
            HomeInitial() => const Center(child: Text('Press refresh to load data')),
            HomeLoading() => const Center(child: CircularProgressIndicator()),
            HomeEmpty() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No homes found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().onAction(const RefreshHomesAction());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            HomesLoaded(:final items) => RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().onAction(const RefreshHomesAction());
              },
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(item.name[0].toUpperCase())),
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
            HomeError(:final message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: $message',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().onAction(const RefreshHomesAction());
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

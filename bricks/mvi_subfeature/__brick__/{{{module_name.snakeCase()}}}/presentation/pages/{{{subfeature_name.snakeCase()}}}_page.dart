// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import '../mvi/{{{module_name.snakeCase()}}}_bloc.dart';
import '../mvi/{{{module_name.snakeCase()}}}_action.dart';
import '../mvi/{{{module_name.snakeCase()}}}_state.dart';
import '../mvi/{{{module_name.snakeCase()}}}_event.dart';

/// {{subfeature_name.titleCase()}} page within {{module_name.titleCase()}} module
@RoutePage()
class {{subfeature_name.pascalCase()}}Page extends StatefulWidget {
  const {{subfeature_name.pascalCase()}}Page({super.key});

  @override
  State<{{subfeature_name.pascalCase()}}Page> createState() => _{{subfeature_name.pascalCase()}}PageState();
}

class _{{subfeature_name.pascalCase()}}PageState extends State<{{subfeature_name.pascalCase()}}Page> {
  late final {{module_name.pascalCase()}}Bloc _bloc;
  late final StreamSubscription<{{module_name.pascalCase()}}Event> _eventSubscription;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<{{module_name.pascalCase()}}Bloc>();
    
    // Listen to one-time events (side effects)
    _eventSubscription = _bloc.events.listen((event) {
      if (!mounted) return;
      
      // TODO: Handle events specific to {{subfeature_name.titleCase()}}
      switch (event) {
        case ShowSuccessMessage(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
            ),
          );
        case ShowErrorMessage(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        case NavigateBack():
          context.router.pop();
        default:
          // Ignore other events
          break;
      }
    });

    // TODO: Load initial data if needed
    // _bloc.onAction(const Load{{subfeature_name.pascalCase()}}DataAction());
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('{{subfeature_name.titleCase()}}'),
        ),
        body: BlocBuilder<{{module_name.pascalCase()}}Bloc, {{module_name.pascalCase()}}State>(
          builder: (context, state) {
            // TODO: Build UI based on state
            return switch (state) {
              {{module_name.pascalCase()}}Initial() => const Center(
                  child: Text('Initial state'),
                ),
              {{module_name.pascalCase()}}Loading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              {{module_name.pascalCase()}}Error(:final message) => Center(
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
                    ],
                  ),
                ),
              _ => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('{{subfeature_name.titleCase()}} Page'),
                      const SizedBox(height: 16),
                      const Text('TODO: Implement UI'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Trigger action
                          // _bloc.onAction(const Your{{subfeature_name.pascalCase()}}Action());
                        },
                        child: const Text('Test Action'),
                      ),
                    ],
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}

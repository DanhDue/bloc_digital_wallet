// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import '{{{subfeature_name.snakeCase()}}}_bloc.dart';
import '{{{subfeature_name.snakeCase()}}}_action.dart';
import '{{{subfeature_name.snakeCase()}}}_state.dart';
import '{{{subfeature_name.snakeCase()}}}_event.dart';

/// {{subfeature_name.titleCase()}} page within {{module_name.titleCase()}} module
@RoutePage()
class {{subfeature_name.pascalCase()}}Page extends StatefulWidget {
  const {{subfeature_name.pascalCase()}}Page({super.key});

  @override
  State<{{subfeature_name.pascalCase()}}Page> createState() => _{{subfeature_name.pascalCase()}}PageState();
}

class _{{subfeature_name.pascalCase()}}PageState extends State<{{subfeature_name.pascalCase()}}Page> {
  late final {{subfeature_name.pascalCase()}}Bloc _bloc;
  late final StreamSubscription<{{subfeature_name.pascalCase()}}Event> _eventSubscription;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<{{subfeature_name.pascalCase()}}Bloc>();
    
    // Listen to one-time events (side effects)
    _eventSubscription = _bloc.events.listen((event) {
      if (!mounted) return;
      
      switch (event) {
        case Show{{subfeature_name.pascalCase()}}SuccessMessage(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
            ),
          );
        case Show{{subfeature_name.pascalCase()}}ErrorMessage(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
      }
    });

    // Load initial data
    _bloc.onAction(const Load{{subfeature_name.pascalCase()}}Action());
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
        body: BlocBuilder<{{subfeature_name.pascalCase()}}Bloc, {{subfeature_name.pascalCase()}}State>(
          builder: (context, state) {
            return switch (state) {
              {{subfeature_name.pascalCase()}}Initial() => const Center(child: Text('Initial state')),
              {{subfeature_name.pascalCase()}}Loading() => const Center(child: CircularProgressIndicator()),
              {{subfeature_name.pascalCase()}}Error(:final message) => Center(child: Text('Error: $message')),
              {{subfeature_name.pascalCase()}}Success(:final data) => Center(child: Text('Success: $data')),
            };
          },
        ),
      ),
    );
  }
}

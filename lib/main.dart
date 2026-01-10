// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter/cubit/counter_cubit.dart';
import 'di/injection.dart';
import 'config/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Wallet',
      theme: ThemeData(
        extensions: [AppThemes.light],
        colorScheme: ColorScheme.light(
          primary: AppThemes.light.primaryColor,
          secondary: AppThemes.light.secondaryColor,
          surface: AppThemes.light.surfaceColor,
          error: AppThemes.light.errorColor,
        ),
      ),
      darkTheme: ThemeData(
        extensions: [AppThemes.dark],
        colorScheme: ColorScheme.dark(
          primary: AppThemes.dark.primaryColor,
          secondary: AppThemes.dark.secondaryColor,
          surface: AppThemes.dark.surfaceColor,
          error: AppThemes.dark.errorColor,
        ),
      ),
      home: BlocProvider(
        create: (_) => getIt<CounterCubit>(),
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            BlocBuilder<CounterCubit, int>(
              builder: (context, count) {
                return Text('$count', style: context.appThemes.displayMedium);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterCubit>().increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

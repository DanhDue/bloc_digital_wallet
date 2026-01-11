// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter/cubit/counter_cubit.dart';
import 'di/injection.dart';
import 'config/theme/app_theme.dart';
import 'config/environment_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Print environment configuration
  EnvironmentConfig.printConfig();

  // Initialize dependency injection
  configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: EnvironmentConfig.appName,
      debugShowCheckedModeBanner: EnvironmentConfig.showDebugBanner,
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
        child: MyHomePage(title: EnvironmentConfig.appName),
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            if (EnvironmentConfig.enableLogging)
              Text(
                'ENV: ${EnvironmentConfig.environment.toUpperCase()}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
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
            const SizedBox(height: 24),
            // Environment indicator
            if (EnvironmentConfig.enableLogging) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getEnvironmentColor(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      EnvironmentConfig.environment.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      EnvironmentConfig.apiBaseUrl,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  Color _getEnvironmentColor() {
    if (EnvironmentConfig.isDevelopment) {
      return Colors.green;
    } else if (EnvironmentConfig.isStaging) {
      return Colors.orange;
    } else if (EnvironmentConfig.isProduction) {
      return Colors.blue;
    }
    return Colors.grey;
  }
}

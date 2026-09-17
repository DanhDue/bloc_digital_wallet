// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:d3_nexus_shield/generated/translations.dart';
import 'package:framework/framework.dart';

import 'package:d3_nexus_shield/deeplink/deep_link_coordinator.dart';
import 'package:d3_nexus_shield/shell/shell_bloc.dart';
import 'package:d3_nexus_shield/shell/shell_action.dart';
import 'package:d3_nexus_shield/shell/shell_event.dart';
import 'package:d3_nexus_shield/shell/shell_state.dart';
import 'package:d3_nexus_shield/shell/widgets/custom_bottom_nav_bar.dart';
import 'package:d3_nexus_shield/shell/home_dashboard_page.dart';
import 'package:d3_nexus_shield/shell/shell_config.dart';
// shell:scanner-import:begin
import 'package:scanner/scanner.dart';
// shell:scanner-import:end
import 'package:settings/settings.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:core/core.dart';

@RoutePage()
class ShellPage extends BaseMviStatefulPage<ShellBloc, ShellAction, ShellState, ShellEvent> {
  final VoidCallback? onRouterReady;

  const ShellPage({super.key, this.onRouterReady});

  @override
  BaseMviPageState<ShellBloc, ShellAction, ShellState, ShellEvent, ShellPage> createState() =>
      _ShellPageState();
}

class _ShellPageState
    extends BaseMviPageState<ShellBloc, ShellAction, ShellState, ShellEvent, ShellPage> {
  @override
  void initState() {
    super.initState();
    bloc.onAction(const ShellAction.started());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (widget.onRouterReady != null) {
          widget.onRouterReady!();
        } else if (GetIt.I.isRegistered<DeepLinkCoordinator>()) {
          GetIt.I<DeepLinkCoordinator>().markRouterReady();
        }

        ColdStartProfiler.instance.mark(ColdStartMilestone.firstScreenInteractive);
        ColdStartProfiler.instance.finish();
        ColdStartProfiler.instance.logReport((table) {
          if (GetIt.I.isRegistered<Talker>()) {
            GetIt.I<Talker>().logCustom(ColdStartLog('\n$table'));
          } else {
            debugPrint(table);
          }
        });
      }
    });
  }

  @override
  Widget buildScaffold(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.read<ShellBloc>().onAction(const ShellAction.backPressed());
      },
      child: Scaffold(
        body: buildBody(context),
        bottomNavigationBar: BlocBuilder<ShellBloc, ShellState>(
          buildWhen: (previous, current) => previous.currentTabIndex != current.currentTabIndex,
          builder: (context, state) {
            return CustomBottomNavBar(
              currentIndex: state.currentTabIndex,
              onTap: (index) {
                context.read<ShellBloc>().onAction(ShellAction.tabChanged(index));
              },
              onDoubleTap: (index) {
                context.read<ShellBloc>().onAction(ShellAction.tabDoubleTapped(index));
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocBuilder<ShellBloc, ShellState>(
      buildWhen: (previous, current) => previous.currentTabIndex != current.currentTabIndex,
      builder: (context, state) => handleState(context, state),
    );
  }

  @override
  Widget handleState(BuildContext context, ShellState state) {
    return SafeArea(
      top: false,
      bottom: false,
      child: LazyIndexedStack.builder(
        index: state.currentTabIndex.clamp(0, ShellConfig.tabCount - 1).toInt(),
        itemCount: ShellConfig.tabCount,
        itemBuilder: (context, index) => _buildTab(context, index),
      ),
    );
  }

  void _onGoHome(BuildContext context) {
    context.read<ShellBloc>().onAction(const ShellAction.tabChanged(0));
  }

  Widget _buildTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        return MiniAppErrorBoundary(
          moduleName: 'Home',
          onGoHome: () => _onGoHome(context),
          child: const HomeDashboardPage(),
        );
      // shell:scanner-page:begin
      case 1:
        return MiniAppErrorBoundary(
          moduleName: 'Scanner',
          onGoHome: () => _onGoHome(context),
          child: const ScannerPage(),
        );
      // shell:scanner-page:end
      case 2:
        return MiniAppErrorBoundary(
          moduleName: 'Settings',
          onGoHome: () => _onGoHome(context),
          child: const SettingsPage(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  void handleEvent(BuildContext context, ShellEvent event) {
    event.map(
      showExitToast: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t.home.main.exitToast),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      exitApp: (_) {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        }
      },
    );
  }
}

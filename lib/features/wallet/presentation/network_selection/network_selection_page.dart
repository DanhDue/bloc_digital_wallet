// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/core/extensions/widget_extensions.dart';
import 'package:bloc_digital_wallet/generated/assets.gen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'network_selection_bloc.dart';
import 'network_selection_state.dart';
import 'network_selection_event.dart';
import 'network_selection_action.dart';

/// ============================================================================
/// NetworkSelection Page
/// ============================================================================
/// MVI Page - Only implement the MVI methods:
/// - buildAppBar: Optional app bar
/// - handleState: Build UI based on state
/// - handleEvent: Handle one-time events
/// - onBlocCreated: Optional initial action
/// ============================================================================

@RoutePage()
class NetworkSelectionPage
    extends BaseMviPage<NetworkSelectionBloc, NetworkSelectionState, NetworkSelectionEvent> {
  const NetworkSelectionPage({super.key});

  // TODO: Uncomment to dispatch initial action
  @override
  void Function(NetworkSelectionBloc bloc)? get onBlocCreated =>
      (bloc) => bloc.onAction(const LoadNetworkSelectionAction());

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildScaffold(BuildContext context) => buildBody(context);

  @override
  Widget handleState(BuildContext context, NetworkSelectionState state) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24), // Spacer for centering if needed, or close button logic
              Text(
                'Select network',
                style: context.appThemes.titleMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () => context.router.pop(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Assets.images.icCloseRound.svg(width: 24, height: 24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.appThemes.trueBlue),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Assets.images.icSearch.svg(
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(context.appThemes.trueBlue, BlendMode.srcIn),
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) => context.read<NetworkSelectionBloc>().onAction(
                SearchNetworkSelectionAction(value),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // List
          Flexible(
            child: switch (state) {
              NetworkSelectionInitial() ||
              NetworkSelectionLoading() => const Center(child: CircularProgressIndicator()),
              NetworkSelectionError(:final message) => Center(child: Text(message)),
              NetworkSelectionSuccess(:final items) => ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: item.logo != null && item.logo!.isNotEmpty
                        ? SizedBox(
                            width: 48,
                            height: 48,
                            child: ClipRRect(
                              borderRadius: .circular(48),
                              child: Image.network(
                                item.logo!,
                                width: 24,
                                height: 24,
                                errorBuilder: (_, _, _) => const Icon(Icons.error),
                              ),
                            ).paddingAll(6),
                          )
                        : SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(
                              Icons.connected_tv_outlined,
                              size: 36,
                              color: context.appThemes.trueBlue,
                            ),
                          ),
                    title: Text(item.name ?? '', style: context.appThemes.bodyMedium),
                    onTap: () {
                      context.router.pop(item);
                    },
                  );
                },
              ),
            },
          ),
        ],
      ),
    );
  }

  @override
  void handleEvent(BuildContext context, NetworkSelectionEvent event) {
    // TODO: Handle events with switch
    // switch (event) {
    //   case ShowMessage(:final message, :final type):
    //     // Show snackbar
    //     break;
    //   case NavigateBackEvent():
    //     context.router.pop();
    //     break;
    // }
  }

  /// ============================================================================
  /// State Widgets
  /// ============================================================================
  // Widget _buildInitial(BuildContext context) {
  //   return const Center(child: Text('Network Selection Subfeature'));
  // }
}

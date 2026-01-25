// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/app_router.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/core/utils/log.dart';
import 'package:bloc_digital_wallet/core/mixin/dialog_mixin.dart';
import 'package:bloc_digital_wallet/features/wallet/data/models/network_object.dart';
import 'package:bloc_digital_wallet/generated/assets.gen.dart';
import 'package:bloc_digital_wallet/generated/colors.gen.dart';

import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wallet_bloc.dart';
import 'wallet_state.dart';
import 'wallet_event.dart';
import 'wallet_action.dart';
import 'package:bloc_digital_wallet/core/extensions/dialog_extensions.dart';
import 'package:bloc_digital_wallet/core/extensions/widget_extensions.dart';

/// ============================================================================
/// Wallet Page
/// ============================================================================
/// MVI Page - Only implement the MVI methods:
/// - buildAppBar: Optional app bar
/// - handleState: Build UI based on state
/// - handleEvent: Handle one-time events
/// - onBlocCreated: Optional initial action
/// ============================================================================

@RoutePage()
class WalletPage extends BaseMviPage<WalletBloc, WalletState, WalletEvent> with DialogMixin {
  const WalletPage({super.key});

  @override
  BaseAction? get initialAction => const InitWalletAction();

  @override
  Widget handleState(BuildContext context, WalletState state) {
    return switch (state) {
      WalletInitial() => const Center(child: CircularProgressIndicator()),
      WalletSuccess(:final selectedNetwork) => _buildSuccess(context, selectedNetwork),
      // WalletLoading() => const Center(child: CircularProgressIndicator()),
      // WalletError(:final message) => _buildError(context, message),
    };
  }

  @override
  void handleEvent(BuildContext context, WalletEvent event) {
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
  Widget _buildSuccess(BuildContext context, NetworkObject? selectedNetwork) {
    return Column(
      children: [
        _buildTopBar(context, selectedNetwork),
        Center(child: Text('Wallet Feature')),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, NetworkObject? selectedNetwork) {
    return Row(
      mainAxisAlignment: .start,
      crossAxisAlignment: .center,
      mainAxisSize: .max,
      children: [
        InkWell(
          onTap: () => context.showCommingSoon(),
          child: SizedBox(
            width: 48,
            height: 48,
            child: ClipRRect(
              borderRadius: .circular(48),
              child: AnimatedBoringAvatar(
                name: "ZenoWallet - Pieter",
                type: BoringAvatarType.beam,
                duration: const Duration(milliseconds: 300),
              ),
            ),
          ),
        ),
        const SizedBox(width: 42),
        Expanded(child: SizedBox.shrink()),
        InkWell(
          onTap: () async {
            final result = await context.router.push(const NetworkSelectionRoute());
            Log.d("selected network: $result");
            if (result != null && result is NetworkObject && context.mounted) {
              context.read<WalletBloc>().onAction(SelectNetworkAction(result));
            }
          },
          child: Container(
            padding: const .symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: .circular(20),
              gradient: LinearGradient(
                colors: [
                  context.appThemes.middleBlue,
                  context.appThemes.middleBlue,
                  context.appThemes.pinkLady,
                ],
                begin: .centerLeft,
                end: .centerRight,
                stops: const [0.0, 0.2, 1.0],
              ),
            ),
            child: Row(
              mainAxisAlignment: .start,
              crossAxisAlignment: .center,
              mainAxisSize: .min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: ClipRRect(
                    borderRadius: .circular(24),
                    child: (selectedNetwork?.logo?.isNotEmpty ?? false)
                        ? Image.network(
                            selectedNetwork!.logo!,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.error, size: 16, color: Colors.white),
                          )
                        : SizedBox(
                            width: 36,
                            height: 36,
                            child: Icon(
                              Icons.connected_tv_outlined,
                              size: 24,
                              color: context.appThemes.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  selectedNetwork?.name ?? "All Networks",
                  style: context.appThemes.bodyMedium.copyWith(color: AppColors.white),
                ),
                const SizedBox(width: 6),
                Assets.images.icChevronDown.svg(
                  width: 24,
                  height: 24,
                  fit: .cover,
                  colorFilter: .mode(context.appThemes.white, .srcIn),
                ),
              ],
            ),
          ),
        ),
        const Expanded(child: SizedBox.shrink()),
        InkWell(
          onTap: () => context.showCommingSoon(),
          child: Assets.images.icSearch
              .svg(width: 24, height: 24, fit: .cover)
              .paddingSymmetric(horizontal: 6),
        ),
        InkWell(
          onTap: () => context.showCommingSoon(),
          child: Assets.images.icBitcoinCard
              .svg(
                width: 24,
                height: 24,
                fit: .cover,
                colorFilter: .mode(context.appThemes.trueBlue, .srcIn),
              )
              .paddingOnly(left: 12),
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}

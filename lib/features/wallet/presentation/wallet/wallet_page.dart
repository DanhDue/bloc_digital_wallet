// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/app_router.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'package:bloc_digital_wallet/core/extensions/dialog_extensions.dart';
import 'package:bloc_digital_wallet/core/extensions/widget_extensions.dart';
import 'package:bloc_digital_wallet/core/mixin/dialog_mixin.dart';
import 'package:bloc_digital_wallet/core/utils/log.dart';
import 'package:bloc_digital_wallet/core/widgets/keep_alive_widget.dart';
import 'package:bloc_digital_wallet/core/widgets/rectangular_indicator.dart';
import 'package:bloc_digital_wallet/core/widgets/token_action_button.dart';
import 'package:bloc_digital_wallet/features/wallet/data/models/network_object.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/nfts_list/nfts_list_page.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/token_list/token_list_page.dart';
import 'package:bloc_digital_wallet/features/wallet/presentation/wallet_list/wallet_list_page.dart';
import 'package:bloc_digital_wallet/generated/assets.gen.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

import 'wallet_action.dart';
import 'wallet_bloc.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

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
class WalletPage extends BaseMviStatefulPage<WalletBloc, WalletState, WalletEvent> {
  const WalletPage({super.key});

  @override
  BaseMviPageState<WalletBloc, WalletState, WalletEvent, WalletPage> createState() =>
      _WalletPageState();
}

class _WalletPageState extends BaseMviPageState<WalletBloc, WalletState, WalletEvent, WalletPage>
    with DialogMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void Function(WalletBloc bloc)? get onBlocCreated =>
      (bloc) => bloc.onAction(const InitWalletAction());

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
  }

  Widget _buildSuccess(BuildContext context, NetworkObject? selectedNetwork) {
    return Column(
      children: [
        _buildTopBar(context, selectedNetwork),
        const SizedBox(height: 16),
        const SizedBox(child: WalletListPage()),
        const SizedBox(height: 16),
        _buildActionButtons(context),
        const SizedBox(height: 16),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: context.appThemes.white,
            borderRadius: .circular(8),
            border: Border.all(color: context.appThemes.trueBlue100),
          ),
          child: TabBar(
            indicatorSize: .tab,
            labelPadding: const .symmetric(vertical: 0),
            indicatorPadding: const .symmetric(vertical: 4),
            splashFactory: NoSplash.splashFactory,
            overlayColor: .all(context.appThemes.transparent),
            dividerColor: context.appThemes.transparent,
            labelColor: context.appThemes.white,
            unselectedLabelColor: context.appThemes.ink40,
            labelStyle: context.appThemes.titleSmall.copyWith(fontWeight: FontWeight.bold),
            unselectedLabelStyle: context.appThemes.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
            indicator: RectangularIndicator(
              color: context.appThemes.trueBlue,
              bottomLeftRadius: 6,
              bottomRightRadius: 6,
              topLeftRadius: 6,
              topRightRadius: 6,
              horizontalPadding: 0,
              verticalPadding: 0,
              paintingStyle: .fill,
            ),
            controller: _tabController,
            tabs: <Widget>[
              Tab(text: context.t.token),
              Tab(text: context.t.nft),
            ],
          ).paddingSymmetric(horizontal: 5.0),
        ).marginSymmetric(horizontal: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              KeepAliveWidget(child: TokenListPage()).paddingSymmetric(horizontal: 16.0),
              KeepAliveWidget(child: NftsListPage()).paddingSymmetric(horizontal: 16.0),
            ],
          ),
        ),
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
                type: .beam,
                duration: const Duration(milliseconds: 300),
              ),
            ),
          ),
        ),
        const SizedBox(width: 42),
        const Expanded(child: SizedBox.shrink()),
        InkWell(
          onTap: () async {
            final result = await context.router.push(const NetworkSelectionRoute());
            Log.d("selected network: $result");
            if (result != null && result is NetworkObject && mounted) {
              bloc.onAction(SelectNetworkAction(result));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: .circular(20),
              gradient: LinearGradient(
                colors: [
                  context.appThemes.middleBlue,
                  context.appThemes.middleBlue,
                  context.appThemes.pinkLady,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
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
                            fit: .cover,
                            errorBuilder: (_, _, _) =>
                                Icon(Icons.error, size: 16, color: context.appThemes.white),
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
                  style: context.appThemes.bodyMedium.copyWith(color: context.appThemes.white),
                ),
                const SizedBox(width: 6),
                Assets.images.icChevronDown.svg(
                  width: 24,
                  height: 24,
                  fit: .cover,
                  colorFilter: .mode(context.appThemes.white, .srcIn),
                ),
              ],
            ).paddingSymmetric(horizontal: 10, vertical: 10),
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      crossAxisAlignment: .center,
      mainAxisSize: .max,
      children: [
        InkWell(
          onTap: () => context.showCommingSoon(),
          child: TokenActionButton(icon: Assets.images.icSend, title: context.t.walletActionSend),
        ),
        InkWell(
          onTap: () => context.showCommingSoon(),
          child: TokenActionButton(
            icon: Assets.images.icReceive,
            title: context.t.walletActionReceive,
          ),
        ),
        InkWell(
          onTap: () => context.showCommingSoon(),
          child: TokenActionButton(icon: Assets.images.icBuy, title: context.t.walletActionBuy),
        ),
        InkWell(
          onTap: () => context.showCommingSoon(),
          child: TokenActionButton(
            icon: Assets.images.icStaking,
            title: context.t.walletActionStaking,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 50);
  }
}

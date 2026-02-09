// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:framework/framework.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:wallet/domain/entities/network_selection_entity.dart';
import 'package:wallet/presentation/nfts_list/nfts_list_page.dart';
import 'package:wallet/presentation/token_list/token_list_page.dart';
import 'package:wallet/presentation/wallet_list/wallet_list_page.dart';
import 'package:wallet/wallet_router.dart';
import 'package:wallet/wallet_strings.dart';

import 'wallet_action.dart';
import 'wallet_bloc.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

@RoutePage()
class WalletPage extends BaseMviStatefulPage<WalletBloc, WalletState, WalletEvent> {
  const WalletPage({super.key});

  @override
  BaseMviPageState<WalletBloc, WalletState, WalletEvent, WalletPage> createState() =>
      _WalletPageState();
}

class _WalletPageState extends BaseMviPageState<WalletBloc, WalletState, WalletEvent, WalletPage>
    with SingleTickerProviderStateMixin {
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
      (bloc) => bloc.add(const WalletAction.started());

  @override
  Widget buildScaffold(BuildContext context) => buildBody(context);

  @override
  Widget handleState(BuildContext context, WalletState state) {
    return switch (state.status) {
      WalletStatus.initial => const Center(child: CircularProgressIndicator()),
      WalletStatus.loading => const Center(child: CircularProgressIndicator()),
      WalletStatus.success => _buildSuccess(context, state),
      WalletStatus.failure => Center(child: Text(state.errorMessage ?? WalletStrings.t.title)),
    };
  }

  @override
  void handleEvent(BuildContext context, WalletEvent event) {
    event.when(initial: () {});
  }

  Widget _buildSuccess(BuildContext context, WalletState state) {
    return Column(
      children: [
        _buildTopBar(context, state.selectedNetwork),
        const SizedBox(height: 16),
        SizedBox(
          child: WalletListPage(
            selectedWallet: state.selectedWallet,
            onWalletChanged: (wallet) {
              context.read<WalletBloc>().add(WalletAction.selectWallet(wallet));
            },
          ),
        ),
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
              Tab(text: WalletStrings.t.tokenList.title),
              Tab(text: WalletStrings.t.nftsList.title),
            ],
          ).paddingSymmetric(horizontal: 5.0),
        ).marginSymmetric(horizontal: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              KeepAliveWidget(
                child: TokenListPage(
                  key: ValueKey(state.selectedWallet?.address),
                  walletAddress: state.selectedWallet?.address,
                ),
              ).paddingSymmetric(horizontal: 16.0),
              const KeepAliveWidget(child: NftsListPage()).paddingSymmetric(horizontal: 16.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, NetworkSelectionEntity? selectedNetwork) {
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
              child: const AnimatedBoringAvatar(
                name: 'ZenoWallet - Pieter',
                type: .beam,
                duration: Duration(milliseconds: 300),
              ),
            ),
          ),
        ),
        const SizedBox(width: 42),
        const Expanded(child: SizedBox.shrink()),
        InkWell(
          onTap: () async {
            final result = await context.router.push(const NetworkSelectionRoute());
            if (result != null && result is NetworkSelectionEntity && mounted) {
              bloc.add(WalletAction.selectNetwork(result));
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
                  selectedNetwork?.name ?? WalletStrings.t.networkSelection.selectNetwork,
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
          child: TokenActionButton(
            icon: Assets.images.icSend,
            title: WalletStrings.t.wallet.actionSend,
          ),
        ),
        InkWell(
          onTap: () => context.showCommingSoon(),
          child: TokenActionButton(
            icon: Assets.images.icReceive,
            title: WalletStrings.t.wallet.actionReceive,
          ),
        ),
        InkWell(
          onTap: () => context.showCommingSoon(),
          child: TokenActionButton(
            icon: Assets.images.icBuy,
            title: WalletStrings.t.wallet.actionBuy,
          ),
        ),
        InkWell(
          onTap: () => context.showCommingSoon(),
          child: TokenActionButton(
            icon: Assets.images.icStaking,
            title: WalletStrings.t.wallet.actionStaking,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 50);
  }
}

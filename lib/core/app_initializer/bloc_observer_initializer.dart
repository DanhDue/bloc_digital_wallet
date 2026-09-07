// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:d3_nexus_shield/logging/module_gated_bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../di/injection.dart';
import 'package:core/core.dart';

class BlocObserverInitializer implements AppInitializer {
  @override
  Future<void> init() async {
    // Initialize Bloc Observer, gated live by the "Framework" module
    // toggle (same pattern as ModuleGatedInterceptor for Dio) -- see
    // ModuleGatedBlocObserver's own doc comment for why TalkerBlocObserver
    // needs this wrapper at all (it writes directly to Talker, bypassing
    // D3NexusLogger's own always-live dispatch).
    Bloc.observer = ModuleGatedBlocObserver(
      module: 'Framework',
      delegate: TalkerBlocObserver(
        talker: getIt<Talker>(),
        settings: const TalkerBlocLoggerSettings(
          printStateFullData: false,
          printEventFullData: false,
        ),
      ),
    );
  }
}

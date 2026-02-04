// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../di/injection.dart';
import 'package:core/core.dart';

class BlocObserverInitializer implements AppInitializer {
  @override
  Future<void> init() async {
    // Initialize Bloc Observer
    Bloc.observer = TalkerBlocObserver(
      talker: getIt<Talker>(),
      settings: const TalkerBlocLoggerSettings(
        printStateFullData: false,
        printEventFullData: false,
      ),
    );
  }
}

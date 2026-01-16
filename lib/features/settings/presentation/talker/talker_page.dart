// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../di/injection.dart';

@RoutePage()
class TalkerPage extends StatelessWidget {
  const TalkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TalkerScreen(talker: getIt<Talker>());
  }
}

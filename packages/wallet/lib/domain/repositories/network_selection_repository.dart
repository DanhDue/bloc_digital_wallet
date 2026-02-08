// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import '../entities/network_selection_entity.dart';

abstract class NetworkSelectionRepository {
  Future<Either<Failure, List<NetworkSelectionEntity>>> getNetworks();
}

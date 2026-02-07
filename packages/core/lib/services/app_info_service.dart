// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class AppInfoService {
  Future<PackageInfo> getPackageInfo();
}

@LazySingleton(as: AppInfoService)
class AppInfoServiceImpl implements AppInfoService {
  @override
  Future<PackageInfo> getPackageInfo() {
    return PackageInfo.fromPlatform();
  }
}

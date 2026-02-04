// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';
import 'package:injectable/injectable.dart';

@singleton
class AuthStreamService {
  final _controller = StreamController<void>.broadcast();

  Stream<void> get onLoggedOut => _controller.stream;

  void logout() {
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}

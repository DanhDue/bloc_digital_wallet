// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:developer';

import 'package:dio/dio.dart';

void main() {
  final options = RequestOptions(
    path: 'settings',
    baseUrl: 'https://digital-wallet-93c4ba68a41d.herokuapp.com/api/v1/',
  );
  log(options.uri.toString());

  final options2 = RequestOptions(
    path: '/sync/bootstrap',
    baseUrl: 'https://digital-wallet-93c4ba68a41d.herokuapp.com/api/v1/',
  );
  log(options2.uri.toString());
}

// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:developer';

import 'package:dio/dio.dart';

void main() {
  final options = RequestOptions(
    path: '',
    baseUrl: 'https://digital-wallet-93c4ba68a41d.herokuapp.com/api/v1/settings',
  );
  log(options.uri.toString());
}

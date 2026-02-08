// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// Re-export shared packages for transitive dependencies
export 'package:bloc/bloc.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:freezed_annotation/freezed_annotation.dart';
export 'package:get_it/get_it.dart';
export 'package:equatable/equatable.dart';
export 'package:dartz/dartz.dart' hide State, Order, order;
export 'package:injectable/injectable.dart' hide Order, order;
export 'package:dio/dio.dart' hide Headers;
export 'package:retrofit/retrofit.dart';
export 'package:json_annotation/json_annotation.dart';
export 'package:slang/slang.dart';
export 'package:slang_flutter/slang_flutter.dart';
export 'package:auto_route/auto_route.dart';
export 'errors/exceptions.dart';
export 'errors/failures.dart';
export 'extensions/widget_extensions.dart';

export 'utils/log.dart';
export 'utils/route_utils.dart';
export 'utils/feature_public_routes.dart';
export 'utils/secure_clipboard.dart';
export 'auth/auth_local_datasource.dart';
export 'auth/token_refresher.dart';

export 'services/auth_stream_service.dart';
export 'services/app_info_service.dart';
export 'utils/good_log.dart';
export 'utils/constants.dart';
export 'generated/translations.dart';
export 'app_initializer/app_initializer.dart';
export 'app_initializer/app_initializer_impl.dart';
export 'config/environment_config.dart';
// DI
export 'di/core_module.dart';
export 'localization/localization_manager.dart';

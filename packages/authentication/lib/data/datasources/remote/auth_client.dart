// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:authentication/data/datasources/remote/authentication_uri.dart';
import 'package:authentication/data/models/auth_user_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  @POST('/${AuthenticationUri.login}')
  Future<AuthUserModel> login({
    @Field('email') required String email,
    @Field('password') required String password,
  });

  @POST('/${AuthenticationUri.register}')
  Future<AuthUserModel> register({
    @Field('email') required String email,
    @Field('password') required String password,
    @Field('first_name') required String firstName,
    @Field('last_name') required String lastName,
    @Field('phone_number') required String phoneNumber,
    @Field('date_of_birth') required String dateOfBirth,
  });

  @POST('/password/reset')
  Future<void> sendPasswordResetEmail({@Field('email') required String email});

  @POST('/code/verify')
  Future<void> verifyResetCode({@Field('code') required String code});

  @POST('/${AuthenticationUri.refreshToken}')
  Future<AuthUserModel> refreshToken({@Field('refresh') required String refresh});
}

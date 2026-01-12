// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bloc_digital_wallet/counter/cubit/counter_cubit.dart' as _i348;
import 'package:bloc_digital_wallet/features/authentication/data/datasources/auth_remote_datasource.dart'
    as _i891;
import 'package:bloc_digital_wallet/features/authentication/data/repositories/authentication_repository_impl.dart'
    as _i558;
import 'package:bloc_digital_wallet/features/authentication/domain/repositories/authentication_repository.dart'
    as _i941;
import 'package:bloc_digital_wallet/features/authentication/domain/usecases/forgot_password_usecase.dart'
    as _i166;
import 'package:bloc_digital_wallet/features/authentication/domain/usecases/login_with_email_password_usecase.dart'
    as _i384;
import 'package:bloc_digital_wallet/features/authentication/domain/usecases/register_with_email_usecase.dart'
    as _i2;
import 'package:bloc_digital_wallet/features/authentication/domain/usecases/verify_code_usecase.dart'
    as _i1059;
import 'package:bloc_digital_wallet/features/authentication/presentation/code_verification/code_verification_bloc.dart'
    as _i150;
import 'package:bloc_digital_wallet/features/authentication/presentation/forgot_password/forgot_password_bloc.dart'
    as _i124;
import 'package:bloc_digital_wallet/features/authentication/presentation/login/login_bloc.dart'
    as _i859;
import 'package:bloc_digital_wallet/features/authentication/presentation/register/register_bloc.dart'
    as _i795;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i348.CounterCubit>(() => _i348.CounterCubit());
    gh.lazySingleton<_i891.AuthRemoteDataSource>(
      () => _i891.AuthRemoteDataSource(),
    );
    gh.lazySingleton<_i941.AuthenticationRepository>(
      () =>
          _i558.AuthenticationRepositoryImpl(gh<_i891.AuthRemoteDataSource>()),
    );
    gh.factory<_i166.ForgotPasswordUseCase>(
      () => _i166.ForgotPasswordUseCase(gh<_i941.AuthenticationRepository>()),
    );
    gh.factory<_i1059.VerifyCodeUseCase>(
      () => _i1059.VerifyCodeUseCase(gh<_i941.AuthenticationRepository>()),
    );
    gh.factory<_i150.CodeVerificationBloc>(
      () => _i150.CodeVerificationBloc(gh<_i1059.VerifyCodeUseCase>()),
    );
    gh.factory<_i124.ForgotPasswordBloc>(
      () => _i124.ForgotPasswordBloc(gh<_i166.ForgotPasswordUseCase>()),
    );
    gh.factory<_i384.LoginWithEmailPasswordUseCase>(
      () => _i384.LoginWithEmailPasswordUseCase(
        gh<_i941.AuthenticationRepository>(),
      ),
    );
    gh.factory<_i2.RegisterWithEmailUseCase>(
      () => _i2.RegisterWithEmailUseCase(gh<_i941.AuthenticationRepository>()),
    );
    gh.factory<_i859.LoginBloc>(
      () => _i859.LoginBloc(gh<_i384.LoginWithEmailPasswordUseCase>()),
    );
    gh.factory<_i795.RegisterBloc>(
      () => _i795.RegisterBloc(gh<_i2.RegisterWithEmailUseCase>()),
    );
    return this;
  }
}

// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// Domain Layer
export 'domain/entities/auth_user_entity.dart';
export 'domain/repositories/authentication_repository.dart';
export 'domain/usecases/login_with_email_password_usecase.dart';

// Presentation Layer - Login Subfeature
export 'presentation/login/login_page.dart';
export 'presentation/login/login_bloc.dart';
export 'presentation/login/login_state.dart';
export 'presentation/login/login_event.dart';
export 'presentation/login/login_action.dart';
export 'presentation/login/models/login_ui_model.dart';

// Presentation Layer - Widgets
export 'presentation/widgets/auth_text_field.dart';
export 'presentation/widgets/social_login_button.dart';

// DI
export 'di/injection.dart';

// Router
export 'authentication_router.dart';

// Translations
export 'generated/translations.dart';
export 'auth_strings.dart';
